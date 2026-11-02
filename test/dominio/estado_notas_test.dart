import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/estado_notas.dart';
import 'package:app_academica/dominio/evaluacion.dart';
import 'package:app_academica/dominio/materia.dart';

Evaluacion ev(int id, int porcentaje, int? nota) => Evaluacion(
      id: id,
      materiaId: 1,
      nombre: 'E$id',
      porcentaje: porcentaje,
      nota: nota,
    );

Materia materia({
  int id = 1,
  EstadoMateria estado = EstadoMateria.enCurso,
  int? notaFinal,
}) =>
    Materia(
      id: id,
      semestreId: 1,
      nombre: 'M$id',
      creditos: 3,
      color: 0xFF6A4BC4,
      estado: estado,
      notaFinal: notaFinal,
    );

void main() {
  const itm = ConfiguracionEscala.itm;
  EstadoNotas en(List<Evaluacion> todas) =>
      estadoNotas(materia(), todas, itm);

  group('estadoNotas, materia en curso', () {
    test('asegurada: 5.0 al 60 % ya da 3.0 → aprobando', () {
      expect(en([ev(1, 6000, 500), ev(2, 4000, null)]), EstadoNotas.aprobando);
    });
    test('necesita exactamente 3.0 → aprobando, no en riesgo', () {
      expect(en([ev(1, 5000, 300), ev(2, 5000, null)]), EstadoNotas.aprobando);
    });
    test('necesita 3.0 gracias al redondeo (2.95 → 3.0) → aprobando', () {
      expect(en([ev(1, 5000, 290), ev(2, 5000, null)]), EstadoNotas.aprobando);
    });
    test('necesita 4.0 → en riesgo', () {
      expect(en([ev(1, 5000, 200), ev(2, 5000, null)]), EstadoNotas.enRiesgo);
    });
    test('ni con 5.0 llega → no alcanza', () {
      expect(en([ev(1, 5000, 0), ev(2, 5000, null)]), EstadoNotas.noAlcanza);
    });
    test('completa con 3.5 → completa; con 2.5 → no alcanza', () {
      expect(en([ev(1, 10000, 350)]), EstadoNotas.completa);
      expect(en([ev(1, 10000, 250)]), EstadoNotas.noAlcanza);
    });
    test('sin evaluaciones o sin el 100 % → faltan porcentajes', () {
      expect(en([]), EstadoNotas.sinPorcentajes);
      expect(en([ev(1, 5000, null)]), EstadoNotas.sinPorcentajes);
    });
    test('solo en riesgo y no alcanza son alertas', () {
      expect(
        EstadoNotas.values.where((e) => e.esAlerta).toList(),
        [EstadoNotas.enRiesgo, EstadoNotas.noAlcanza],
      );
    });
  });

  group('estadoNotas, materia cerrada o cancelada', () {
    test('manda el estado de la materia, no las evaluaciones', () {
      final enRiesgo = [ev(1, 5000, 200), ev(2, 5000, null)];
      expect(
        estadoNotas(materia(estado: EstadoMateria.aprobada, notaFinal: 420),
            enRiesgo, itm),
        EstadoNotas.aprobada,
      );
      expect(
        estadoNotas(materia(estado: EstadoMateria.reprobada, notaFinal: 260),
            enRiesgo, itm),
        EstadoNotas.reprobada,
      );
      expect(
        estadoNotas(materia(estado: EstadoMateria.cancelada), enRiesgo, itm),
        EstadoNotas.cancelada,
      );
    });
  });

  group('ordenParaNotas', () {
    test('canceladas al final, sin cambiar el orden de las demás', () {
      final a = materia(id: 1);
      final b = materia(id: 2, estado: EstadoMateria.cancelada);
      final c = materia(id: 3, estado: EstadoMateria.aprobada, notaFinal: 400);
      final d = materia(id: 4);
      expect(ordenParaNotas([a, b, c, d]), [a, c, d, b]);
    });
  });

  group('sePuedeProyectar', () {
    final pendiente = [ev(1, 5000, 300), ev(2, 5000, null)];
    test('en curso, 100 % y con pendientes → sí', () {
      expect(sePuedeProyectar(materia(), pendiente), isTrue);
    });
    test('sin pendientes → no', () {
      expect(sePuedeProyectar(materia(), [ev(1, 10000, 350)]), isFalse);
    });
    test('porcentajes incompletos o sin evaluaciones → no', () {
      expect(sePuedeProyectar(materia(), [ev(1, 5000, null)]), isFalse);
      expect(sePuedeProyectar(materia(), []), isFalse);
    });
    test('cerrada o cancelada → no, aunque tenga pendientes', () {
      expect(
        sePuedeProyectar(
            materia(estado: EstadoMateria.aprobada, notaFinal: 400), pendiente),
        isFalse,
      );
      expect(
        sePuedeProyectar(materia(estado: EstadoMateria.cancelada), pendiente),
        isFalse,
      );
    });
    test('una compuesta con sub-evaluación pendiente cuenta como pendiente', () {
      final todas = [
        ev(1, 5000, null),
        Evaluacion(id: 2, materiaId: 1, padreId: 1, nombre: 'Q1', nota: 400),
        Evaluacion(id: 3, materiaId: 1, padreId: 1, nombre: 'Q2'),
        ev(4, 5000, 300),
      ];
      expect(sePuedeProyectar(materia(), todas), isTrue);
    });
  });
}
