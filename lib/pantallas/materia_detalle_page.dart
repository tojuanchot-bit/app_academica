import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/configuracion_escala.dart';
import '../dominio/formato_fecha.dart';
import '../dominio/materia.dart';
import '../dominio/redondeo.dart';
import '../estado/providers.dart';
import 'evaluaciones_seccion.dart';
import 'materia_form_page.dart';
import 'widgets_materia.dart';

/// Detalle de una materia con sus acciones según el estado.
class MateriaDetallePage extends ConsumerWidget {
  const MateriaDetallePage({super.key, required this.materiaId});

  final int materiaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(materiaProvider(materiaId))) {
      AsyncData(value: final m?) => _Detalle(materia: m),
      AsyncData() => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Esta materia ya no existe.')),
        ),
      AsyncError(:final error) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Error: $error')),
        ),
      _ => Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

class _Detalle extends ConsumerWidget {
  const _Detalle({required this.materia});

  final Materia materia;

  Future<void> _cancelar(BuildContext context, WidgetRef ref) async {
    final db = ref.read(baseDatosProvider);
    final ok = await confirmar(
      context,
      titulo: '¿Cancelar ${materia.nombre}?',
      mensaje: 'Quedará en el historial en solo lectura y no contará en '
          'promedios ni en créditos.',
      accion: 'Cancelar materia',
    );
    if (!ok) return;
    await db.guardarMateria(materia.cancelar(DateTime.now()));
  }

  Future<void> _cerrar(
    BuildContext context,
    WidgetRef ref,
    ConfiguracionEscala escala,
  ) async {
    final db = ref.read(baseDatosProvider);
    final nota = await showDialog<int>(
      context: context,
      builder: (_) => _DialogoNotaFinal(escala: escala),
    );
    if (nota == null) return;
    await db.guardarMateria(materia.cerrar(nota, escala));
  }

  Future<void> _reabrir(BuildContext context, WidgetRef ref) async {
    final db = ref.read(baseDatosProvider);
    final ok = await confirmar(
      context,
      titulo: materia.estado == EstadoMateria.cancelada
          ? '¿Deshacer la cancelación?'
          : '¿Reabrir la materia?',
      mensaje: materia.estado == EstadoMateria.cancelada
          ? 'La materia vuelve a estar en curso.'
          : 'Se borra la nota final y la materia vuelve a estar en curso.',
      accion: materia.estado == EstadoMateria.cancelada ? 'Deshacer' : 'Reabrir',
    );
    if (!ok) return;
    await db.guardarMateria(materia.reabrir());
  }

  Future<void> _eliminar(BuildContext context, WidgetRef ref) async {
    final db = ref.read(baseDatosProvider);
    final navegador = Navigator.of(context);
    final ok = await confirmar(
      context,
      titulo: '¿Eliminar ${materia.nombre}?',
      mensaje: 'Se borra del historial. Si la dejaste de ver, mejor '
          'cancélala. No se puede deshacer.',
      accion: 'Eliminar',
    );
    if (!ok) return;
    navegador.pop();
    await db.eliminarMateria(materia.id!);
  }

  void _editar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MateriaFormPage(
          semestreId: materia.semestreId,
          existente: materia,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    final nota = materia.notaFinal;
    final fechaCancelacion = materia.fechaCancelacion;

    return Scaffold(
      appBar: AppBar(
        title: Text(materia.nombre),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) => _eliminar(context, ref),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'eliminar', child: Text('Eliminar materia')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                BarraColor(materia.color, alto: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(materia.nombre,
                      style: tema.textTheme.headlineSmall),
                ),
                const SizedBox(width: 8),
                EstadoChip(materia.estado),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  if (materia.docente.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Docente'),
                      subtitle: Text(materia.docente),
                    ),
                  ListTile(
                    leading: const Icon(Icons.stars_outlined),
                    title: const Text('Créditos'),
                    subtitle: Text('${materia.creditos}'),
                  ),
                  if (fechaCancelacion != null)
                    ListTile(
                      leading: const Icon(Icons.block),
                      title: const Text('Cancelada el'),
                      subtitle: Text(formatearFecha(fechaCancelacion)),
                    ),
                  if (nota != null)
                    ListTile(
                      leading: const Icon(Icons.grade_outlined),
                      title: const Text('Nota final'),
                      subtitle: Text(
                        '${escala.formatear(nota)} · ${materia.estado.etiqueta}',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EvaluacionesSeccion(materia: materia),
            const SizedBox(height: 24),
            ..._acciones(context, ref, escala),
          ],
        ),
      ),
    );
  }

  List<Widget> _acciones(
    BuildContext context,
    WidgetRef ref,
    ConfiguracionEscala escala,
  ) {
    final tema = Theme.of(context);
    switch (materia.estado) {
      case EstadoMateria.enCurso:
        return [
          Text(
            'La definitiva calculada con las evaluaciones llega en el '
            'siguiente módulo. Por ahora puedes registrar la nota final a mano.',
            style: tema.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _cerrar(context, ref, escala),
            icon: const Icon(Icons.grade_outlined),
            label: const Text('Registrar nota final'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _editar(context),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar datos'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _cancelar(context, ref),
            icon: const Icon(Icons.block),
            label: const Text('Cancelar materia'),
            style: OutlinedButton.styleFrom(
              foregroundColor: tema.colorScheme.error,
            ),
          ),
        ];
      case EstadoMateria.cancelada:
        return [
          Text(
            'Materia cancelada: queda en el historial en solo lectura y no '
            'cuenta en promedios ni en créditos.',
            style: tema.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _reabrir(context, ref),
            icon: const Icon(Icons.undo),
            label: const Text('Deshacer cancelación'),
          ),
        ];
      case EstadoMateria.aprobada:
      case EstadoMateria.reprobada:
        return [
          OutlinedButton.icon(
            onPressed: () => _reabrir(context, ref),
            icon: const Icon(Icons.undo),
            label: const Text('Reabrir para corregir la nota'),
          ),
        ];
    }
  }
}

/// Pide la nota final y muestra en vivo si aprueba. Devuelve centésimas.
class _DialogoNotaFinal extends StatefulWidget {
  const _DialogoNotaFinal({required this.escala});

  final ConfiguracionEscala escala;

  @override
  State<_DialogoNotaFinal> createState() => _DialogoNotaFinalState();
}

class _DialogoNotaFinalState extends State<_DialogoNotaFinal> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final escala = widget.escala;
    final escrito = _texto.text.trim();
    final nota = parsearCentesimas(escrito);
    String? error;
    if (escrito.isNotEmpty && nota == null) {
      error = 'Escribe un número, por ejemplo 3.5';
    } else if (nota != null) {
      error = escala.errorNota(nota);
    }
    return AlertDialog(
      title: const Text('Nota final'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _texto,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Entre ${escala.formatear(escala.notaMinima)} '
                  'y ${escala.formatear(escala.notaMaxima)}',
              border: const OutlineInputBorder(),
              errorText: error,
            ),
          ),
          if (nota != null && error == null) ...[
            const SizedBox(height: 12),
            EstadoChip(escala.aprueba(nota)
                ? EstadoMateria.aprobada
                : EstadoMateria.reprobada),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Volver'),
        ),
        FilledButton(
          onPressed: (nota != null && error == null)
              ? () => Navigator.pop(context, nota)
              : null,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
