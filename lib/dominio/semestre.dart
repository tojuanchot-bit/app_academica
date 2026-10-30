enum ErrorSemestre {
  nombreVacio('El nombre es obligatorio.'),
  finAntesDeInicio('La fecha de fin no puede ser anterior a la de inicio.');

  const ErrorSemestre(this.mensaje);
  final String mensaje;
}

/// Un periodo académico, por ejemplo "2026-2". No guarda el nivel (D-015).
class Semestre {
  const Semestre({
    this.id,
    required this.nombre,
    this.fechaInicio,
    this.fechaFin,
    this.activo = false,
  });

  /// null mientras no se ha guardado.
  final int? id;
  final String nombre;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final bool activo;

  Set<ErrorSemestre> validar() {
    final errores = <ErrorSemestre>{};
    if (nombre.trim().isEmpty) errores.add(ErrorSemestre.nombreVacio);
    final inicio = fechaInicio;
    final fin = fechaFin;
    if (inicio != null && fin != null && fin.isBefore(inicio)) {
      errores.add(ErrorSemestre.finAntesDeInicio);
    }
    return errores;
  }

  bool get esValido => validar().isEmpty;
}

/// Qué semestre mostrar: el elegido si existe; si no, el activo; si no,
/// el primero de la lista. null si no hay semestres.
Semestre? elegirSemestre(List<Semestre> lista, int? idPreferido) {
  if (lista.isEmpty) return null;
  if (idPreferido != null) {
    for (final s in lista) {
      if (s.id == idPreferido) return s;
    }
  }
  for (final s in lista) {
    if (s.activo) return s;
  }
  return lista.first;
}
