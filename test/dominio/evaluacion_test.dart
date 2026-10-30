import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/evaluacion.dart';

void main() {
  const parcial1 =
      Evaluacion(id: 1, materiaId: 1, nombre: 'Parcial 1', porcentaje: 3000);
  const parcial2 =
      Evaluacion(id: 2, materiaId: 1, nombre: 'Parcial 2', porcentaje: 3000);
  const quiz = Evaluacion(id: 3, materiaId: 1, padreId: 9, nombre: 'Quiz');

  group('validarEvaluacion', () {
    test('válida', () {
      expect(validarEvaluacion(parcial1, hermanas: [parcial1, parcial2]),
          isEmpty);
    });
    test('nombre y porcentaje obligatorios en primer nivel', () {
      const e = Evaluacion(materiaId: 1, nombre: ' ');
      expect(validarEvaluacion(e, hermanas: []), {
        ErrorEvaluacion.nombreVacio,
        ErrorEvaluacion.porcentajeFaltante,
      });
    });
    test('una sub-evaluación puede no tener porcentaje', () {
      expect(validarEvaluacion(quiz, hermanas: [quiz]), isEmpty);
    });
    test('porcentaje fuera de rango', () {
      const e = Evaluacion(materiaId: 1, nombre: 'X', porcentaje: 0);
      expect(validarEvaluacion(e, hermanas: []),
          {ErrorEvaluacion.porcentajeFueraDeRango});
    });
    test('la suma no puede pasar del 100 %', () {
      const nueva =
          Evaluacion(materiaId: 1, nombre: 'Final', porcentaje: 4100);
      expect(validarEvaluacion(nueva, hermanas: [parcial1, parcial2]),
          {ErrorEvaluacion.sumaExcede});
      const justa =
          Evaluacion(materiaId: 1, nombre: 'Final', porcentaje: 4000);
      expect(validarEvaluacion(justa, hermanas: [parcial1, parcial2]),
          isEmpty);
    });
    test('al editar no se cuenta a sí misma', () {
      const editado =
          Evaluacion(id: 1, materiaId: 1, nombre: 'Parcial 1', porcentaje: 7000);
      expect(validarEvaluacion(editado, hermanas: [parcial1, parcial2]),
          isEmpty);
    });
  });

  test('primerNivel, hijasDe y sumaPorcentajes', () {
    final todas = [parcial1, parcial2, quiz];
    expect(primerNivel(todas), [parcial1, parcial2]);
    expect(hijasDe(todas, 9), [quiz]);
    expect(sumaPorcentajes(primerNivel(todas)), 6000);
  });

  test('formatearPorcentaje', () {
    expect(formatearPorcentaje(3000), '30 %');
    expect(formatearPorcentaje(1250), '12.5 %');
    expect(formatearPorcentaje(3333), '33.33 %');
    expect(formatearPorcentaje(10000), '100 %');
  });
}
