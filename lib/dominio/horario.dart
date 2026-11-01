import 'bloque_horario.dart';
import 'materia.dart';

/// Un bloque junto con la materia a la que pertenece, listo para mostrar.
typedef Clase = ({BloqueHorario bloque, Materia materia});

/// Dos bloques que se cruzan; [a] empieza antes (o igual) que [b].
typedef Choque = ({BloqueHorario a, BloqueHorario b});

/// Solo las materias en curso tienen horario. Canceladas, aprobadas y
/// reprobadas quedan fuera (D-014).
bool apareceEnHorario(Materia m) => m.estado == EstadoMateria.enCurso;

/// Los bloques de materias que aparecen en el horario, unidos con su materia
/// y ordenados por día, hora de inicio, hora de fin y nombre.
List<Clase> clasesVisibles(
  Iterable<BloqueHorario> bloques,
  Iterable<Materia> materias,
) {
  final porId = <int, Materia>{
    for (final m in materias)
      if (m.id != null && apareceEnHorario(m)) m.id!: m,
  };
  final clases = <Clase>[
    for (final b in bloques)
      if (porId[b.materiaId] case final m?) (bloque: b, materia: m),
  ];
  clases.sort(_compararClases);
  return clases;
}

/// Las clases de un día (1 = lunes … 7 = domingo), en orden de hora.
List<Clase> clasesDelDia(
  Iterable<BloqueHorario> bloques,
  Iterable<Materia> materias,
  int dia,
) {
  return [
    for (final c in clasesVisibles(bloques, materias))
      if (c.bloque.dia == dia) c,
  ];
}

/// Las clases que caen en la fecha dada, según su día de la semana.
List<Clase> clasesDeFecha(
  Iterable<BloqueHorario> bloques,
  Iterable<Materia> materias,
  DateTime fecha,
) =>
    clasesDelDia(bloques, materias, fecha.weekday);

/// Las clases de la semana agrupadas por día; siempre trae las 7 llaves,
/// aunque un día no tenga clases.
Map<int, List<Clase>> horarioSemanal(
  Iterable<BloqueHorario> bloques,
  Iterable<Materia> materias,
) {
  final semana = {for (var d = 1; d <= 7; d++) d: <Clase>[]};
  for (final c in clasesVisibles(bloques, materias)) {
    semana[c.bloque.dia]!.add(c);
  }
  return semana;
}

/// Todos los pares de bloques que se cruzan. Solo advierte (D-021): el
/// llamador decide qué bloques comparar (normalmente, los de [clasesVisibles]).
List<Choque> choques(Iterable<BloqueHorario> bloques) {
  final lista = [...bloques]..sort(_compararBloques);
  final resultado = <Choque>[];
  for (var i = 0; i < lista.length; i++) {
    for (var j = i + 1; j < lista.length; j++) {
      final a = lista[i], b = lista[j];
      // Ordenados por día e inicio: si b es de otro día o empieza cuando
      // a ya terminó, ninguno de los siguientes se cruza con a.
      if (b.dia != a.dia || b.inicio >= a.fin) break;
      resultado.add((a: a, b: b));
    }
  }
  return resultado;
}

/// Los bloques de [existentes] que se cruzan con [nuevo]. Si [nuevo] ya
/// está guardado (se está editando), no se compara consigo mismo.
List<BloqueHorario> choquesCon(
  BloqueHorario nuevo,
  Iterable<BloqueHorario> existentes,
) {
  return [
    for (final b in existentes)
      if (!(nuevo.id != null && b.id == nuevo.id) && nuevo.seCruzaCon(b)) b,
  ]..sort(_compararBloques);
}

/// Ids de los bloques que tienen algún choque (para marcarlos en pantalla).
Set<int> idsConChoque(Iterable<BloqueHorario> bloques) => {
      for (final c in choques(bloques)) ...[
        if (c.a.id != null) c.a.id!,
        if (c.b.id != null) c.b.id!,
      ],
    };

/// Para cada clase de [nuevas] (las de una materia que se está creando o
/// editando, aún sin guardar), los bloques con que se cruza: de [otras]
/// (las de las demás materias) y de las demás clases de [nuevas].
/// El resultado tiene una lista por clase, en el mismo orden.
List<List<BloqueHorario>> choquesPorClase(
  List<BloqueHorario> nuevas,
  Iterable<BloqueHorario> otras,
) {
  return [
    for (var i = 0; i < nuevas.length; i++)
      [
        for (final b in otras)
          if (nuevas[i].seCruzaCon(b)) b,
        for (var j = 0; j < nuevas.length; j++)
          if (j != i && nuevas[i].seCruzaCon(nuevas[j])) nuevas[j],
      ]..sort(_compararBloques),
  ];
}

