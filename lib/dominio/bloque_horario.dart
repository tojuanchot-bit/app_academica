/// Minutos que tiene un día; 24:00 es una hora de fin válida.
const int minutosPorDia = 24 * 60;

// DateTime.weekday: 1 = lunes … 7 = domingo.
const nombresDias = [
  'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
];

/// "Lunes" para 1 … "Domingo" para 7.
String nombreDia(int dia) => nombresDias[dia - 1];

/// "Lun" para 1 … "Dom" para 7.
String nombreDiaCorto(int dia) => nombresDias[dia - 1].substring(0, 3);

/// 420 → "7:00", 1350 → "22:30".
String formatearHora(int minutos) =>
    '${minutos ~/ 60}:${(minutos % 60).toString().padLeft(2, '0')}';

/// "7:00 – 9:00"
String formatearRango(int inicio, int fin) =>
    '${formatearHora(inicio)} – ${formatearHora(fin)}';

enum ErrorBloque {
  diaInvalido('Elige un día de la semana.'),
  horaFueraDeRango('Las horas deben estar entre 0:00 y 24:00.'),
  finNoPosterior('La hora de fin debe ser posterior a la de inicio.');

  const ErrorBloque(this.mensaje);
  final String mensaje;
}

/// Una clase semanal de una materia: día, franja y salón.
/// Las horas van en minutos desde la medianoche (7:00 = 420).
class BloqueHorario {
  const BloqueHorario({
    this.id,
    required this.materiaId,
    required this.dia,
    required this.inicio,
    required this.fin,
    this.salon = '',
  });

  /// null mientras no se ha guardado.
  final int? id;
  final int materiaId;

  /// 1 = lunes … 7 = domingo, como `DateTime.weekday`.
  final int dia;
  final int inicio;
  final int fin;
  final String salon;

  int get duracion => fin - inicio;

  String get rango => formatearRango(inicio, fin);

  /// Mismo día y franjas que se cruzan. Si uno termina justo cuando el
  /// otro empieza (9:00 y 9:00), no se cruzan.
  bool seCruzaCon(BloqueHorario otro) =>
      dia == otro.dia && inicio < otro.fin && otro.inicio < fin;

  BloqueHorario copyWith({
    int? materiaId,
    int? dia,
    int? inicio,
    int? fin,
    String? salon,
  }) {
    return BloqueHorario(
      id: id,
      materiaId: materiaId ?? this.materiaId,
      dia: dia ?? this.dia,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      salon: salon ?? this.salon,
    );
  }

  Set<ErrorBloque> validar() {
    final errores = <ErrorBloque>{};
    if (dia < 1 || dia > 7) errores.add(ErrorBloque.diaInvalido);
    if (inicio < 0 || fin > minutosPorDia) {
      errores.add(ErrorBloque.horaFueraDeRango);
    }
    if (fin <= inicio) errores.add(ErrorBloque.finNoPosterior);
    return errores;
  }

  bool get esValido => validar().isEmpty;

  @override
  bool operator ==(Object other) =>
      other is BloqueHorario &&
      other.id == id &&
      other.materiaId == materiaId &&
      other.dia == dia &&
      other.inicio == inicio &&
      other.fin == fin &&
      other.salon == salon;

  @override
  int get hashCode => Object.hash(id, materiaId, dia, inicio, fin, salon);
}
