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
