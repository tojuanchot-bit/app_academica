import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/calculo_notas.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/evaluacion.dart';
import 'package:app_academica/dominio/materia.dart';
import 'package:app_academica/dominio/redondeo.dart';

/// Evaluación de primer nivel.
Evaluacion ev(int id, int porcentaje, int? nota) => Evaluacion(
      id: id,
      materiaId: 1,
      nombre: 'E$id',
      porcentaje: porcentaje,
      nota: nota,
    );

/// Sub-evaluación en partes iguales.
Evaluacion sub(int id, int padreId, int? nota) =>
    Evaluacion(id: id, materiaId: 1, padreId: padreId, nombre: 'Q$id', nota: nota);

void main() {
  const itm = ConfiguracionEscala.itm;

  group('Fraccion', () {
    test('suma, por y entre simplifican', () {
      final f = const Fraccion(1, 2) + const Fraccion(1, 3);
      expect(f.numerador, 5);
      expect(f.denominador, 6);
      expect(const Fraccion(3, 4).por(2), const Fraccion(3, 2));
      expect(const Fraccion(3, 1).entre(6), const Fraccion(1, 2));
    });
  });

  group('definitiva', () {
    test('4.5 al 30 % y 3.0 al 70 % → 3.45 → 3.5 (la trampa del double)', () {
      expect(definitiva([ev(1, 3000, 450), ev(2, 7000, 300)], itm), 350);
    });
    test('0.5 al 30 % y 4.0 al 70 % → 2.95 → 3.0, aprueba', () {
      expect(definitiva([ev(1, 3000, 50), ev(2, 7000, 400)], itm), 300);
    });
    test('null si los porcentajes no suman 100 % o falta una nota', () {
      expect(definitiva([ev(1, 3000, 400), ev(2, 6000, 400)], itm), isNull);
      expect(definitiva([ev(1, 3000, 400), ev(2, 7000, null)], itm), isNull);
    });
    test('con evaluación compuesta redondeada (D-008)', () {
      // Seguimiento 40 % = R((3.4 + 3.5) / 2) = 3.5; Final 60 % = 3.0.
      // 3.5 × 0.4 + 3.0 × 0.6 = 3.2
      final todas = [ev(1, 4000, null), sub(2, 1, 340), sub(3, 1, 350),
          ev(4, 6000, 300)];
      expect(definitiva(todas, itm), 320);
    });
    test('sin redondear intermedias el resultado puede cambiar', () {
      // Seguimiento 50 % con quices 3.4 y 3.5; Final 50 % = 2.4.
      // Redondeando: R(3.45) = 3.5 → (3.5 + 2.4) / 2 = 2.95 → 3.0 (aprueba).
      // Sin redondear: (3.45 + 2.4) / 2 = 2.925 → 2.9 (reprueba).
      final todas = [ev(1, 5000, null), sub(2, 1, 340), sub(3, 1, 350),
          ev(4, 5000, 240)];
      expect(definitiva(todas, itm), 300);
      expect(
          definitiva(todas, itm.copyWith(redondearIntermedias: false)), 290);
    });
  });

  test('acumuladoPresentado: lo pendiente cuenta como 0', () {
    // 4.0 × 0.3 + 3.0 × 0.3 = 2.1
    final todas = [ev(1, 3000, 400), ev(2, 3000, 300), ev(3, 4000, null)];
    expect(acumuladoPresentado(todas, itm), 210);
  });

  test('contarPendientes no cuenta a la compuesta, sí a sus hijas', () {
    final todas = [ev(1, 4000, null), sub(2, 1, 300), sub(3, 1, null),
        ev(4, 6000, null)];
    expect(contarPendientes(todas), 2);
  });

  group('proyectar (D-009)', () {
    test('necesita 4.0, aunque despejar la fórmula daría 4.2', () {
      // 2.0 × 0.3 + 2.5 × 0.3 + 0.4x ≥ 2.95 → x ≥ 4.0 con redondeo.
      final todas = [ev(1, 3000, 200), ev(2, 3000, 250), ev(3, 4000, null)];
      final p = proyectar(todas, itm, meta: 300);
      expect(p.tipo, TipoProyeccion.necesita);
      expect(p.nota, 400);
    });
    test('con evaluación compuesta pendiente', () {
      // Final 60 % = 3.0; Seguimiento 40 % = R((3.0 + x) / 2).
      // x = 2.7 → 2.85 → 2.9 → 1.8 + 1.16 = 2.96 → 3.0.
      final todas = [ev(1, 4000, null), sub(2, 1, 300), sub(3, 1, null),
          ev(4, 6000, 300)];
      final p = proyectar(todas, itm, meta: 300);
      expect(p.tipo, TipoProyeccion.necesita);
      expect(p.nota, 270);
    });
    test('asegurada', () {
      final todas = [ev(1, 3000, 500), ev(2, 3000, 500), ev(3, 4000, null)];
      final p = proyectar(todas, itm, meta: 300);
      expect(p.tipo, TipoProyeccion.asegurada);
      expect(p.nota, 0);
    });
    test('no alcanza: lo máximo posible es 2.0', () {
      final todas = [ev(1, 3000, 0), ev(2, 3000, 0), ev(3, 4000, null)];
      final p = proyectar(todas, itm, meta: 300);
      expect(p.tipo, TipoProyeccion.noAlcanza);
      expect(p.definitivaMaxima, 200);
    });
    test('completa y porcentajes incompletos', () {
      final completa = proyectar([ev(1, 10000, 420)], itm, meta: 300);
      expect(completa.tipo, TipoProyeccion.completa);
      expect(completa.nota, 420);
      final incompleta = proyectar([ev(1, 5000, null)], itm, meta: 300);
      expect(incompleta.tipo, TipoProyeccion.porcentajesIncompletos);
    });
    test('truncando se necesita más', () {
      final truncar = itm.copyWith(modo: ModoRedondeo.truncar);
      final todas = [ev(1, 3000, 200), ev(2, 3000, 250), ev(3, 4000, null)];
      // Sin la ayuda del redondeo: 1.35 + 0.4x ≥ 3.0 → x ≥ 4.125 → 4.2.
      expect(proyectar(todas, truncar, meta: 300).nota, 420);
    });
  });

  test('metasSugeridas', () {
    expect(metasSugeridas(itm), [300, 350, 400, 450]);
    expect(metasSugeridas(ConfiguracionEscala.cien), [6000, 7000, 8000, 9000]);
  });

  group('promedioPonderado', () {
    Materia m(EstadoMateria estado, int creditos, int? nota) => Materia(
          semestreId: 1,
          nombre: 'M',
          creditos: creditos,
          color: 0,
          estado: estado,
          notaFinal: nota,
        );

    test('pondera por créditos: (4.0 × 3 + 3.0 × 4) / 7 = 3.43 → 3.4', () {
      expect(
        promedioPonderado([
          m(EstadoMateria.aprobada, 3, 400),
          m(EstadoMateria.aprobada, 4, 300),
        ], itm),
        340,
      );
    });
    test('cuenta reprobadas; ignora canceladas y en curso', () {
      expect(
        promedioPonderado([
          m(EstadoMateria.aprobada, 2, 350),
          m(EstadoMateria.reprobada, 2, 340),
          m(EstadoMateria.cancelada, 4, null),
          m(EstadoMateria.enCurso, 4, null),
        ], itm),
        350, // (3.5 + 3.4) / 2 = 3.45 → 3.5
      );
    });
    test('null si no hay materias cerradas', () {
      expect(promedioPonderado([m(EstadoMateria.enCurso, 3, null)], itm),
          isNull);
    });
  });
}
