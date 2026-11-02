import 'calculo_notas.dart';
import 'configuracion_escala.dart';
import 'evaluacion.dart';
import 'materia.dart';

/// Cómo va una materia en cuanto a notas (D-024). Las en curso se juzgan
/// con la proyección hacia la nota aprobatoria, sin notas supuestas: es el
/// mismo criterio de la alerta de Hoy, para que Notas, Hoy y "Proyectar
/// notas" nunca muestren cosas distintas.
enum EstadoNotas {
  aprobando('Aprobando'),
  enRiesgo('En riesgo'),
  noAlcanza('No alcanza'),
  completa('Completa'),
  sinPorcentajes('Faltan porcentajes'),
  aprobada('Aprobada'),
  reprobada('Reprobada'),
  cancelada('Cancelada');

  const EstadoNotas(this.etiqueta);
  final String etiqueta;

  /// Los que muestran alerta en Hoy.
  bool get esAlerta => this == enRiesgo || this == noAlcanza;
}

/// Estado de notas de [materia] con sus evaluaciones [todas].
EstadoNotas estadoNotas(
  Materia materia,
  List<Evaluacion> todas,
  ConfiguracionEscala escala,
) {
  switch (materia.estado) {
    case EstadoMateria.aprobada:
      return EstadoNotas.aprobada;
    case EstadoMateria.reprobada:
      return EstadoNotas.reprobada;
    case EstadoMateria.cancelada:
      return EstadoNotas.cancelada;
    case EstadoMateria.enCurso:
      final p = proyectar(todas, escala, meta: escala.notaAprobatoria);
      return estadoDeProyeccion(p, escala);
  }
}

/// Traduce una proyección hacia la aprobatoria a un estado. Está aparte
/// para que la alerta de Hoy, que también necesita la nota, no proyecte
/// dos veces.
EstadoNotas estadoDeProyeccion(Proyeccion p, ConfiguracionEscala escala) {
  return switch (p.tipo) {
    TipoProyeccion.porcentajesIncompletos => EstadoNotas.sinPorcentajes,
    TipoProyeccion.completa =>
      escala.aprueba(p.nota!) ? EstadoNotas.completa : EstadoNotas.noAlcanza,
    // Solo aparece con notas supuestas, que aquí no se usan.
    TipoProyeccion.simulada =>
      escala.aprueba(p.nota!) ? EstadoNotas.aprobando : EstadoNotas.noAlcanza,
    TipoProyeccion.asegurada => EstadoNotas.aprobando,
    TipoProyeccion.necesita => p.nota! > escala.notaAprobatoria
        ? EstadoNotas.enRiesgo
        : EstadoNotas.aprobando,
    TipoProyeccion.noAlcanza => EstadoNotas.noAlcanza,
  };
}

/// Orden de la pestaña Notas: el de siempre, con las canceladas al final.
List<Materia> ordenParaNotas(Iterable<Materia> materias) => [
      ...materias.where((m) => m.estado != EstadoMateria.cancelada),
      ...materias.where((m) => m.estado == EstadoMateria.cancelada),
    ];

/// true si tiene sentido proyectar [materia] (D-024): está en curso, sus
/// porcentajes suman 100 % y le queda al menos una evaluación pendiente.
bool sePuedeProyectar(Materia materia, List<Evaluacion> todas) =>
    materia.estado == EstadoMateria.enCurso &&
    sumaPorcentajes(primerNivel(todas)) == porcentajeCompleto &&
    contarPendientes(todas) > 0;
