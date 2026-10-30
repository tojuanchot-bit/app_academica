import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/materia.dart';

void main() {
  const itm = ConfiguracionEscala.itm;
  const fisica = Materia(
    id: 1,
    semestreId: 1,
    nombre: 'Física Mecánica',
    docente: 'Mateo',
    creditos: 4,
    color: 0xFF00838F,
  );

  group('validar', () {
    test('una materia nueva es válida y empieza en curso', () {
      expect(fisica.esValida, isTrue);
      expect(fisica.estado, EstadoMateria.enCurso);
    });
    test('nombre vacío', () {
      expect(fisica.copyWith(nombre: '  ').validar(),
          {ErrorMateria.nombreVacio});
    });
    test('créditos negativos o demasiados', () {
      expect(fisica.copyWith(creditos: -1).validar(),
          {ErrorMateria.creditosFueraDeRango});
      expect(fisica.copyWith(creditos: 31).validar(),
          {ErrorMateria.creditosFueraDeRango});
      expect(fisica.copyWith(creditos: 0).esValida, isTrue);
    });
  });

  group('cancelar', () {
    test('guarda el estado y solo el día', () {
      final c = fisica.cancelar(DateTime(2026, 10, 30, 15, 42));
      expect(c.estado, EstadoMateria.cancelada);
      expect(c.fechaCancelacion, DateTime(2026, 10, 30));
      expect(c.nombre, fisica.nombre);
    });
    test('no se puede cancelar dos veces ni una cerrada', () {
      final c = fisica.cancelar(DateTime(2026, 10, 30));
      expect(() => c.cancelar(DateTime(2026, 10, 31)), throwsStateError);
      expect(() => fisica.cerrar(400, itm).cancelar(DateTime(2026, 11, 1)),
          throwsStateError);
    });
  });

  group('cerrar', () {
    test('3.0 aprueba y 2.9 reprueba en la escala ITM', () {
      expect(fisica.cerrar(300, itm).estado, EstadoMateria.aprobada);
      expect(fisica.cerrar(290, itm).estado, EstadoMateria.reprobada);
      expect(fisica.cerrar(300, itm).notaFinal, 300);
    });
    test('notas fuera de la escala o con más decimales fallan', () {
      expect(() => fisica.cerrar(510, itm), throwsArgumentError);
      expect(() => fisica.cerrar(305, itm), throwsArgumentError);
    });
    test('no se puede cerrar una cancelada', () {
      final c = fisica.cancelar(DateTime(2026, 10, 30));
      expect(() => c.cerrar(400, itm), throwsStateError);
    });
  });

  test('reabrir borra la fecha de cancelación y la nota', () {
    final desdeCancelada = fisica.cancelar(DateTime(2026, 10, 30)).reabrir();
    expect(desdeCancelada, equals(fisica));
    final desdeCerrada = fisica.cerrar(450, itm).reabrir();
    expect(desdeCerrada.notaFinal, isNull);
    expect(desdeCerrada.estado, EstadoMateria.enCurso);
  });

  test('resumenCreditos suma por estado', () {
    final materias = [
      fisica,
      fisica.copyWith(creditos: 3),
      fisica.cerrar(400, itm),
      fisica.cerrar(200, itm),
      fisica.cancelar(DateTime(2026, 10, 30)),
    ];
    final r = resumenCreditos(materias);
    expect(r.enCurso, 7);
    expect(r.aprobados, 4);
    expect(r.reprobados, 4);
    expect(r.cancelados, 4);
  });
}
