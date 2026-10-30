import 'redondeo.dart';

/// Las notas de la escala se guardan en centésimas: 300 = 3.00.
/// La app permite como máximo 2 decimales, así que todo cabe exacto en int.
const int decimalesMaximos = 2;

/// Cada error trae su mensaje para mostrarlo en la pantalla.
enum ErrorEscala {
  decimalesFueraDeRango('Los decimales deben estar entre 0 y 2.'),
  minimaNegativa('La nota mínima no puede ser negativa.'),
  minimaNoMenorQueMaxima('La nota mínima debe ser menor que la máxima.'),
  aprobatoriaFueraDeRango(
      'La nota aprobatoria debe estar entre la mínima y la máxima.'),
  noRepresentable('Las notas deben tener como máximo los decimales elegidos.');

  const ErrorEscala(this.mensaje);
  final String mensaje;
}

class ConfiguracionEscala {
  const ConfiguracionEscala({
    required this.notaMinima,
    required this.notaMaxima,
    required this.notaAprobatoria,
    required this.decimales,
    required this.modo,
    required this.redondearIntermedias,
  });

  /// ITM: 0–5, aprueba con 3.0, un decimal, todo se redondea (D-008).
  static const itm = ConfiguracionEscala(
    notaMinima: 0,
    notaMaxima: 500,
    notaAprobatoria: 300,
    decimales: 1,
    modo: ModoRedondeo.redondear,
    redondearIntermedias: true,
  );

  static const diez = ConfiguracionEscala(
    notaMinima: 0,
    notaMaxima: 1000,
    notaAprobatoria: 600,
    decimales: 1,
    modo: ModoRedondeo.redondear,
    redondearIntermedias: true,
  );

  static const cien = ConfiguracionEscala(
    notaMinima: 0,
    notaMaxima: 10000,
    notaAprobatoria: 6000,
    decimales: 0,
    modo: ModoRedondeo.redondear,
    redondearIntermedias: true,
  );

  final int notaMinima; // en centésimas
  final int notaMaxima; // en centésimas
  final int notaAprobatoria; // en centésimas
  final int decimales;
  final ModoRedondeo modo;
  final bool redondearIntermedias;

  /// Centésimas que hay en una unidad de la escala (1 decimal → 10).
  int get centesimasPorUnidad => potencia10(decimalesMaximos - decimales);

  ConfiguracionEscala copyWith({
    int? notaMinima,
    int? notaMaxima,
    int? notaAprobatoria,
    int? decimales,
    ModoRedondeo? modo,
    bool? redondearIntermedias,
  }) {
    return ConfiguracionEscala(
      notaMinima: notaMinima ?? this.notaMinima,
      notaMaxima: notaMaxima ?? this.notaMaxima,
      notaAprobatoria: notaAprobatoria ?? this.notaAprobatoria,
      decimales: decimales ?? this.decimales,
      modo: modo ?? this.modo,
      redondearIntermedias: redondearIntermedias ?? this.redondearIntermedias,
    );
  }

  /// Devuelve todos los errores; vacío si la escala es válida.
  Set<ErrorEscala> validar() {
    final errores = <ErrorEscala>{};

    if (decimales < 0 || decimales > decimalesMaximos) {
      errores.add(ErrorEscala.decimalesFueraDeRango);
      return errores;
    }
    if (notaMinima < 0) errores.add(ErrorEscala.minimaNegativa);
    if (notaMinima >= notaMaxima) {
      errores.add(ErrorEscala.minimaNoMenorQueMaxima);
    }
    if (notaAprobatoria < notaMinima || notaAprobatoria > notaMaxima) {
      errores.add(ErrorEscala.aprobatoriaFueraDeRango);
    }

    final paso = centesimasPorUnidad;
    if (notaMinima % paso != 0 ||
        notaMaxima % paso != 0 ||
        notaAprobatoria % paso != 0) {
      errores.add(ErrorEscala.noRepresentable);
    }
    return errores;
  }

  bool get esValida => validar().isEmpty;

  /// Texto de una nota de la escala (en centésimas) con sus decimales.
  String formatear(int centesimas) => formatearCentesimas(centesimas, decimales);

  /// Mensaje de error si la nota (en centésimas) no es válida en esta escala.
  String? errorNota(int centesimas) {
    if (centesimas < notaMinima || centesimas > notaMaxima) {
      return 'La nota debe estar entre ${formatear(notaMinima)} '
          'y ${formatear(notaMaxima)}.';
    }
    if (centesimas % centesimasPorUnidad != 0) {
      return decimales == 0
          ? 'La nota no puede tener decimales.'
          : 'La nota puede tener máximo $decimales '
              '${decimales == 1 ? 'decimal' : 'decimales'}.';
    }
    return null;
  }

  bool aprueba(int centesimas) => centesimas >= notaAprobatoria;

  @override
  bool operator ==(Object other) =>
      other is ConfiguracionEscala &&
      other.notaMinima == notaMinima &&
      other.notaMaxima == notaMaxima &&
      other.notaAprobatoria == notaAprobatoria &&
      other.decimales == decimales &&
      other.modo == modo &&
      other.redondearIntermedias == redondearIntermedias;

  @override
  int get hashCode => Object.hash(
        notaMinima,
        notaMaxima,
        notaAprobatoria,
        decimales,
        modo,
        redondearIntermedias,
      );
}

/// Un caso de la vista previa: "2.95 → 3.0, aprueba".
class EjemploRedondeo {
  const EjemploRedondeo({
    required this.original,
    required this.redondeada,
    required this.aprueba,
  });

  final String original;
  final String redondeada;
  final bool aprueba;
}

/// Los dos valores que quedan media unidad por debajo y por encima de la
/// nota aprobatoria (ITM: 2.95 y 3.05), redondeados con la escala.
/// Solo tiene sentido con una escala válida.
List<EjemploRedondeo> ejemplosRedondeo(ConfiguracionEscala escala) {
  final paso = escala.centesimasPorUnidad;
  final mediaUnidadEnMilesimas = 5 * paso;
  final ejemplos = <EjemploRedondeo>[];

  for (final signo in const [-1, 1]) {
    final milesimas = escala.notaAprobatoria * 10 + signo * mediaUnidadEnMilesimas;
    if (milesimas < escala.notaMinima * 10 || milesimas > escala.notaMaxima * 10) {
      continue;
    }
    final unidades = redondearNota(
      milesimas,
      1000,
      decimales: escala.decimales,
      modo: escala.modo,
    );
    ejemplos.add(EjemploRedondeo(
      original: formatearNota(milesimas ~/ paso, escala.decimales + 1),
      redondeada: formatearNota(unidades, escala.decimales),
      aprueba: unidades * paso >= escala.notaAprobatoria,
    ));
  }
  return ejemplos;
}
