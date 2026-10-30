import 'configuracion_escala.dart';
import 'evaluacion.dart';
import 'redondeo.dart';

/// Valor exacto de una nota en centésimas: numerador / denominador.
/// Sirve para no perder exactitud cuando no se redondean las intermedias.
class Fraccion {
  const Fraccion(this.numerador, this.denominador);

  final int numerador;
  final int denominador;

  @override
  bool operator ==(Object other) =>
      other is Fraccion &&
      other.numerador * denominador == numerador * other.denominador;

  @override
  int get hashCode => (numerador / denominador).hashCode;

  @override
  String toString() => '$numerador/$denominador';
}

/// Redondea (o trunca) un valor exacto a los decimales de la escala.
/// Devuelve centésimas: 3.45 en la escala ITM → 350.
int redondearAEscala(Fraccion valor, ConfiguracionEscala escala) {
  final paso = escala.centesimasPorUnidad;
  final unidades = redondearNota(
    valor.numerador,
    valor.denominador * paso,
    decimales: 0,
    modo: escala.modo,
  );
  return unidades * paso;
}

enum ModoReparto { partesIguales, porcentajes }

/// Las sub-evaluaciones usan sus porcentajes solo si todas lo tienen y
/// suman 100 %; si no, se reparten en partes iguales (D-007).
ModoReparto modoReparto(List<Evaluacion> hijas) {
  final todasConPorcentaje =
      hijas.isNotEmpty && hijas.every((h) => h.porcentaje != null);
  return todasConPorcentaje && sumaPorcentajes(hijas) == porcentajeCompleto
      ? ModoReparto.porcentajes
      : ModoReparto.partesIguales;
}

/// Nota de una evaluación compuesta: $R(\sum s_k q_k)$ si se redondean las
/// intermedias, o el valor exacto si no. null si falta alguna sub-nota.
Fraccion? notaCompuesta(List<Evaluacion> hijas, ConfiguracionEscala escala) {
  if (hijas.isEmpty) return null;
  if (hijas.any((h) => h.nota == null)) return null;

  final Fraccion exacta;
  if (modoReparto(hijas) == ModoReparto.porcentajes) {
    var suma = 0;
    for (final h in hijas) {
      suma += h.nota! * h.porcentaje!;
    }
    exacta = Fraccion(suma, porcentajeCompleto);
  } else {
    var suma = 0;
    for (final h in hijas) {
      suma += h.nota!;
    }
    exacta = Fraccion(suma, hijas.length);
  }

  if (!escala.redondearIntermedias) return exacta;
  return Fraccion(redondearAEscala(exacta, escala), 1);
}
