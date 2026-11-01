import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/bloque_horario.dart';
import 'package:app_academica/dominio/horario.dart';
import 'package:app_academica/dominio/materia.dart';

Materia materia(int id, String nombre,
        [EstadoMateria estado = EstadoMateria.enCurso]) =>
    Materia(
      id: id,
      semestreId: 1,
      nombre: nombre,
      creditos: 3,
      color: 0xFF6A4BC4,
      estado: estado,
    );

BloqueHorario bloque(int id, int materiaId, int dia, int inicio, int fin) =>
    BloqueHorario(
        id: id, materiaId: materiaId, dia: dia, inicio: inicio, fin: fin);

void main() {
  final datos = materia(1, 'Estructura de Datos');
  final calculo = materia(2, 'Cálculo Integral');
  final cancelada = materia(3, 'Inglés', EstadoMateria.cancelada);
  final aprobada = materia(4, 'Lógica', EstadoMateria.aprobada);
  final reprobada = materia(5, 'Física', EstadoMateria.reprobada);
  final materias = [datos, calculo, cancelada, aprobada, reprobada];

  final bloques = [
    bloque(1, 2, 1, 600, 720), // lunes 10:00 Cálculo
    bloque(2, 1, 1, 420, 540), // lunes 7:00 Datos
    bloque(3, 3, 1, 420, 540), // lunes 7:00 Inglés (cancelada)
    bloque(4, 4, 1, 780, 900), // lunes 13:00 Lógica (aprobada)
    bloque(5, 5, 3, 420, 540), // miércoles Física (reprobada)
    bloque(6, 1, 3, 420, 540), // miércoles 7:00 Datos
  ];

  group('apareceEnHorario', () {
    test('solo en curso', () {
      expect(apareceEnHorario(datos), isTrue);
      expect(apareceEnHorario(cancelada), isFalse);
      expect(apareceEnHorario(aprobada), isFalse);
      expect(apareceEnHorario(reprobada), isFalse);
    });
  });

  group('clasesDelDia', () {
    test('ordena por hora y quita canceladas, aprobadas y reprobadas', () {
      final lunes = clasesDelDia(bloques, materias, 1);
      expect([for (final c in lunes) c.bloque.id], [2, 1]);
      expect(lunes.first.materia, datos);
    });
    test('miércoles sin la reprobada', () {
      final miercoles = clasesDelDia(bloques, materias, 3);
      expect([for (final c in miercoles) c.materia.nombre],
          ['Estructura de Datos']);
    });
    test('día sin clases', () {
      expect(clasesDelDia(bloques, materias, 7), isEmpty);
    });
    test('bloque de una materia que no está en la lista se ignora', () {
      expect(clasesDelDia([bloque(9, 99, 1, 420, 540)], materias, 1), isEmpty);
    });
    test('a la misma hora, por nombre de materia', () {
      final iguales = [bloque(1, 1, 2, 420, 540), bloque(2, 2, 2, 420, 540)];
      expect([for (final c in clasesDelDia(iguales, materias, 2)) c.bloque.id],
          [2, 1]); // Cálculo antes que Estructura
    });
    test('al reabrir una cancelada vuelve a aparecer', () {
      final reabierta = cancelada.reabrir();
      final lunes = clasesDelDia(bloques, [datos, calculo, reabierta], 1);
      expect([for (final c in lunes) c.bloque.id], [2, 3, 1]);
    });
  });

  group('clasesDeFecha', () {
    test('usa el día de la semana de la fecha', () {
      // 2 nov 2026 es lunes; 8 nov 2026 es domingo.
      final lunes = clasesDeFecha(bloques, materias, DateTime(2026, 11, 2));
      expect([for (final c in lunes) c.bloque.id], [2, 1]);
      expect(clasesDeFecha(bloques, materias, DateTime(2026, 11, 8)), isEmpty);
    });
  });

  group('horarioSemanal', () {
    test('siempre 7 días, con las clases en orden', () {
      final semana = horarioSemanal(bloques, materias);
      expect(semana.keys, [1, 2, 3, 4, 5, 6, 7]);
      expect([for (final c in semana[1]!) c.bloque.id], [2, 1]);
      expect(semana[2], isEmpty);
      expect([for (final c in semana[3]!) c.bloque.id], [6]);
    });
  });

  group('choques', () {
    test('sin choques', () {
      expect(choques([bloque(1, 1, 1, 420, 540), bloque(2, 2, 1, 540, 660)]),
          isEmpty);
    });
    test('detecta el par y lo ordena por hora', () {
      final r = choques([bloque(1, 1, 1, 480, 600), bloque(2, 2, 1, 420, 540)]);
      expect(r.length, 1);
      expect(r.single.a.id, 2);
      expect(r.single.b.id, 1);
    });
    test('un bloque largo choca con varios', () {
      final r = choques([
        bloque(1, 1, 1, 420, 720),
        bloque(2, 2, 1, 420, 480),
        bloque(3, 3, 1, 600, 660),
        bloque(4, 4, 1, 720, 780), // empieza cuando termina el largo
      ]);
      expect([for (final c in r) (c.a.id, c.b.id)], [(2, 1), (1, 3)]);
    });
    test('mismos horarios en días distintos no chocan', () {
      expect(choques([bloque(1, 1, 1, 420, 540), bloque(2, 2, 2, 420, 540)]),
          isEmpty);
    });
    test('idsConChoque', () {
      expect(
        idsConChoque([
          bloque(1, 1, 1, 420, 540),
          bloque(2, 2, 1, 480, 600),
          bloque(3, 3, 1, 700, 800),
        ]),
        {1, 2},
      );
    });
    test('con clasesVisibles, una cancelada no genera choque', () {
      final visibles = [
        for (final c in clasesVisibles(bloques, materias)) c.bloque,
      ];
      expect(choques(visibles), isEmpty); // el bloque 3 (Inglés) quedó fuera
      expect(choques(bloques), isNotEmpty); // sin filtrar, 2 y 3 chocan
    });
  });

  group('choquesCon', () {
    final existentes = [bloque(1, 1, 1, 420, 540), bloque(2, 2, 1, 600, 720)];
    test('un bloque nuevo que se cruza', () {
      const nuevo =
          BloqueHorario(materiaId: 3, dia: 1, inicio: 500, fin: 620);
      expect([for (final b in choquesCon(nuevo, existentes)) b.id], [1, 2]);
    });
    test('un bloque nuevo sin choque', () {
      const nuevo =
          BloqueHorario(materiaId: 3, dia: 1, inicio: 540, fin: 600);
      expect(choquesCon(nuevo, existentes), isEmpty);
    });
    test('al editar no choca consigo mismo', () {
      final editado = existentes.first.copyWith(fin: 560);
      expect(choquesCon(editado, existentes), isEmpty);
    });
  });
}