/// Una clase por cada día de [dias], con la misma franja y salón.
/// Sirve para "lunes y miércoles de 7:00 a 9:00 en B-201".
List<BloqueHorario> clasesEnDias(BloqueHorario modelo, Iterable<int> dias) {
  final ordenados = dias.toSet().toList()..sort();
  return [
    for (final d in ordenados)
      BloqueHorario(
        materiaId: modelo.materiaId,
        dia: d,
        inicio: modelo.inicio,
        fin: modelo.fin,
        salon: modelo.salon,
      ),
  ];
}

/// Qué hacer en la base de datos para pasar de las clases guardadas
/// ([antes]) a las del formulario ([despues]).
typedef CambiosHorario = ({
  List<BloqueHorario> insertar,
  List<BloqueHorario> actualizar,
  List<int> eliminar,
});

/// - Sin id (o con un id que no estaba): se inserta, sin id.
/// - Con id que estaba y algo cambió: se actualiza.
/// - Estaba y ya no está: se elimina.
/// Las que no cambiaron no se tocan.
CambiosHorario cambiosDeHorario(
  Iterable<BloqueHorario> antes,
  Iterable<BloqueHorario> despues,
) {
  final antesPorId = {
    for (final b in antes)
      if (b.id != null) b.id!: b,
  };
  final idsDespues = {
    for (final b in despues)
      if (b.id != null && antesPorId.containsKey(b.id)) b.id!,
  };
  final insertar = <BloqueHorario>[];
  final actualizar = <BloqueHorario>[];
  for (final b in despues) {
    final previo = antesPorId[b.id];
    if (previo == null) {
      insertar.add(BloqueHorario(
        materiaId: b.materiaId,
        dia: b.dia,
        inicio: b.inicio,
        fin: b.fin,
        salon: b.salon,
      ));
    } else if (previo != b) {
      actualizar.add(b);
    }
  }
  return (
    insertar: insertar,
    actualizar: actualizar,
    eliminar: [
      for (final id in antesPorId.keys)
        if (!idsDespues.contains(id)) id,
    ],
  );
}

/// En qué punto del día está una clase de hoy.
enum MomentoClase {
  /// Ya terminó.
  pasada,

  /// Está en curso ahora mismo.
  ahora,

  /// La primera que falta por empezar.
  siguiente,

  /// Empieza más tarde, después de la siguiente.
  despues,
}

typedef ClaseDeHoy = ({
  Clase clase,
  MomentoClase momento,

  /// Minutos que faltan para que empiece; null si ya empezó.
  int? faltan,
});

/// 7:30 → 450.
int minutoDelDia(DateTime t) => t.hour * 60 + t.minute;

/// Las clases de la fecha de [ahora], en orden, con su momento. Una clase
/// está "ahora" desde su inicio hasta un minuto antes de su fin (a las
/// 9:00 ya terminó la de 7:00 – 9:00).
List<ClaseDeHoy> clasesDeHoy(
  Iterable<BloqueHorario> bloques,
  Iterable<Materia> materias,
  DateTime ahora,
) {
  final minuto = minutoDelDia(ahora);
  final resultado = <ClaseDeHoy>[];
  var yaHaySiguiente = false;
  for (final c in clasesDeFecha(bloques, materias, ahora)) {
    if (c.bloque.fin <= minuto) {
      resultado.add((clase: c, momento: MomentoClase.pasada, faltan: null));
    } else if (c.bloque.inicio <= minuto) {
      resultado.add((clase: c, momento: MomentoClase.ahora, faltan: null));
    } else {
      resultado.add((
        clase: c,
        momento: yaHaySiguiente ? MomentoClase.despues : MomentoClase.siguiente,
        faltan: c.bloque.inicio - minuto,
      ));
      yaHaySiguiente = true;
    }
  }
  return resultado;
}

/// "En 5 min", "En 1 h", "En 2 h 15 min".
String formatearFaltan(int minutos) {
  if (minutos < 60) return 'En $minutos min';
  final h = minutos ~/ 60, m = minutos % 60;
  return m == 0 ? 'En $h h' : 'En $h h $m min';
}

/// Orden de lectura: día, inicio, fin.
List<BloqueHorario> ordenarBloques(Iterable<BloqueHorario> bloques) =>
    [...bloques]..sort(_compararBloques);

int _compararBloques(BloqueHorario x, BloqueHorario y) {
  if (x.dia != y.dia) return x.dia.compareTo(y.dia);
  if (x.inicio != y.inicio) return x.inicio.compareTo(y.inicio);
  if (x.fin != y.fin) return x.fin.compareTo(y.fin);
  return (x.id ?? 0).compareTo(y.id ?? 0);
}

int _compararClases(Clase x, Clase y) {
  final b = x.bloque, c = y.bloque;
  if (b.dia != c.dia) return b.dia.compareTo(c.dia);
  if (b.inicio != c.inicio) return b.inicio.compareTo(c.inicio);
  if (b.fin != c.fin) return b.fin.compareTo(c.fin);
  final nombre = x.materia.nombre.compareTo(y.materia.nombre);
  if (nombre != 0) return nombre;
  return (b.id ?? 0).compareTo(c.id ?? 0);
}
