import 'calculo_notas.dart';
import 'configuracion_escala.dart';
import 'evaluacion.dart';
import 'redondeo.dart';

/// Resultado de leer una nota supuesta: [valor] en centésimas si es válida,
/// o [error] con el mensaje para mostrar en la pantalla.
class LecturaSupuesta {
  const LecturaSupuesta.valida(int this.valor) : error = null;
  const LecturaSupuesta.invalida(String this.error) : valor = null;

  final int? valor;
  final String? error;

  bool get esValida => error == null;
}

/// Lee lo que escribe el usuario como nota supuesta de [e] y la valida:
/// escala y decimales, que esté pendiente y, si es compuesta, que el valor
/// se pueda alcanzar con las notas reales que ya tienen sus hijas.
LecturaSupuesta leerNotaSupuesta(
  String texto,
  Evaluacion e,
  List<Evaluacion> todas,
  ConfiguracionEscala escala,
) {
  final valor = parsearCentesimas(texto);
  if (valor == null) {
    return const LecturaSupuesta.invalida('Escribe un número, por ejemplo 3.5');
  }
  final errorEscala = escala.errorNota(valor);
  if (errorEscala != null) return LecturaSupuesta.invalida(errorEscala);

  final id = e.id;
  final hijas = id == null ? const <Evaluacion>[] : hijasDe(todas, id);

  if (hijas.isEmpty) {
    if (e.nota != null) {
      return const LecturaSupuesta.invalida('Esta evaluación ya tiene nota.');
    }
    final padre = _buscarPadre(e, todas);
    if (padre != null && padre.notaSupuesta != null) {
      return LecturaSupuesta.invalida(
          '${padre.nombre} tiene una nota supuesta completa. '
          'Quítala para suponer sus partes.');
    }
    return LecturaSupuesta.valida(valor);
  }

  final rango = rangoCompuesta(hijas, escala);
  if (rango == null) {
    return LecturaSupuesta.invalida('${e.nombre} ya tiene todas sus notas.');
  }
  final (minimo, maximo) = rango;
  if (valor < minimo || valor > maximo) {
    return LecturaSupuesta.invalida(
        'Con las notas que ya tiene, ${e.nombre} solo puede quedar entre '
        '${escala.formatear(minimo)} y ${escala.formatear(maximo)}.');
  }
  return LecturaSupuesta.valida(valor);
}

/// Rango (mín, máx) en centésimas que puede tomar una compuesta con las
/// notas reales que ya tiene: las hijas pendientes van al mínimo y al
/// máximo de la escala, con la misma [notaCompuesta]. null si no queda
/// ninguna hija pendiente.
(int, int)? rangoCompuesta(List<Evaluacion> hijas, ConfiguracionEscala escala) {
  if (!hijas.any((h) => h.nota == null)) return null;

  Fraccion extremo(int x) => notaCompuesta([
        for (final h in hijas) h.nota == null ? h.conNota(x) : h,
      ], escala)!;

  // Con redondeo intermedio los extremos ya caen en pasos de la escala.
  // Sin él son exactos (3.33…): se ajustan hacia adentro para no aceptar
  // un valor que no se puede alcanzar.
  final paso = escala.centesimasPorUnidad;
  return (
    _techoAPaso(extremo(escala.notaMinima), paso),
    _pisoAPaso(extremo(escala.notaMaxima), paso),
  );
}

int _pisoAPaso(Fraccion f, int paso) =>
    f.numerador ~/ (f.denominador * paso) * paso;

int _techoAPaso(Fraccion f, int paso) {
  final d = f.denominador * paso;
  return (f.numerador + d - 1) ~/ d * paso;
}

Evaluacion? _buscarPadre(Evaluacion e, List<Evaluacion> todas) {
  final padreId = e.padreId;
  if (padreId == null) return null;
  for (final p in todas) {
    if (p.id == padreId) return p;
  }
  return null;
}
