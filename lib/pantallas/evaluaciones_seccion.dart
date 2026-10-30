import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/configuracion_escala.dart';
import '../dominio/evaluacion.dart';
import '../dominio/formato_fecha.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'evaluacion_form_page.dart';
import 'widgets_materia.dart';

/// Lista de evaluaciones de una materia, con las compuestas y sus
/// sub-evaluaciones. Solo se edita si la materia está en curso.
class EvaluacionesSeccion extends ConsumerWidget {
  const EvaluacionesSeccion({super.key, required this.materia});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Evaluaciones', style: tema.textTheme.titleMedium),
            ),
            Text('${formatearPorcentaje(suma)} de 100 %',
                style: tema.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: suma / porcentajeCompleto,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 8),
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
          _TarjetaEvaluacion(
            evaluacion: e,
            hijas: hijasDe(todas, e.id!),
            escala: escala,
            editable: editable,
            onEditar: (ev) => _abrirFormulario(
              context,
              existente: ev,
              padre: ev.esHija ? e : null,
            ),
            onAgregarHija: () => _abrirFormulario(context, padre: e),
          ),
        if (editable && suma < porcentajeCompleto) ...[
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => _abrirFormulario(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar evaluación'),
          ),
        ],
      ],
    );
  }
}

class _TarjetaEvaluacion extends StatelessWidget {
  const _TarjetaEvaluacion({
    required this.evaluacion,
    required this.hijas,
    required this.escala,
    required this.editable,
    required this.onEditar,
    required this.onAgregarHija,
  });

  final Evaluacion evaluacion;
  final List<Evaluacion> hijas;
  final ConfiguracionEscala escala;
  final bool editable;
  final ValueChanged<Evaluacion> onEditar;
  final VoidCallback onAgregarHija;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final e = evaluacion;
    final compuesta = hijas.isNotEmpty;

    // Nota que se muestra a la derecha.
    final String textoNota;
    String? detalleNota;
    if (compuesta) {
      final valor = notaCompuesta(hijas, escala);
      if (valor == null) {
        final faltan = hijas.where((h) => h.nota == null).length;
        textoNota = '—';
        detalleNota = faltan == 1 ? 'falta 1' : 'faltan $faltan';
      } else {
        textoNota = escala.formatear(redondearAEscala(valor, escala));
        detalleNota = 'calculada';
      }
    } else {
      final nota = e.nota;
      textoNota = nota == null ? '—' : escala.formatear(nota);
    }

    final subtitulo = [
      formatearPorcentaje(e.porcentaje ?? 0),
      if (e.fecha case final f?) formatearFecha(f),
    ].join(' · ');

    final reparto = modoReparto(hijas);
    final mezclaPorcentajes = compuesta &&
        reparto == ModoReparto.partesIguales &&
        hijas.any((h) => h.porcentaje != null);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: editable ? () => onEditar(e) : null,
            title: Text(e.nombre),
            subtitle: Text(subtitulo),
            trailing: _Nota(texto: textoNota, detalle: detalleNota),
          ),
          if (compuesta)
            for (final h in hijas)
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 32, right: 16),
                onTap: editable ? () => onEditar(h) : null,
                leading: const Icon(Icons.subdirectory_arrow_right, size: 18),
                title: Text(h.nombre),
                subtitle: Text(
                  reparto == ModoReparto.porcentajes
                      ? formatearPorcentaje(h.porcentaje!)
                      : 'Partes iguales',
                ),
                trailing: Text(
                  h.nota == null ? '—' : escala.formatear(h.nota!),
                  style: tema.textTheme.titleSmall,
                ),
              ),
          if (mezclaPorcentajes)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Los porcentajes internos no suman 100 %, así que se '
                'reparten en partes iguales.',
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.colorScheme.error),
              ),
            ),
          if (editable && e.nota == null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: TextButton.icon(
                  onPressed: onAgregarHija,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Sub-evaluación'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Nota extends StatelessWidget {
  const _Nota({required this.texto, this.detalle});

  final String texto;
  final String? detalle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final d = detalle;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(texto, style: tema.textTheme.titleMedium),
        if (d != null) Text(d, style: tema.textTheme.labelSmall),
      ],
    );
  }
}
