import 'configuracion_escala.dart';

/// Ciclo de vida de un intento de cursar una materia (D-014).
enum EstadoMateria {
  enCurso('En curso'),
  cancelada('Cancelada'),
  aprobada('Aprobada'),
  reprobada('Reprobada');

  const EstadoMateria(this.etiqueta);
  final String etiqueta;

  bool get estaCerrada => this == aprobada || this == reprobada;
}

const int creditosMaximos = 30;

enum ErrorMateria {
  nombreVacio('El nombre es obligatorio.'),
  creditosFueraDeRango('Los créditos deben estar entre 0 y $creditosMaximos.');

  const ErrorMateria(this.mensaje);
  final String mensaje;
}

/// Un intento de cursar una materia en un semestre.
class Materia {
  const Materia({
    this.id,
    required this.semestreId,
    required this.nombre,
    this.docente = '',
    required this.creditos,
    required this.color,
    this.estado = EstadoMateria.enCurso,
    this.fechaCancelacion,
    this.notaFinal,
  });

  /// null mientras no se ha guardado.
  final int? id;
  final int semestreId;
  final String nombre;
  final String docente;
  final int creditos;

  /// Color ARGB, por ejemplo 0xFF6A4BC4.
  final int color;
  final EstadoMateria estado;

  /// Solo si está cancelada.
  final DateTime? fechaCancelacion;

  /// En centésimas; solo si está aprobada o reprobada.
  final int? notaFinal;

  /// Copia cambiando los datos editables. El estado cambia solo con
  /// [cancelar], [cerrar] y [reabrir].
  Materia copyWith({
    String? nombre,
    String? docente,
    int? creditos,
    int? color,
  }) {
    return Materia(
      id: id,
      semestreId: semestreId,
      nombre: nombre ?? this.nombre,
      docente: docente ?? this.docente,
      creditos: creditos ?? this.creditos,
      color: color ?? this.color,
      estado: estado,
      fechaCancelacion: fechaCancelacion,
      notaFinal: notaFinal,
    );
  }

  Set<ErrorMateria> validar() {
    final errores = <ErrorMateria>{};
    if (nombre.trim().isEmpty) errores.add(ErrorMateria.nombreVacio);
    if (creditos < 0 || creditos > creditosMaximos) {
      errores.add(ErrorMateria.creditosFueraDeRango);
    }
    return errores;
  }

  bool get esValida => validar().isEmpty;

  /// Cancela una materia en curso; guarda solo el día, sin la hora.
  Materia cancelar(DateTime fecha) {
    if (estado != EstadoMateria.enCurso) {
      throw StateError('Solo se puede cancelar una materia en curso.');
    }
    return _conEstado(
      EstadoMateria.cancelada,
      fechaCancelacion: DateTime(fecha.year, fecha.month, fecha.day),
    );
  }

  /// Cierra la materia con su nota final: aprobada o reprobada según la escala.
  Materia cerrar(int notaFinal, ConfiguracionEscala escala) {
    if (estado != EstadoMateria.enCurso) {
      throw StateError('Solo se puede cerrar una materia en curso.');
    }
    final error = escala.errorNota(notaFinal);
    if (error != null) throw ArgumentError.value(notaFinal, 'notaFinal', error);
    return _conEstado(
      escala.aprueba(notaFinal)
          ? EstadoMateria.aprobada
          : EstadoMateria.reprobada,
      notaFinal: notaFinal,
    );
  }

  /// Vuelve a "en curso" y borra la fecha de cancelación o la nota final.
  Materia reabrir() => _conEstado(EstadoMateria.enCurso);

  Materia _conEstado(
    EstadoMateria nuevo, {
    DateTime? fechaCancelacion,
    int? notaFinal,
  }) {
    return Materia(
      id: id,
      semestreId: semestreId,
      nombre: nombre,
      docente: docente,
      creditos: creditos,
      color: color,
      estado: nuevo,
      fechaCancelacion: fechaCancelacion,
      notaFinal: notaFinal,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Materia &&
      other.id == id &&
      other.semestreId == semestreId &&
      other.nombre == nombre &&
      other.docente == docente &&
      other.creditos == creditos &&
      other.color == color &&
      other.estado == estado &&
      other.fechaCancelacion == fechaCancelacion &&
      other.notaFinal == notaFinal;

  @override
  int get hashCode => Object.hash(id, semestreId, nombre, docente, creditos,
      color, estado, fechaCancelacion, notaFinal);
}

typedef ResumenCreditos = ({
  int enCurso,
  int aprobados,
  int reprobados,
  int cancelados,
});

/// Suma los créditos de las materias por estado.
ResumenCreditos resumenCreditos(Iterable<Materia> materias) {
  var enCurso = 0, aprobados = 0, reprobados = 0, cancelados = 0;
  for (final m in materias) {
    switch (m.estado) {
      case EstadoMateria.enCurso:
        enCurso += m.creditos;
      case EstadoMateria.aprobada:
        aprobados += m.creditos;
      case EstadoMateria.reprobada:
        reprobados += m.creditos;
      case EstadoMateria.cancelada:
        cancelados += m.creditos;
    }
  }
  return (
    enCurso: enCurso,
    aprobados: aprobados,
    reprobados: reprobados,
    cancelados: cancelados,
  );
}
