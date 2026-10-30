import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/redondeo.dart';

void main() {
  const r = ModoRedondeo.redondear;
  const t = ModoRedondeo.truncar;

  group('1 decimal (ITM)', () {
    test('3.45 → 3.5: la mitad sube', () {
      expect(redondearNota(345, 100, decimales: 1, modo: r), 35);
    });
    test('3.44 → 3.4', () {
      expect(redondearNota(344, 100, decimales: 1, modo: r), 34);
    });
    test('truncar: 3.45 → 3.4 y 3.49 → 3.4', () {
      expect(redondearNota(345, 100, decimales: 1, modo: t), 34);
      expect(redondearNota(349, 100, decimales: 1, modo: t), 34);
    });
  });

  group('la trampa del double', () {
    test('con double, 4.5 al 30 % + 3.0 al 70 % redondea mal a 3.4', () {
      final x = 4.5 * 0.3 + 3.0 * 0.7; // 3.4499999999999993
      expect((x * 10 + 0.5).floor(), 34); // documenta el error: debería ser 35
    });
    test('el mismo cálculo en enteros da 3.5', () {
      final suma = 45 * 3000 + 30 * 7000; // 345000
      expect(redondearNota(suma, 10 * 10000, decimales: 1, modo: r), 35);
    });
    test('0.5 al 30 % + 4.0 al 70 % = 2.95 → 3.0: aprueba', () {
      final suma = 5 * 3000 + 40 * 7000; // 295000
      expect(redondearNota(suma, 10 * 10000, decimales: 1, modo: r), 30);
    });
  });

  group('otros decimales', () {
    test('0 decimales: 3.45 → 3 y 3.5 → 4', () {
      expect(redondearNota(345, 100, decimales: 0, modo: r), 3);
      expect(redondearNota(350, 100, decimales: 0, modo: r), 4);
    });
    test('2 decimales: 1.005 → 1.01 (el clásico que falla con double)', () {
      expect(redondearNota(1005, 1000, decimales: 2, modo: r), 101);
    });
  });

  group('errores', () {
    test('denominador 0 o negativo', () {
      expect(() => redondearNota(1, 0, decimales: 1, modo: r), throwsArgumentError);
      expect(() => redondearNota(1, -5, decimales: 1, modo: r), throwsArgumentError);
    });
    test('numerador negativo', () {
      expect(() => redondearNota(-1, 10, decimales: 1, modo: r), throwsArgumentError);
    });
  });

  group('formatearNota', () {
    test('formatos', () {
      expect(formatearNota(35, 1), '3.5');
      expect(formatearNota(5, 1), '0.5');
      expect(formatearNota(101, 2), '1.01');
      expect(formatearNota(100, 2), '1.00');
      expect(formatearNota(4, 0), '4');
    });
  });

  group('parsearCentesimas', () {
    test('acepta enteros, punto y coma', () {
      expect(parsearCentesimas('3'), 300);
      expect(parsearCentesimas('3.5'), 350);
      expect(parsearCentesimas('3,45'), 345);
      expect(parsearCentesimas(' 0.05 '), 5);
      expect(parsearCentesimas('100'), 10000);
      expect(parsearCentesimas('3.'), 300);
    });
    test('rechaza texto inválido, negativos y más de 2 decimales', () {
      expect(parsearCentesimas(''), isNull);
      expect(parsearCentesimas('abc'), isNull);
      expect(parsearCentesimas('-1'), isNull);
      expect(parsearCentesimas('3.456'), isNull);
      expect(parsearCentesimas('.5'), isNull);
    });
  });

  group('formatearCentesimas', () {
    test('usa los decimales de la escala', () {
      expect(formatearCentesimas(300, 1), '3.0');
      expect(formatearCentesimas(300, 0), '3');
      expect(formatearCentesimas(300, 2), '3.00');
    });
    test('si no cabe en esos decimales, muestra 2', () {
      expect(formatearCentesimas(305, 1), '3.05');
    });
  });
}
