import 'redondeo.dart';

/// 100 % expresado en centésimas de punto porcentual (30 % = 3000).
const int porcentajeCompleto = 10000;

enum ErrorEvaluacion {
  nombreVacio('El nombre es obligatorio.'),
  porcentajeFaltante('Escribe el porcentaje.'),
  porcentajeFueraDeRango('El porcentaje debe ser mayor que 0 y máximo 100 %.'),
  sumaExcede('Con este porcentaje el total pasa del 100 %.');

  const ErrorEvaluacion(this.mensaje);
  final String mensaje;
}

/// Una nota de una materia (parcial, quiz, trabajo…). Si tiene [padreId] es
/// una sub-evaluación de una evaluación compuesta (D-007, un solo nivel).
class Evaluacion {
  const Evaluacion({
    this.id,
    required this.materiaId,
    this.padreId,
    required this.nombre,
    this.porcentaje,
    this.nota,
    this.fecha,
    this.notaSupuesta,
  });

  /// null mientras no se ha guardado.
  final int? id;
  final int materiaId;
  final int? padreId;
  final String nombre;

  /// En centésimas de %. Primer nivel: porcentaje de la materia (obligatorio).
  /// Sub-evaluación: porcentaje dentro del padre; null = partes iguales.
  final int? porcentaje;

  /// En centésimas; null si aún no se ha presentado. En una evaluación
  /// compuesta no se usa: se calcula con sus sub-evaluaciones.
  final int? nota;
  final DateTime? fecha;

  /// Para la proyección (punto 4).
  final int? notaSupuesta;

  bool get esHija => padreId != null;
}

/// Errores de nombre y porcentaje. [hermanas] son las evaluaciones con el
/// mismo padre (puede incluir a [e]; se descarta por id).
Set<ErrorEvaluacion> validarEvaluacion(
  Evaluacion e, {
  required Iterable<Evaluacion> hermanas,
}) {
  final errores = <ErrorEvaluacion>{};
  if (e.nombre.trim().isEmpty) errores.add(ErrorEvaluacion.nombreVacio);

  final p = e.porcentaje;
  if (p == null) {
    if (!e.esHija) errores.add(ErrorEvaluacion.porcentajeFaltante);
    return errores;
  }
  if (p <= 0 || p > porcentajeCompleto) {
    errores.add(ErrorEvaluacion.porcentajeFueraDeRango);
    return errores;
  }
  final otras = hermanas.where((h) => e.id == null || h.id != e.id);
  if (sumaPorcentajes(otras) + p > porcentajeCompleto) {
    errores.add(ErrorEvaluacion.sumaExcede);
  }
  return errores;
}

int sumaPorcentajes(Iterable<Evaluacion> evaluaciones) {
  var suma = 0;
  for (final e in evaluaciones) {
    suma += e.porcentaje ?? 0;
  }
  return suma;
}

List<Evaluacion> primerNivel(Iterable<Evaluacion> todas) =>
    todas.where((e) => e.padreId == null).toList();

List<Evaluacion> hijasDe(Iterable<Evaluacion> todas, int padreId) =>
    todas.where((e) => e.padreId == padreId).toList();

/// 3000 → "30 %", 1250 → "12.5 %", 3333 → "33.33 %".
String formatearPorcentaje(int centesimas) {
  if (centesimas % 100 == 0) return '${centesimas ~/ 100} %';
  if (centesimas % 10 == 0) return '${formatearNota(centesimas ~/ 10, 1)} %';
  return '${formatearNota(centesimas, 2)} %';
}
