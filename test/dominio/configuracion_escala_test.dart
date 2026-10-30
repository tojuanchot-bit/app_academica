import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/redondeo.dart';

void main() {
  const itm = ConfiguracionEscala.itm;

  group('plantillas', () {
    test('ITM, 0–10 y 0–100 son válidas', () {
      expect(ConfiguracionEscala.itm.esValida, isTrue);
      expect(ConfiguracionEscala.diez.esValida, isTrue);
      expect(ConfiguracionEscala.cien.esValida, isTrue);
    });
  });

  group('validar', () {
    test('mínima igual a máxima', () {
      final e = itm.copyWith(notaMinima: 500);
      expect(e.validar(), contains(ErrorEscala.minimaNoMenorQueMaxima));
    });
    test('mínima negativa', () {
      final e = itm.copyWith(notaMinima: -100);
      expect(e.validar(), contains(ErrorEscala.minimaNegativa));
    });
    test('aprobatoria mayor que la máxima', () {
      final e = itm.copyWith(notaAprobatoria: 600);
      expect(e.validar(), contains(ErrorEscala.aprobatoriaFueraDeRango));
    });
    test('3.05 no cabe con 1 decimal, pero sí con 2', () {
      final unDecimal = itm.copyWith(notaAprobatoria: 305);
      expect(unDecimal.validar(), contains(ErrorEscala.noRepresentable));
      expect(unDecimal.copyWith(decimales: 2).esValida, isTrue);
    });
    test('3 decimales no se permiten', () {
      final e = itm.copyWith(decimales: 3);
      expect(e.validar(), {ErrorEscala.decimalesFueraDeRango});
    });
  });

  group('copyWith e igualdad', () {
    test('copyWith cambia solo lo indicado', () {
      final e = itm.copyWith(notaAprobatoria: 350);
      expect(e.notaAprobatoria, 350);
      expect(e.notaMaxima, itm.notaMaxima);
      expect(e.decimales, itm.decimales);
    });
    test('dos escalas con los mismos valores son iguales', () {
      expect(itm.copyWith(), equals(ConfiguracionEscala.itm));
      expect(itm.copyWith(decimales: 2), isNot(equals(itm)));
    });
  });

  group('errorNota y aprueba', () {
    test('notas válidas en la escala ITM', () {
      expect(itm.errorNota(0), isNull);
      expect(itm.errorNota(350), isNull);
      expect(itm.errorNota(500), isNull);
    });
    test('fuera de rango o con más decimales', () {
      expect(itm.errorNota(510), contains('entre 0.0 y 5.0'));
      expect(itm.errorNota(305), contains('1 decimal'));
      expect(ConfiguracionEscala.cien.errorNota(6050), contains('decimales'));
    });
    test('aprueba desde la nota aprobatoria', () {
      expect(itm.aprueba(300), isTrue);
      expect(itm.aprueba(290), isFalse);
    });
  });

  group('ejemplosRedondeo (vista previa)', () {
    test('ITM: 2.95 → 3.0 aprueba y 3.05 → 3.1', () {
      final ej = ejemplosRedondeo(itm);
      expect(ej.length, 2);
      expect(ej[0].original, '2.95');
      expect(ej[0].redondeada, '3.0');
      expect(ej[0].aprueba, isTrue);
      expect(ej[1].original, '3.05');
      expect(ej[1].redondeada, '3.1');
    });
    test('truncando, 2.95 → 2.9 y no aprueba', () {
      final ej = ejemplosRedondeo(itm.copyWith(modo: ModoRedondeo.truncar));
      expect(ej[0].redondeada, '2.9');
      expect(ej[0].aprueba, isFalse);
    });
    test('0–100 sin decimales: 59.5 → 60 aprueba', () {
      final ej = ejemplosRedondeo(ConfiguracionEscala.cien);
      expect(ej[0].original, '59.5');
      expect(ej[0].redondeada, '60');
      expect(ej[0].aprueba, isTrue);
    });
    test('si la aprobatoria es la mínima, solo hay ejemplo por encima', () {
      final ej = ejemplosRedondeo(itm.copyWith(notaAprobatoria: 0));
      expect(ej.length, 1);
      expect(ej[0].original, '0.05');
    });
  });
}
