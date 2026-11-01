import 'configuracion_escala.dart';
import 'evaluacion.dart';
import 'materia.dart';
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

  Fraccion operator +(Fraccion otra) => Fraccion._reducida(
        numerador * otra.denominador + otra.numerador * denominador,
        denominador * otra.denominador,
      );

  Fraccion por(int k) => Fraccion._reducida(numerador * k, denominador);

  Fraccion entre(int k) => Fraccion._reducida(numerador, denominador * k);

  /// Simplifica para que los números no crezcan al sumar muchos términos.
  static Fraccion _reducida(int n, int d) {
    final g = n.gcd(d);
    return Fraccion(n ~/ g, d ~/ g);
  }
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

// ------------------------------------------------- Definitiva (D-008)

/// Nota con la que cuenta una evaluación sin hijas: la real; si no hay, la
/// supuesta (solo con [usarSupuestas]); si tampoco, [notaPendientes].
int? _notaHoja(Evaluacion e, int? notaPendientes, bool usarSupuestas) =>
    e.nota ?? (usarSupuestas ? e.notaSupuesta : null) ?? notaPendientes;

/// Nota supuesta de una compuesta entera. Solo vale si la compuesta sigue
/// pendiente (alguna hija sin nota real); si no, mandan las notas reales.
int? _supuestaEntera(Evaluacion compuesta, List<Evaluacion> hijas) =>
    hijas.any((h) => h.nota == null) ? compuesta.notaSupuesta : null;

/// Valor de una evaluación de primer nivel. Las pendientes toman su nota
/// supuesta (con [usarSupuestas]) o [notaPendientes]; si no hay ninguna,
/// quedan sin valor y se devuelve null.
Fraccion? _valorEvaluacion(
  Evaluacion e,
  List<Evaluacion> todas,
  ConfiguracionEscala escala,
  int? notaPendientes,
  bool usarSupuestas,
) {
  final id = e.id;
  final hijas = id == null ? const <Evaluacion>[] : hijasDe(todas, id);
  if (hijas.isEmpty) {
    final n = _notaHoja(e, notaPendientes, usarSupuestas);
    return n == null ? null : Fraccion(n, 1);
  }
  // Fijada entera: reemplaza el cálculo de sus hijas.
  final entera = usarSupuestas ? _supuestaEntera(e, hijas) : null;
  if (entera != null) return Fraccion(entera, 1);

  final completas = <Evaluacion>[];
  for (final h in hijas) {
    final n = _notaHoja(h, notaPendientes, usarSupuestas);
    completas.add(h.nota == null && n != null ? h.conNota(n) : h);
  }
  return notaCompuesta(completas, escala);
}

/// $\sum_i n_i p_i$ en centésimas, sin redondear.
Fraccion? _sumaPonderada(
  List<Evaluacion> todas,
  ConfiguracionEscala escala, {
  int? notaPendientes,
  required bool exigirCompleto,
  bool usarSupuestas = false,
}) {
  final raiz = primerNivel(todas);
  if (raiz.isEmpty) return null;
  if (exigirCompleto && sumaPorcentajes(raiz) != porcentajeCompleto) {
    return null;
  }
  var total = const Fraccion(0, 1);
  for (final e in raiz) {
    final valor =
        _valorEvaluacion(e, todas, escala, notaPendientes, usarSupuestas);
    if (valor == null) return null;
    total = total + valor.por(e.porcentaje ?? 0);
  }
  return total.entre(porcentajeCompleto);
}

/// Definitiva $D = R(\sum_i n_i p_i)$ en centésimas. null si los porcentajes
/// no suman 100 % o hay evaluaciones sin nota (y no se da [notaPendientes]).
/// Con [usarSupuestas], las notas supuestas cuentan como reales (solo para
/// la proyección: el acumulado, el cierre y Hoy no lo pasan).
int? definitiva(
  List<Evaluacion> todas,
  ConfiguracionEscala escala, {
  int? notaPendientes,
  bool usarSupuestas = false,
}) {
  final suma = _sumaPonderada(todas, escala,
      notaPendientes: notaPendientes,
      exigirCompleto: true,
      usarSupuestas: usarSupuestas);
  return suma == null ? null : redondearAEscala(suma, escala);
}

/// Lo que llevas con lo presentado: las pendientes cuentan como 0.
int? acumuladoPresentado(List<Evaluacion> todas, ConfiguracionEscala escala) {
  final suma =
      _sumaPonderada(todas, escala, notaPendientes: 0, exigirCompleto: false);
  return suma == null ? null : redondearAEscala(suma, escala);
}

/// Evaluaciones sin nota que no son compuestas (las que faltan por presentar).
/// Con [usarSupuestas] tampoco cuenta las fijadas ni las hijas de una
/// compuesta fijada entera: quedan solo las que la proyección busca.
int contarPendientes(List<Evaluacion> todas, {bool usarSupuestas = false}) =>
    pendientesBuscadas(todas, usarSupuestas: usarSupuestas).length;

