import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/calculo_notas.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/evaluacion.dart';

/// Evaluación de primer nivel, con nota supuesta opcional.
Evaluacion ev(int id, int porcentaje, int? nota, {int? supuesta}) => Evaluacion(
      id: id,
      materiaId: 1,
      nombre: 'E$id',
      porcentaje: porcentaje,
      nota: nota,
      notaSupuesta: supuesta,
    );

/// Sub-evaluación en partes iguales, con nota supuesta opcional.
Evaluacion sub(int id, int padreId, int? nota, {int? supuesta}) => Evaluacion(
      id: id,
      materiaId: 1,
      padreId: padreId,
      nombre: 'Q$id',
      nota: nota,
      notaSupuesta: supuesta,
    );

void main() {
  const itm = ConfiguracionEscala.itm;

  Proyeccion conSupuestas(List<Evaluacion> todas) =>
      proyectar(todas, itm, meta: 300, usarSupuestas: true);

  group('proyectar con notas supuestas (fase 2b)', () {
    test('una fijada: Parcial 2 en 4.0 → necesitas 2.7 en el final', () {
      // Parcial 1 30 % = 2.3; Parcial 2 30 % fijado en 4.0; Final 40 %.
      // 0.69 + 1.2 + 0.4 × 2.7 = 2.97 → 3.0. Con 2.6 daría 2.93 → 2.9.
      final todas = [
        ev(1, 3000, 230),
        ev(2, 3000, null, supuesta: 400),
        ev(3, 4000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.tipo, TipoProyeccion.necesita);
      expect(p.nota, 270);
      expect(p.buscadas, 1);

      // Sin la suposición vuelve al cálculo normal: 3.3 en ambas.
      final normal = proyectar(todas, itm, meta: 300);
      expect(normal.nota, 330);
      expect(normal.buscadas, 2);
    });

    test('varias fijadas: solo se busca en la que queda', () {
      // 0.6 + 0.7 + 0.8 = 2.1; 2.1 + 0.4 × 2.2 = 2.98 → 3.0 (2.1 da 2.94).
      final todas = [
        ev(1, 2000, 300),
        ev(2, 2000, null, supuesta: 350),
        ev(3, 2000, null, supuesta: 400),
        ev(4, 4000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.tipo, TipoProyeccion.necesita);
      expect(p.nota, 220);
      expect(p.buscadas, 1);
    });

    test('todas fijadas: simulada con la definitiva resultante', () {
      // 3.0 × 0.5 + 3.5 × 0.5 = 3.25 → 3.3.
      final todas = [ev(1, 5000, 300), ev(2, 5000, null, supuesta: 350)];
      final p = conSupuestas(todas);
      expect(p.tipo, TipoProyeccion.simulada);
      expect(p.nota, 330);
      expect(p.buscadas, 0);
    });

    test('una fijada que hace imposible la meta', () {
      // 0.6 + 0.3 + 0.4 × 5.0 = 2.9: ni con 5.0 se llega a 3.0.
      final todas = [
        ev(1, 3000, 200),
        ev(2, 3000, null, supuesta: 100),
        ev(3, 4000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.tipo, TipoProyeccion.noAlcanza);
      expect(p.definitivaMaxima, 290);
      // Sin suponer, sí alcanza.
      expect(proyectar(todas, itm, meta: 300).tipo, TipoProyeccion.necesita);
    });

    test('una fijada que ya asegura la meta', () {
      // 1.5 + 1.5 + 0.4 × 0.0 = 3.0.
      final todas = [
        ev(1, 3000, 500),
        ev(2, 3000, null, supuesta: 500),
        ev(3, 4000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.tipo, TipoProyeccion.asegurada);
      expect(p.nota, 0);
      expect(proyectar(todas, itm, meta: 300).nota, 210);
    });

    test('sub-evaluación fijada con redondeo intermedio', () {
      // Seguimiento 40 % = R((3.0 + 2.7) / 2) = R(2.85) = 2.9; Final 60 %.
      // 1.16 + 0.6 × 3.0 = 2.96 → 3.0 (con 2.9 da 2.90).
      final todas = [
        ev(1, 4000, null),
        sub(2, 1, 300),
        sub(3, 1, null, supuesta: 270),
        ev(4, 6000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.nota, 300);
      expect(p.buscadas, 1);

      // Sin redondear intermedias: 1.14 + 0.6 × 3.1 = 3.0 (con 3.0 da 2.94).
      final sinRedondeo = proyectar(
          todas, itm.copyWith(redondearIntermedias: false),
          meta: 300, usarSupuestas: true);
      expect(sinRedondeo.nota, 310);
    });

    test('compuesta fijada entera: sus hijas no se buscan', () {
      // Seguimiento 40 % fijado en 3.5: 1.4 + 0.6 × 2.6 = 2.96 → 3.0.
      final todas = [
        ev(1, 4000, null, supuesta: 350),
        sub(2, 1, null),
        sub(3, 1, null),
        ev(4, 6000, null),
      ];
      final p = conSupuestas(todas);
      expect(p.nota, 260);
      expect(p.buscadas, 1);
    });

    test('compuesta fijada entera ignora las supuestas de sus hijas', () {
      final padre = ev(1, 4000, null, supuesta: 350);
      final resto = [
        sub(2, 1, null, supuesta: 0),
        sub(3, 1, null, supuesta: 0),
        ev(4, 6000, null),
      ];
      expect(conSupuestas([padre, ...resto]).nota, 260);

      // Al quitar la suposición entera vuelven a contar las de las hijas:
      // Seguimiento = 0.0 → 0.6x ≥ 2.95 → 5.0.
      final sinEntera = ev(1, 4000, null);
      expect(conSupuestas([sinEntera, ...resto]).nota, 500);
    });

    test('la nota real manda sobre la supuesta', () {
      // E1 tiene 2.0 real y 5.0 supuesta: cuenta 2.0.
      // 0.6 + 0.7 × 3.4 = 2.98 → 3.0 (con 3.3 da 2.91).
      final hoja = [ev(1, 3000, 200, supuesta: 500), ev(2, 7000, null)];
      expect(conSupuestas(hoja).nota, 340);

      // Compuesta con todas sus hijas reales: su suposición no vale.
      final compuesta = [
        ev(1, 4000, null, supuesta: 500),
        sub(2, 1, 300),
        sub(3, 1, 300),
        ev(4, 6000, 300),
      ];
      final p = conSupuestas(compuesta);
      expect(p.tipo, TipoProyeccion.completa);
      expect(p.nota, 300);
    });

    test('pendientesBuscadas nombra solo lo que se busca', () {
      final todas = [
        ev(1, 3000, 230),
        ev(2, 3000, null, supuesta: 400),
        ev(3, 4000, null, supuesta: 350),
        sub(4, 3, null),
        sub(5, 3, null),
      ];
      // E3 es compuesta fijada entera: sus hijas no se buscan, E2 tampoco.
      expect(pendientesBuscadas(todas, usarSupuestas: true), isEmpty);
      expect(
          pendientesBuscadas(todas).map((e) => e.nombre), ['E2', 'Q4', 'Q5']);

      final sinEntera = [todas[0], todas[1], ev(3, 4000, null), todas[3],
          sub(5, 3, null, supuesta: 300)];
      expect(
          pendientesBuscadas(sinEntera, usarSupuestas: true)
              .map((e) => e.nombre),
          ['Q4']);
    });

    test('sin usarSupuestas se ignoran (Hoy, acumulado y cierre)', () {
      final todas = [ev(1, 5000, 300), ev(2, 5000, null, supuesta: 350)];
      expect(definitiva(todas, itm), isNull);
      expect(definitiva(todas, itm, usarSupuestas: true), 330);
      expect(contarPendientes(todas), 1);
      expect(contarPendientes(todas, usarSupuestas: true), 0);
      expect(acumuladoPresentado(todas, itm), 150);
      expect(proyectar(todas, itm, meta: 300).tipo, TipoProyeccion.necesita);
    });
  });
}
