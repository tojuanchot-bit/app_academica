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

  group('una materia con varias clases distintas', () {
    // Estructura de Datos: lunes 7-9 en B-201 y miércoles 9-11 en L-3.
    const lunes = BloqueHorario(
        id: 10, materiaId: 1, dia: 1, inicio: 420, fin: 540, salon: 'B-201');
    const miercoles = BloqueHorario(
        id: 11, materiaId: 1, dia: 3, inicio: 540, fin: 660, salon: 'L-3');

    test('cada día muestra su hora y su salón', () {
      final semana = horarioSemanal([lunes, miercoles], materias);
      expect(semana[1]!.single.bloque.salon, 'B-201');
      expect(semana[1]!.single.bloque.rango, '7:00 – 9:00');
      expect(semana[3]!.single.bloque.salon, 'L-3');
      expect(semana[3]!.single.bloque.rango, '9:00 – 11:00');
    });
  });

  group('clasesEnDias', () {
    test('una clase por día, con la misma franja y salón, en orden', () {
      const modelo = BloqueHorario(
          materiaId: 1, dia: 1, inicio: 420, fin: 540, salon: 'B-201');
      final r = clasesEnDias(modelo, {5, 1, 3});
      expect([for (final b in r) b.dia], [1, 3, 5]);
      expect(r.every((b) => b.inicio == 420 && b.fin == 540), isTrue);
      expect(r.every((b) => b.salon == 'B-201' && b.id == null), isTrue);
    });
    test('sin días no crea nada', () {
      const modelo =
          BloqueHorario(materiaId: 1, dia: 1, inicio: 420, fin: 540);
      expect(clasesEnDias(modelo, const []), isEmpty);
    });
  });

  group('choquesPorClase', () {
    final otras = [bloque(1, 2, 1, 600, 720)]; // Cálculo lunes 10-12
    test('contra otras materias, una lista por clase', () {
      const nuevas = [
        BloqueHorario(materiaId: 1, dia: 1, inicio: 660, fin: 780),
        BloqueHorario(materiaId: 1, dia: 3, inicio: 660, fin: 780),
      ];
      final r = choquesPorClase(nuevas, otras);
      expect(r.length, 2);
      expect([for (final b in r[0]) b.id], [1]);
      expect(r[1], isEmpty);
    });
    test('entre clases de la misma materia', () {
      const nuevas = [
        BloqueHorario(materiaId: 0, dia: 2, inicio: 420, fin: 540),
        BloqueHorario(materiaId: 0, dia: 2, inicio: 480, fin: 600),
        BloqueHorario(materiaId: 0, dia: 2, inicio: 600, fin: 660),
      ];
      final r = choquesPorClase(nuevas, const []);
      expect(r[0], [nuevas[1]]);
      expect(r[1], [nuevas[0]]);
      expect(r[2], isEmpty); // empieza cuando termina la segunda
    });
    test('sin clases', () {
      expect(choquesPorClase(const [], otras), isEmpty);
    });
  });

  group('cambiosDeHorario', () {
    final a = bloque(1, 1, 1, 420, 540);
    final b = bloque(2, 1, 3, 540, 660);
    final c = bloque(3, 1, 5, 420, 540);

    test('materia nueva: todo se inserta', () {
      const nueva = BloqueHorario(materiaId: 7, dia: 2, inicio: 420, fin: 540);
      final r = cambiosDeHorario(const [], [nueva]);
      expect(r.insertar, [nueva]);
      expect(r.actualizar, isEmpty);
      expect(r.eliminar, isEmpty);
    });
    test('sin cambios no hace nada', () {
      final r = cambiosDeHorario([a, b], [a, b]);
      expect(r.insertar, isEmpty);
      expect(r.actualizar, isEmpty);
      expect(r.eliminar, isEmpty);
    });
    test('cambiar salón y hora de una, quitar otra y agregar una nueva', () {
      final bEditada = b.copyWith(salon: 'L-3', inicio: 600, fin: 720);
      const nueva = BloqueHorario(materiaId: 1, dia: 6, inicio: 480, fin: 600);
      final r = cambiosDeHorario([a, b, c], [a, bEditada, nueva]);
      expect(r.actualizar, [bEditada]);
      expect(r.eliminar, [3]);
      expect(r.insertar, [nueva]);
    });
    test('un id que no estaba se inserta sin id', () {
      final ajena = bloque(99, 1, 4, 420, 540);
      final r = cambiosDeHorario([a], [a, ajena]);
      expect(r.insertar.single.id, isNull);
      expect(r.insertar.single.dia, 4);
    });
    test('quitar todas', () {
      expect(cambiosDeHorario([a, b], const []).eliminar, [1, 2]);
    });
  });

  test('ordenarBloques por día y hora', () {
    final r = ordenarBloques([
      bloque(1, 1, 3, 420, 540),
      bloque(2, 1, 1, 600, 720),
      bloque(3, 1, 1, 420, 540),
    ]);
    expect([for (final b in r) b.id], [3, 2, 1]);
  });

  group('clasesDeHoy', () {
    // Lunes 2 nov 2026: Datos 7-9, Cálculo 10-12, Datos 14-16 y una
    // clase de Inglés (cancelada) que no debe salir.
    final lunes = [
      bloque(1, 1, 1, 420, 540),
      bloque(2, 2, 1, 600, 720),
      bloque(3, 1, 1, 840, 960),
      bloque(4, 3, 1, 480, 540),
    ];
    List<(int?, MomentoClase, int?)> a(int hora, int minuto) => [
          for (final c
              in clasesDeHoy(lunes, materias, DateTime(2026, 11, 2, hora, minuto)))
            (c.clase.bloque.id, c.momento, c.faltan),
        ];

    test('antes de la primera clase', () {
      expect(a(6, 30), [
        (1, MomentoClase.siguiente, 30),
        (2, MomentoClase.despues, 210),
        (3, MomentoClase.despues, 450),
      ]);
    });
    test('justo a la hora de inicio ya está en curso', () {
      expect(a(7, 0), [
        (1, MomentoClase.ahora, null),
        (2, MomentoClase.siguiente, 180),
        (3, MomentoClase.despues, 420),
      ]);
    });
    test('justo a la hora de fin ya pasó', () {
      expect(a(9, 0), [
        (1, MomentoClase.pasada, null),
        (2, MomentoClase.siguiente, 60),
        (3, MomentoClase.despues, 300),
      ]);
    });
    test('a media mañana: una pasada, una en curso y la siguiente', () {
      expect(a(11, 0), [
        (1, MomentoClase.pasada, null),
        (2, MomentoClase.ahora, null),
        (3, MomentoClase.siguiente, 180),
      ]);
    });
    test('al final del día todas pasaron', () {
      expect([for (final c in a(17, 0)) c.$2],
          everyElement(MomentoClase.pasada));
    });
    test('domingo sin clases', () {
      expect(clasesDeHoy(lunes, materias, DateTime(2026, 11, 8, 10)), isEmpty);
    });
    test('minutoDelDia', () {
      expect(minutoDelDia(DateTime(2026, 11, 2, 7, 30)), 450);
      expect(minutoDelDia(DateTime(2026, 11, 2)), 0);
    });
  });

  test('formatearFaltan', () {
    expect(formatearFaltan(5), 'En 5 min');
    expect(formatearFaltan(59), 'En 59 min');
    expect(formatearFaltan(60), 'En 1 h');
    expect(formatearFaltan(135), 'En 2 h 15 min');
  });
}
