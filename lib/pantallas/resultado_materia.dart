import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/configuracion_escala.dart';
import '../dominio/evaluacion.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'widgets_materia.dart';

/// Colores de estado de nota (D-012): texto y fondo.
const _verde = (Color(0xFF17663A), Color(0xFFDDF3E4));
const _ambar = (Color(0xFF8A5A00), Color(0xFFFFF0CC));
const _rojo = (Color(0xFF8C1D18), Color(0xFFFCE4E2));

/// Definitiva, acumulado y proyección de una materia en curso.
class ResultadoMateria extends ConsumerStatefulWidget {
  const ResultadoMateria({super.key, required this.materia});

  final Materia materia;

  @override
  ConsumerState<ResultadoMateria> createState() => _ResultadoMateriaState();
}

class _ResultadoMateriaState extends ConsumerState<ResultadoMateria> {
  int? _meta;

  Future<void> _cerrarCon(int nota, ConfiguracionEscala escala) async {
    final db = ref.read(baseDatosProvider);
    final aprueba = escala.aprueba(nota);
    final ok = await confirmar(
      context,
      titulo: '¿Cerrar con ${escala.formatear(nota)}?',
      mensaje: 'La materia queda ${aprueba ? 'aprobada' : 'reprobada'} con '
          'esa definitiva. Si te equivocas, puedes reabrirla.',
      accion: 'Cerrar materia',
    );
    if (!ok) return;
    await db.guardarMateria(widget.materia.cerrar(nota, escala));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    final todas =
        switch (ref.watch(evaluacionesProvider(widget.materia.id!))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (todas == null || primerNivel(todas).isEmpty) {
      return const SizedBox.shrink();
    }

    final metas = metasSugeridas(escala);
    final meta = (_meta != null && metas.contains(_meta)) ? _meta! : metas.first;
    final proyeccion = proyectar(todas, escala, meta: meta);
    final acumulado = acumuladoPresentado(todas, escala);
    final pendientes = contarPendientes(todas);
    final f = escala.formatear;
    final nombreMeta = meta == escala.notaAprobatoria ? 'aprobar' : f(meta);

    final Widget contenido;
    switch (proyeccion.tipo) {
      case TipoProyeccion.porcentajesIncompletos:
        final suma = sumaPorcentajes(primerNivel(todas));
        contenido = _Mensaje(
          icono: Icons.info_outline,
          colores: _ambar,
          texto: 'Las evaluaciones suman ${formatearPorcentaje(suma)}. '
              'Completa el 100 % para calcular la definitiva y la proyección.',
        );
      case TipoProyeccion.completa:
        final d = proyeccion.nota!;
        final aprueba = escala.aprueba(d);
        contenido = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Mensaje(
              icono: aprueba ? Icons.check_circle_outline : Icons.cancel_outlined,
              colores: aprueba ? _verde : _rojo,
              texto: 'Definitiva: ${f(d)} · '
                  '${aprueba ? 'aprueba' : 'no aprueba'}',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _cerrarCon(d, escala),
              icon: const Icon(Icons.lock_outline),
              label: Text('Cerrar materia con ${f(d)}'),
            ),
          ],
        );
      case TipoProyeccion.asegurada:
        contenido = _Mensaje(
          icono: Icons.check_circle_outline,
          colores: _verde,
          texto: 'Ya aseguraste $nombreMeta: aunque saques '
              '${f(escala.notaMinima)} en lo que falta.',
        );
      case TipoProyeccion.necesita:
        final x = proyeccion.nota!;
        final enRiesgo = x > escala.notaAprobatoria;
        contenido = _Mensaje(
          icono: enRiesgo ? Icons.warning_amber_rounded : Icons.trending_up,
          colores: enRiesgo ? _ambar : _verde,
          texto: 'Necesitas ${f(x)} en '
              '${pendientes == 1 ? 'la evaluación pendiente' : 'cada una de las $pendientes pendientes'} '
              'para $nombreMeta.',
        );
      case TipoProyeccion.noAlcanza:
        final maximo = proyeccion.definitivaMaxima;
        contenido = _Mensaje(
          icono: Icons.cancel_outlined,
          colores: _rojo,
          texto: 'Ni con ${f(escala.notaMaxima)} en todo lo que falta '
              'llegas a ${f(meta)}.'
              '${maximo == null ? '' : ' Lo máximo posible es ${f(maximo)}.'}',
        );
    }

    final mostrarMetas = proyeccion.tipo != TipoProyeccion.completa &&
        proyeccion.tipo != TipoProyeccion.porcentajesIncompletos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Definitiva y proyección', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (acumulado != null && proyeccion.tipo != TipoProyeccion.completa)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Llevas ${f(acumulado)} de ${f(escala.notaMaxima)} con lo presentado.',
              style: tema.textTheme.bodyMedium,
            ),
          ),
        if (mostrarMetas) ...[
          Wrap(
            spacing: 8,
            children: [
              for (final m in metas)
                ChoiceChip(
                  label: Text(m == escala.notaAprobatoria
                      ? 'Aprobar (${f(m)})'
                      : f(m)),
                  selected: m == meta,
                  onSelected: (_) => setState(() => _meta = m),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        contenido,
      ],
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje({
    required this.icono,
    required this.colores,
    required this.texto,
  });

  final IconData icono;
  final (Color, Color) colores;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final (colorTexto, fondo) = colores;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icono, color: colorTexto),
          const SizedBox(width: 12),
          Expanded(
            child: Text(texto, style: TextStyle(color: colorTexto)),
          ),
        ],
      ),
    );
  }
}

/// Alerta corta para Hoy: solo si la materia está en riesgo o no alcanza
/// para aprobar. Si no, no muestra nada.
class AlertaMateria extends ConsumerWidget {
  const AlertaMateria({super.key, required this.materia, this.onTap});

  final Materia materia;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escala = escalaActual(ref);
    final todas = switch (ref.watch(evaluacionesProvider(materia.id!))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (todas == null) return const SizedBox.shrink();

    final p = proyectar(todas, escala, meta: escala.notaAprobatoria);
    final f = escala.formatear;
    final (IconData, (Color, Color), String)? alerta = switch (p.tipo) {
      TipoProyeccion.necesita when p.nota! > escala.notaAprobatoria => (
          Icons.warning_amber_rounded,
          _ambar,
          '${materia.nombre}: necesitas ${f(p.nota!)} en lo que falta para aprobar.',
        ),
      TipoProyeccion.noAlcanza => (
          Icons.cancel_outlined,
          _rojo,
          '${materia.nombre}: ya no alcanza para aprobar.',
        ),
      TipoProyeccion.completa when !escala.aprueba(p.nota!) => (
          Icons.cancel_outlined,
          _rojo,
          '${materia.nombre}: la definitiva es ${f(p.nota!)}.',
        ),
      _ => null,
    };
    if (alerta == null) return const SizedBox.shrink();
    final (icono, colores, texto) = alerta;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _Mensaje(icono: icono, colores: colores, texto: texto),
      ),
    );
  }
}

/// Definitiva calculada de una materia en curso, o null si aún no se puede.
int? definitivaDe(WidgetRef ref, Materia materia) {
  final escala = escalaActual(ref);
  final todas = switch (ref.watch(evaluacionesProvider(materia.id!))) {
    AsyncData(:final value) => value,
    _ => null,
  };
  return todas == null ? null : definitiva(todas, escala);
}
