import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/formato_fecha.dart';
import 'package:app_academica/dominio/semestre.dart';

void main() {
  group('validar', () {
    test('nombre obligatorio', () {
      expect(const Semestre(nombre: ' ').validar(), {ErrorSemestre.nombreVacio});
      expect(const Semestre(nombre: '2026-2').esValido, isTrue);
    });
    test('el fin no puede ser antes del inicio', () {
      final s = Semestre(
        nombre: '2026-2',
        fechaInicio: DateTime(2026, 8, 1),
        fechaFin: DateTime(2026, 7, 1),
      );
      expect(s.validar(), {ErrorSemestre.finAntesDeInicio});
    });
  });

  group('elegirSemestre', () {
    const a = Semestre(id: 1, nombre: '2026-2');
    const b = Semestre(id: 2, nombre: '2026-1', activo: true);
    const c = Semestre(id: 3, nombre: '2025-2');

    test('lista vacía', () {
      expect(elegirSemestre([], null), isNull);
    });
    test('el elegido gana', () {
      expect(elegirSemestre([a, b, c], 3), same(c));
    });
    test('sin elegido (o borrado), el activo', () {
      expect(elegirSemestre([a, b, c], null), same(b));
      expect(elegirSemestre([a, b, c], 99), same(b));
    });
    test('sin activo, el primero', () {
      expect(elegirSemestre([a, c], null), same(a));
    });
  });

  group('formato de fechas', () {
    test('corta y larga', () {
      expect(formatearFecha(DateTime(2026, 10, 30)), '30 oct 2026');
      expect(formatearFechaLarga(DateTime(2026, 10, 30)),
          'viernes 30 de octubre');
      expect(formatearFechaLarga(DateTime(2026, 11, 1)),
          'domingo 1 de noviembre');
    });
  });
}
