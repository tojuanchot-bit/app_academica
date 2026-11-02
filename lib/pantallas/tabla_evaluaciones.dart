import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/configuracion_escala.dart';
import '../dominio/evaluacion.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'evaluacion_form_page.dart';
import 'widgets_materia.dart';

/// Evaluaciones de una materia en formato de tabla compacta (fila
/// desplegada de Notas). Solo se edita si la materia está en curso; para
/// editar una cerrada o cancelada, primero se reabre en Materias.
class TablaEvaluaciones extends ConsumerWidget {
  const TablaEvaluaciones({super.key, required this.materia});

  final Materia materia;

  void _abrirFormulario(
    BuildContext context, {
    Evaluacion? padre,
    Evaluacion? existente,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EvaluacionFormPage(
          materiaId: materia.id!,
          padre: padre,
          existente: existente,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final todas = switch (ref.watch(evaluacionesProvider(materia.id!))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (todas == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final escala = escalaActual(ref);
    final editable = materia.estado == EstadoMateria.enCurso;
    final raiz = primerNivel(todas);
    final suma = sumaPorcentajes(raiz);
    // Solo hay definitiva si el 100 % está definido y todo tiene nota.
    final completa = editable ? definitiva(todas, escala) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (raiz.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              editable
                  ? 'Aún no hay evaluaciones. Agrega los parciales, quices y '
                      'trabajos con su porcentaje.'
                  : 'Sin evaluaciones registradas.',
              style: tema.textTheme.bodyMedium,
            ),
          ),
        for (final e in raiz)
          ..._filasDe(context, e, hijasDe(todas, e.id!), escala, editable),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Text('Total ${formatearPorcentaje(suma)}',
                  style: tema.textTheme.titleSmall),
            ),
            if (editable && suma < porcentajeCompleto)
              TextButton.icon(
                onPressed: () => _abrirFormulario(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Evaluación'),
              ),
          ],
        ),
        // Atajo: el lugar principal para cerrar es el detalle de la materia.
        if (completa != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: FilledButton.icon(
              onPressed: () =>
                  cerrarMateriaCon(context, ref, materia, completa, escala),
              icon: const Icon(Icons.lock_outline),
              label: Text('Cerrar materia con ${escala.formatear(completa)}'),
            ),
          ),
      ],
    );
  }

  /// La fila de [e] y, si es compuesta, las de sus sub-evaluaciones.
  List<Widget> _filasDe(
    BuildContext context,
    Evaluacion e,
    List<Evaluacion> hijas,
    ConfiguracionEscala escala,
    bool editable,
  ) {
    final tema = Theme.of(context);
    final compuesta = hijas.isNotEmpty;
    final String nota;
    if (compuesta) {
      final valor = notaCompuesta(hijas, escala);
      nota = valor == null
          ? '—'
          : escala.formatear(redondearAEscala(valor, escala));
    } else {
      nota = e.nota == null ? '—' : escala.formatear(e.nota!);
    }
    final reparto = modoReparto(hijas);
    final mezclaPorcentajes = compuesta &&
        reparto == ModoReparto.partesIguales &&
        hijas.any((h) => h.porcentaje != null);

    return [
      _FilaEvaluacion(
        nombre: e.nombre,
        porcentaje: formatearPorcentaje(e.porcentaje ?? 0),
        nota: nota,
        onTap: editable ? () => _abrirFormulario(context, existente: e) : null,
        // Sin nota propia se le pueden agregar sub-evaluaciones (D-007).
        accion: editable && e.nota == null
            ? IconButton(
                tooltip: 'Agregar sub-evaluación',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.playlist_add, size: 20),
                onPressed: () => _abrirFormulario(context, padre: e),
              )
            : null,
      ),
      for (final h in hijas)
        _FilaEvaluacion(
          sangria: true,
          nombre: h.nombre,
          porcentaje: reparto == ModoReparto.porcentajes
              ? formatearPorcentaje(h.porcentaje!)
              : '1/${hijas.length}',
          nota: h.nota == null ? '—' : escala.formatear(h.nota!),
          onTap: editable
              ? () => _abrirFormulario(context, existente: h, padre: e)
              : null,
        ),
      if (mezclaPorcentajes)
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 4),
          child: Text(
            'Los porcentajes internos no suman 100 %, así que se '
            'reparten en partes iguales.',
            style: tema.textTheme.bodySmall
                ?.copyWith(color: tema.colorScheme.error),
          ),
        ),
    ];
  }
}

/// Una fila de la tabla: nombre | porcentaje | nota | acción opcional.
/// Las columnas tienen ancho fijo para que todo quede alineado.
class _FilaEvaluacion extends StatelessWidget {
  const _FilaEvaluacion({
    required this.nombre,
    required this.porcentaje,
    required this.nota,
    this.sangria = false,
    this.onTap,
    this.accion,
  });

  final String nombre;
  final String porcentaje;
  final String nota;
  final bool sangria;
  final VoidCallback? onTap;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          children: [
            if (sangria) ...[
              const SizedBox(width: 8),
              const Icon(Icons.subdirectory_arrow_right, size: 16),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                nombre,
                style: sangria
                    ? tema.textTheme.bodyMedium
                    : tema.textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              width: 64,
              child: Text(porcentaje,
                  textAlign: TextAlign.end, style: tema.textTheme.bodySmall),
            ),
            SizedBox(
              width: 48,
              child: Text(nota,
                  textAlign: TextAlign.end, style: tema.textTheme.titleSmall),
            ),
            SizedBox(width: 44, child: accion),
          ],
        ),
      ),
    );
  }
}
