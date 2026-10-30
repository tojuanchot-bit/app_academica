/// Cómo se pasa de un valor exacto a una nota con d decimales.
enum ModoRedondeo { redondear, truncar }

/// 10^n en enteros (pow() de dart:math devuelve num y nos haría convertir).
int potencia10(int n) {
  var resultado = 1;
  for (var i = 0; i < n; i++) {
    resultado *= 10;
  }
  return resultado;
}

/// Redondea el valor exacto numerador/denominador a [decimales] decimales.
/// Devuelve la nota en unidades de 10^-decimales: con 1 decimal, 35 = 3.5.
int redondearNota(
  int numerador,
  int denominador, {
  required int decimales,
  required ModoRedondeo modo,
}) {
  if (denominador <= 0) {
    throw ArgumentError.value(denominador, 'denominador', 'debe ser mayor que 0');
  }
  if (numerador < 0) {
    throw ArgumentError.value(numerador, 'numerador', 'no puede ser negativo');
  }
  if (decimales < 0) {
    throw ArgumentError.value(decimales, 'decimales', 'no puede ser negativo');
  }

  final escalado = numerador * potencia10(decimales);
  return switch (modo) {
    ModoRedondeo.redondear => (2 * escalado + denominador) ~/ (2 * denominador),
    ModoRedondeo.truncar => escalado ~/ denominador,
  };
}

/// Convierte unidades a texto: formatearNota(35, 1) → "3.5".
String formatearNota(int unidades, int decimales) {
  if (decimales == 0) return '$unidades';
  final factor = potencia10(decimales);
  final entera = unidades ~/ factor;
  final fraccion = (unidades % factor).toString().padLeft(decimales, '0');
  return '$entera.$fraccion';
}

/// Lee lo que escribe el usuario ("3", "3.5", "3,45") y lo devuelve en
/// centésimas (300, 350, 345). Devuelve null si no es un número válido,
/// es negativo o tiene más de 2 decimales.
int? parsearCentesimas(String texto) {
  final limpio = texto.trim().replaceAll(',', '.');
  final formato = RegExp(r'^(\d+)(?:\.(\d{0,2}))?$');
  final coincidencia = formato.firstMatch(limpio);
  if (coincidencia == null) return null;

  final entera = int.parse(coincidencia.group(1)!);
  final fraccion = (coincidencia.group(2) ?? '').padRight(2, '0');
  return entera * 100 + int.parse(fraccion);
}

/// Muestra centésimas con los decimales de la escala: (300, 1) → "3.0".
/// Si el valor no cabe en esos decimales, lo muestra con 2 para no ocultarlo.
String formatearCentesimas(int centesimas, int decimales) {
  final d = decimales.clamp(0, 2);
  final paso = potencia10(2 - d);
  if (centesimas % paso == 0) return formatearNota(centesimas ~/ paso, d);
  return formatearNota(centesimas, 2);
}