/// Las evaluaciones que cuenta [contarPendientes], en orden. Sirve para
/// nombrarlas ("Necesitas 2.7 en Trabajo final").
List<Evaluacion> pendientesBuscadas(
  List<Evaluacion> todas, {
  bool usarSupuestas = false,
}) {
  final pendientes = <Evaluacion>[];
  for (final e in todas) {
    if (e.nota != null) continue;
    final id = e.id;
    final esCompuesta = id != null && todas.any((h) => h.padreId == id);
    if (esCompuesta) continue;
    if (usarSupuestas &&
        (e.notaSupuesta != null || _padreFijado(e, todas))) {
      continue;
    }
    pendientes.add(e);
  }
  return pendientes;
}

/// true si [e] es hija de una compuesta con nota supuesta entera. Como [e]
/// no tiene nota, esa compuesta sigue pendiente y su suposición vale.
bool _padreFijado(Evaluacion e, List<Evaluacion> todas) {
  final padreId = e.padreId;
  if (padreId == null) return false;
  for (final p in todas) {
    if (p.id == padreId) return p.notaSupuesta != null;
  }
  return false;
}

// ------------------------------------------------- Proyección (D-009)

enum TipoProyeccion {
  /// Los porcentajes de primer nivel no suman 100 %.
  porcentajesIncompletos,

  /// No queda nada pendiente: [Proyeccion.nota] es la definitiva.
  completa,

  /// Todo lo pendiente tiene nota supuesta: [Proyeccion.nota] es la
  /// definitiva que resultaría. No es real, por eso no es [completa].
  simulada,

  /// Con la nota mínima en lo que falta ya se alcanza la meta.
  asegurada,

  /// [Proyeccion.nota] es lo mínimo que necesitas en cada pendiente.
  necesita,

  /// Ni con la máxima se alcanza; [Proyeccion.definitivaMaxima] es el tope.
  noAlcanza,
}

class Proyeccion {
  const Proyeccion(
    this.tipo, {
    this.nota,
    this.definitivaMaxima,
    this.buscadas = 0,
  });

  final TipoProyeccion tipo;
  final int? nota;
  final int? definitivaMaxima;

  /// Cuántas evaluaciones pendientes entraron en la búsqueda (sin contar
  /// las que tienen nota supuesta).
  final int buscadas;
}

/// Prueba cada nota posible (mín, mín + paso, …, máx) en las pendientes
/// y devuelve la menor con la que la definitiva llega a [meta]. Es exacto
/// aunque haya redondeos intermedios, porque usa la misma función
/// [definitiva] en cada intento. Con [usarSupuestas], las fijadas quedan
/// constantes y solo se busca en las demás (D-009 sigue igual).
Proyeccion proyectar(
  List<Evaluacion> todas,
  ConfiguracionEscala escala, {
  required int meta,
  bool usarSupuestas = false,
}) {
  final raiz = primerNivel(todas);
  if (raiz.isEmpty || sumaPorcentajes(raiz) != porcentajeCompleto) {
    return const Proyeccion(TipoProyeccion.porcentajesIncompletos);
  }
  final buscadas = contarPendientes(todas, usarSupuestas: usarSupuestas);
  if (buscadas == 0) {
    final real = contarPendientes(todas) == 0;
    return Proyeccion(
      real ? TipoProyeccion.completa : TipoProyeccion.simulada,
      nota: definitiva(todas, escala, usarSupuestas: !real),
    );
  }
  final paso = escala.centesimasPorUnidad;
  for (var x = escala.notaMinima; x <= escala.notaMaxima; x += paso) {
    final d = definitiva(todas, escala,
        notaPendientes: x, usarSupuestas: usarSupuestas);
    if (d != null && d >= meta) {
      return Proyeccion(
        x == escala.notaMinima
            ? TipoProyeccion.asegurada
            : TipoProyeccion.necesita,
        nota: x,
        buscadas: buscadas,
      );
    }
  }
  return Proyeccion(
    TipoProyeccion.noAlcanza,
    definitivaMaxima: definitiva(todas, escala,
        notaPendientes: escala.notaMaxima, usarSupuestas: usarSupuestas),
    buscadas: buscadas,
  );
}

/// Metas para elegir: la aprobatoria y tres más hacia la máxima.
/// ITM: 3.0, 3.5, 4.0, 4.5.
List<int> metasSugeridas(ConfiguracionEscala escala) {
  final a = escala.notaAprobatoria;
  final rango = escala.notaMaxima - a;
  final paso = escala.centesimasPorUnidad;
  final metas = <int>[];
  for (var k = 0; k < 4; k++) {
    final v = a + (rango * k ~/ 4) ~/ paso * paso;
    if (!metas.contains(v)) metas.add(v);
  }
  return metas;
}

// ------------------------------------------------- Promedios

/// Promedio ponderado por créditos $R(\sum D_j c_j / \sum c_j)$ de las
/// materias aprobadas y reprobadas (D-014). null si no hay ninguna.
int? promedioPonderado(Iterable<Materia> materias, ConfiguracionEscala escala) {
  var sumaNotas = 0;
  var sumaCreditos = 0;
  for (final m in materias) {
    final nota = m.notaFinal;
    if (!m.estado.estaCerrada || nota == null) continue;
    sumaNotas += nota * m.creditos;
    sumaCreditos += m.creditos;
  }
  if (sumaCreditos == 0) return null;
  return redondearAEscala(Fraccion(sumaNotas, sumaCreditos), escala);
}
