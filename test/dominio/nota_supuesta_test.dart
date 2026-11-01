import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/evaluacion.dart';
import 'package:app_academica/dominio/nota_supuesta.dart';

Evaluacion ev(int id, int porcentaje, int? nota, {int? supuesta}) => Evaluacion(
      id: id,
      materiaId: 1,
      nombre: 'E$id',
      porcentaje: porcentaje,
      nota: nota,
      notaSupuesta: supuesta,
    );

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

  group('leerNotaSupuesta: texto y escala', () {
    final pendiente = ev(1, 10000, null);
    LecturaSupuesta leer(String t, [ConfiguracionEscala escala = itm]) =>
        leerNotaSupuesta(t, pendiente, [pendiente], escala);

    test('acepta punto, coma y enteros', () {
      expect(leer('4.0').valor, 400);
      expect(leer('4,0').valor, 400);
      expect(leer('4').valor, 400);
      expect(leer('0').valor, 0);
      expect(leer('5').valor, 500);
    });
    test('texto que no es número', () {
      expect(leer('abc').error, 'Escribe un número, por ejemplo 3.5');
      expect(leer('').error, 'Escribe un número, por ejemplo 3.5');
    });
    test('fuera de la escala', () {
      expect(leer('5.1').error, 'La nota debe estar entre 0.0 y 5.0.');
    });
    test('más decimales de los configurados', () {
      expect(leer('3.45').error, 'La nota puede tener máximo 1 decimal.');
      expect(leer('85.5', ConfiguracionEscala.cien).error,
          'La nota no puede tener decimales.');
      expect(leer('85', ConfiguracionEscala.cien).valor, 8500);
    });
  });

  group('leerNotaSupuesta: debe estar pendiente', () {
    test('hoja con nota real', () {
      final e = ev(1, 10000, 300);
      expect(leerNotaSupuesta('4', e, [e], itm).error,
          'Esta evaluación ya tiene nota.');
    });
    test('compuesta con todas sus notas', () {
      final todas = [ev(1, 10000, null), sub(2, 1, 300), sub(3, 1, 350)];
      expect(leerNotaSupuesta('4', todas[0], todas, itm).error,
          'E1 ya tiene todas sus notas.');
    });
    test('hija de una compuesta fijada entera', () {
      final todas = [
        ev(1, 10000, null, supuesta: 350),
        sub(2, 1, null),
        sub(3, 1, null),
      ];
      expect(leerNotaSupuesta('4', todas[1], todas, itm).error,
          'E1 tiene una nota supuesta completa. Quítala para suponer sus partes.');
      // Sin la suposición entera, la hija sí se puede fijar.
      final libres = [ev(1, 10000, null), todas[1], todas[2]];
      expect(leerNotaSupuesta('4', libres[1], libres, itm).valor, 400);
    });
  });

  group('compuesta fijada entera: rango alcanzable', () {
    test('un quiz en 0.0 de tres: máximo R(3.33) = 3.3', () {
      final todas = [
        ev(1, 10000, null),
        sub(2, 1, 0),
        sub(3, 1, null),
        sub(4, 1, null),
      ];
      expect(leerNotaSupuesta('3.3', todas[0], todas, itm).valor, 330);
      expect(leerNotaSupuesta('3.4', todas[0], todas, itm).error,
          'Con las notas que ya tiene, E1 solo puede quedar entre 0.0 y 3.3.');
    });
    test('un quiz en 5.0 de tres: mínimo R(1.67) = 1.7', () {
      final todas = [
        ev(1, 10000, null),
        sub(2, 1, 500),
        sub(3, 1, null),
        sub(4, 1, null),
      ];
      expect(leerNotaSupuesta('1.7', todas[0], todas, itm).valor, 170);
      expect(leerNotaSupuesta('1.6', todas[0], todas, itm).esValida, isFalse);
    });
    test('sin redondeo intermedio el rango se ajusta hacia adentro', () {
      // Un quiz en 1.0 de tres: va de 0.33… a 3.66…
      final hijas = [sub(2, 1, 100), sub(3, 1, null), sub(4, 1, null)];
      expect(rangoCompuesta(hijas, itm), (30, 370));
      expect(
          rangoCompuesta(hijas, itm.copyWith(redondearIntermedias: false)),
          (40, 360));
    });
    test('sin hijas calificadas el rango es toda la escala', () {
      final hijas = [sub(2, 1, null), sub(3, 1, null)];
      expect(rangoCompuesta(hijas, itm), (0, 500));
    });
  });
}
