import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/bloque_horario.dart';

BloqueHorario bloque(int dia, int inicio, int fin) =>
    BloqueHorario(materiaId: 1, dia: dia, inicio: inicio, fin: fin);

void main() {
  group('formato', () {
    test('horas en minutos a texto', () {
      expect(formatearHora(0), '0:00');
      expect(formatearHora(420), '7:00');
      expect(formatearHora(605), '10:05');
      expect(formatearHora(1350), '22:30');
      expect(formatearHora(minutosPorDia), '24:00');
    });
    test('rango y días', () {
      expect(bloque(1, 420, 540).rango, '7:00 – 9:00');
      expect(nombreDia(1), 'Lunes');
      expect(nombreDia(3), 'Miércoles');
      expect(nombreDia(7), 'Domingo');
      expect(nombreDiaCorto(6), 'Sáb');
    });
  });

  group('validar', () {
    test('un bloque normal es válido', () {
      expect(bloque(1, 420, 540).esValido, isTrue);
      expect(bloque(7, 0, minutosPorDia).esValido, isTrue);
    });
    test('el fin debe ser posterior al inicio', () {
      expect(bloque(1, 540, 540).validar(), {ErrorBloque.finNoPosterior});
      expect(bloque(1, 600, 540).validar(), {ErrorBloque.finNoPosterior});
    });
    test('día entre 1 y 7', () {
      expect(bloque(0, 420, 540).validar(), {ErrorBloque.diaInvalido});
      expect(bloque(8, 420, 540).validar(), {ErrorBloque.diaInvalido});
    });
    test('horas dentro del día', () {
      expect(bloque(1, -10, 540).validar(), {ErrorBloque.horaFueraDeRango});
      expect(bloque(1, 1380, minutosPorDia + 30).validar(),
          {ErrorBloque.horaFueraDeRango});
    });
  });

  group('seCruzaCon', () {
    test('mismo día y franjas que se solapan', () {
      expect(bloque(1, 420, 540).seCruzaCon(bloque(1, 480, 600)), isTrue);
      expect(bloque(1, 480, 600).seCruzaCon(bloque(1, 420, 540)), isTrue);
    });
    test('uno dentro del otro', () {
      expect(bloque(2, 420, 720).seCruzaCon(bloque(2, 480, 540)), isTrue);
    });
    test('franjas idénticas', () {
      expect(bloque(2, 420, 540).seCruzaCon(bloque(2, 420, 540)), isTrue);
    });
    test('terminar justo cuando el otro empieza no es choque', () {
      expect(bloque(1, 420, 540).seCruzaCon(bloque(1, 540, 660)), isFalse);
      expect(bloque(1, 540, 660).seCruzaCon(bloque(1, 420, 540)), isFalse);
    });
    test('otro día no es choque', () {
      expect(bloque(1, 420, 540).seCruzaCon(bloque(2, 420, 540)), isFalse);
    });
  });

  test('copyWith conserva el id', () {
    const b = BloqueHorario(
        id: 5, materiaId: 1, dia: 1, inicio: 420, fin: 540, salon: 'B-201');
    final c = b.copyWith(dia: 3);
    expect(c.id, 5);
    expect(c.dia, 3);
    expect(c.salon, 'B-201');
    expect(c == b, isFalse);
    expect(c.copyWith(dia: 1), b);
  });
}
