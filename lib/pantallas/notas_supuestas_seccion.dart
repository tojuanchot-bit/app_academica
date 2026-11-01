import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/configuracion_escala.dart';
import '../dominio/evaluacion.dart';
import '../dominio/nota_supuesta.dart';
import '../estado/providers.dart';

/// Campos para fijar notas supuestas en las evaluaciones pendientes de una
/// materia (RF-04, fase 2b). Solo cambian la proyección, no las notas reales.
class NotasSupuestasSeccion extends ConsumerStatefulWidget {
  const NotasSupuestasSeccion({
    super.key,
    required this.materiaId,
    required this.todas,
    required this.escala,
  });

  final int materiaId;
  final List<Evaluacion> todas;
  final ConfiguracionEscala escala;

  @override
  ConsumerState<NotasSupuestasSeccion> createState() =>
      _NotasSupuestasSeccionState();
}

class _NotasSupuestasSeccionState extends ConsumerState<NotasSupuestasSeccion> {
  /// Un controlador por evaluación, para que el texto no se pierda mientras
  /// se escribe y la base de datos se actualiza.
  final _controladores = <int, TextEditingController>{};
  final _errores = <int, String>{};

  @override
  void didUpdateWidget(NotasSupuestasSeccion anterior) {
    super.didUpdateWidget(anterior);
    // Las evaluaciones que dejaron de estar pendientes (se registró la nota
    // real o se borraron) sueltan su campo.
    final vigentes = {for (final e in widget.todas) e.id};
    final sobran =
        _controladores.keys.where((id) => !_esPendiente(id, vigentes)).toList();
    for (final id in sobran) {
      final c = _controladores.remove(id)!;
      _errores.remove(id);
      WidgetsBinding.instance.addPostFrameCallback((_) => c.dispose());
    }
  }

  bool _esPendiente(int id, Set<int?> vigentes) {
    if (!vigentes.contains(id)) return false;
    final e = widget.todas.firstWhere((x) => x.id == id);
    final hijas = hijasDe(widget.todas, id);
    return hijas.isEmpty
        ? e.nota == null
        : hijas.any((h) => h.nota == null);
  }

  @override
  void dispose() {
    for (final c in _controladores.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controlador(Evaluacion e) =>
      _controladores.putIfAbsent(
        e.id!,
        () => TextEditingController(
          text: switch (e.notaSupuesta) {
            final s? => widget.escala.formatear(s),
            null => '',
          },
        ),
      );

  Future<void> _alCambiar(Evaluacion e, String texto) async {
    final db = ref.read(baseDatosProvider);
    final id = e.id!;
    if (texto.trim().isEmpty) {
      setState(() => _errores.remove(id));
      await db.guardarNotaSupuesta(id, null);
      return;
    }
    final lectura = leerNotaSupuesta(texto, e, widget.todas, widget.escala);
    setState(() {
      if (lectura.esValida) {
        _errores.remove(id);
      } else {
        _errores[id] = lectura.error!;
      }
    });
    // Se escribe siempre: [e] puede venir de la reconstrucción anterior si
    // el usuario escribe rápido, así que no se compara con su valor.
    if (lectura.esValida) await db.guardarNotaSupuesta(id, lectura.valor);
  }

  Future<void> _quitar(Evaluacion e) async {
    _controladores[e.id!]?.clear();
    setState(() => _errores.remove(e.id));
    await ref.read(baseDatosProvider).guardarNotaSupuesta(e.id!, null);
  }

  Future<void> _quitarTodas() async {
    for (final c in _controladores.values) {
      c.clear();
    }
    setState(_errores.clear);
    await ref.read(baseDatosProvider).quitarNotasSupuestas(widget.materiaId);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final todas = widget.todas;
    final filas = <Widget>[];

    for (final e in primerNivel(todas)) {
      final hijas = hijasDe(todas, e.id!);
      final porcentaje = formatearPorcentaje(e.porcentaje ?? 0);
      if (hijas.isEmpty) {
        if (e.nota == null) filas.add(_fila(e, subtitulo: porcentaje));
        continue;
      }
      final pendientes = hijas.where((h) => h.nota == null).toList();
      if (pendientes.isEmpty) continue;
      filas.add(_fila(e, subtitulo: '$porcentaje · completa o por partes'));
      final reparto = modoReparto(hijas);
      for (final h in pendientes) {
        filas.add(_fila(
          h,
          sangria: true,
          subtitulo: reparto == ModoReparto.porcentajes
              ? formatearPorcentaje(h.porcentaje!)
              : 'Partes iguales',
          bloqueadaPor: e.notaSupuesta != null ? e.nombre : null,
        ));
      }
    }
    if (filas.isEmpty) return const SizedBox.shrink();

    final hayAlguna = todas.any((e) => e.notaSupuesta != null);
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.push_pin_outlined,
                    size: 20, color: tema.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text('Notas supuestas', style: tema.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'Escribe una nota para probar escenarios. '
                'No cambia tus notas reales.',
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),
            ...filas,
            if (hayAlguna)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _quitarTodas,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Quitar todas las suposiciones'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fila(
    Evaluacion e, {
    required String subtitulo,
    bool sangria = false,
    String? bloqueadaPor,
  }) {
    final tema = Theme.of(context);
    final controlador = _controlador(e);
    final error = _errores[e.id];
    final bloqueada = bloqueadaPor != null;
    final fijada = e.notaSupuesta != null && !bloqueada && error == null;
    final atenuado = tema.textTheme.bodySmall
        ?.copyWith(color: tema.colorScheme.onSurfaceVariant);

    return Padding(
      padding: EdgeInsets.only(left: sangria ? 20 : 0, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sangria)
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 4),
                  child: Icon(Icons.subdirectory_arrow_right,
                      size: 18, color: tema.colorScheme.onSurfaceVariant),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.nombre, style: tema.textTheme.bodyLarge),
                    Text(subtitulo, style: atenuado),
                    if (fijada) const MarcaSupuesta(),
                    if (bloqueada)
                      Text('Usando la nota supuesta de $bloqueadaPor',
                          style: atenuado?.copyWith(
                              fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 76,
                child: TextField(
                  controller: controlador,
                  enabled: !bloqueada,
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '—',
                    border: const OutlineInputBorder(),
                    // Borde rojo; el mensaje va debajo de la fila completa.
                    error: error == null ? null : const SizedBox.shrink(),
                  ),
                  onChanged: (t) => _alCambiar(e, t),
                ),
              ),
              IconButton(
                tooltip: 'Quitar suposición',
                onPressed: !bloqueada &&
                        (e.notaSupuesta != null || controlador.text.isNotEmpty)
                    ? () => _quitar(e)
                    : null,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline,
                      size: 16, color: tema.colorScheme.error),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(error,
                        style: tema.textTheme.bodySmall
                            ?.copyWith(color: tema.colorScheme.error)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Marca de nota supuesta: ícono y texto (no solo color). Los colores salen
/// del tema, así que funcionan en modo claro y oscuro.
class MarcaSupuesta extends StatelessWidget {
  const MarcaSupuesta({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.push_pin, size: 14, color: cs.onTertiaryContainer),
          const SizedBox(width: 4),
          Text('Supuesta',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: cs.onTertiaryContainer)),
        ],
      ),
    );
  }
}
