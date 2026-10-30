import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/calculo_notas.dart';
import 'package:app_academica/dominio/configuracion_escala.dart';
import 'package:app_academica/dominio/evaluacion.dart';
import 'package:app_academica/dominio/redondeo.dart';

Evaluacion hija(int? nota, {int? porcentaje}) => Evaluacion(
      materiaId: 1,
      padreId: 1,
      nombre: 'Quiz',
      nota: nota,
      porcentaje: porcentaje,
    );

void main() {
  const itm = ConfiguracionEscala.itm;

  group('redondearAEscala', () {
    test('3.45 → 3.5 y 3.44 → 3.4', () {
      expect(redondearAEscala(const Fraccion(345, 1), itm), 350);
      expect(redondearAEscala(const Fraccion(344, 1), itm), 340);
    });
    test('truncando, 3.49 → 3.4', () {
      final truncar = itm.copyWith(modo: ModoRedondeo.truncar);
      expect(redondearAEscala(const Fraccion(349, 1), truncar), 340);
    });
  });

  group('notaCompuesta en partes iguales', () {
    test('3.4 y 3.5 → 3.45 → 3.5 (el caso que falla con double)', () {
      expect(notaCompuesta([hija(340), hija(350)], itm),
          const Fraccion(350, 1));
    });
    test('tres quices 3.0, 3.5 y 4.2 → 3.57 → 3.6', () {
      expect(notaCompuesta([hija(300), hija(350), hija(420)], itm),
          const Fraccion(360, 1));
    });
    test('sin redondear intermedias queda el valor exacto', () {
      final sinRedondeo = itm.copyWith(redondearIntermedias: false);
      final valor = notaCompuesta([hija(340), hija(350)], sinRedondeo)!;
      expect(valor, const Fraccion(345, 1));
      expect(redondearAEscala(valor, itm), 350);
    });
  });

  group('notaCompuesta con porcentajes', () {
    test('2.5 al 40 % y 4.0 al 60 % → 3.4', () {
      expect(
        notaCompuesta(
            [hija(250, porcentaje: 4000), hija(400, porcentaje: 6000)], itm),
        const Fraccion(340, 1),
      );
    });
    test('4.5 al 30 % y 3.0 al 70 % → 3.45 → 3.5', () {
      expect(
        notaCompuesta(
            [hija(450, porcentaje: 3000), hija(300, porcentaje: 7000)], itm),
        const Fraccion(350, 1),
      );
    });
    test('si los porcentajes no suman 100 % se usan partes iguales', () {
      final hijas = [hija(250, porcentaje: 4000), hija(400)];
      expect(modoReparto(hijas), ModoReparto.partesIguales);
      // (2.5 + 4.0) / 2 = 3.25 → 3.3
      expect(notaCompuesta(hijas, itm), const Fraccion(330, 1));
    });
  });

  test('null si falta una sub-nota o no hay sub-evaluaciones', () {
    expect(notaCompuesta([hija(300), hija(null)], itm), isNull);
    expect(notaCompuesta([], itm), isNull);
  });
}
