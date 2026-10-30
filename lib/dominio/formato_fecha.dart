const _meses = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

// DateTime.weekday: 1 = lunes … 7 = domingo.
const _dias = [
  'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo',
];

/// "30 oct 2026"
String formatearFecha(DateTime f) =>
    '${f.day} ${_meses[f.month - 1].substring(0, 3)} ${f.year}';

/// "viernes 30 de octubre"
String formatearFechaLarga(DateTime f) =>
    '${_dias[f.weekday - 1]} ${f.day} de ${_meses[f.month - 1]}';
