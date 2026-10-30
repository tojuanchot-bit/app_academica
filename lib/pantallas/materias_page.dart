import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/formato_fecha.dart';
import '../dominio/materia.dart';
import '../dominio/semestre.dart';
import '../estado/providers.dart';
import 'materia_detalle_page.dart';
import 'materia_form_page.dart';
import 'semestre_form_page.dart';
import 'widgets_materia.dart';

enum _AccionSemestre { nuevo, editar, activar, eliminar }

/// Pestaña Materias: elige un semestre y muestra sus materias por estado.
class MateriasPage extends ConsumerStatefulWidget {
  const MateriasPage({super.key});

  @override
  ConsumerState<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends ConsumerState<MateriasPage> {
  int? _seleccionado;

  Future<void> _abrirSemestre([Semestre? existente]) async {
    final id = await Navigator.of(context).push<int>(
      MaterialPageRoute(builder: (_) => SemestreFormPage(existente: existente)),
    );
    if (id != null && mounted) setState(() => _seleccionado = id);
  }

  Future<void> _eliminarSemestre(Semestre s, int cantidadMaterias) async {
    final db = ref.read(baseDatosProvider);
    final ok = await confirmar(
      context,
      titulo: '¿Eliminar ${s.nombre}?',
      mensaje: cantidadMaterias == 0
          ? 'El semestre no tiene materias.'
          : 'También se borrarán sus $cantidadMaterias materias. '
              'No se puede deshacer.',
      accion: 'Eliminar',
    );
    if (!ok) return;
    await db.eliminarSemestre(s.id!);
    if (mounted) setState(() => _seleccionado = null);
  }

  void _abrirMateria(Materia m) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MateriaDetallePage(materiaId: m.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (ref.watch(semestresProvider)) {
      AsyncData(:final value) => _conSemestres(value),
      AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('No se pudieron cargar los semestres: $error'),
          ),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }

  Widget _conSemestres(List<Semestre> lista) {
    final semestre = elegirSemestre(lista, _seleccionado);
    if (semestre == null) {
      return _SinSemestres(onCrear: () => _abrirSemestre());
    }
    final id = semestre.id!;
    final materias = switch (ref.watch(materiasProvider(id))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final tema = Theme.of(context);

    final rango = [
      if (semestre.fechaInicio case final inicio?) formatearFecha(inicio),
      if (semestre.fechaFin case final fin?) formatearFecha(fin),
    ].join(' – ');

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: materias == null
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MateriaFormPage(
                      semestreId: id,
                      colorInicial: colorSugerido(materias.length),
                    ),
                  ),
                ),
        icon: const Icon(Icons.add),
        label: const Text('Materia'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: id,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  style: tema.textTheme.headlineSmall
                      ?.copyWith(color: tema.colorScheme.onSurface),
                  items: [
                    for (final s in lista)
                      DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          s.activo ? '${s.nombre} · activo' : s.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _seleccionado = v),
                ),
              ),
              PopupMenuButton<_AccionSemestre>(
                tooltip: 'Opciones del semestre',
                onSelected: (accion) {
                  switch (accion) {
                    case _AccionSemestre.nuevo:
                      _abrirSemestre();
                    case _AccionSemestre.editar:
                      _abrirSemestre(semestre);
                    case _AccionSemestre.activar:
                      ref.read(baseDatosProvider).marcarActivo(id);
                    case _AccionSemestre.eliminar:
                      _eliminarSemestre(semestre, materias?.length ?? 0);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: _AccionSemestre.nuevo,
                    child: Text('Nuevo semestre'),
                  ),
                  const PopupMenuItem(
                    value: _AccionSemestre.editar,
                    child: Text('Editar semestre'),
                  ),
                  if (!semestre.activo)
                    const PopupMenuItem(
                      value: _AccionSemestre.activar,
                      child: Text('Marcar como activo'),
                    ),
                  const PopupMenuItem(
                    value: _AccionSemestre.eliminar,
                    child: Text('Eliminar semestre'),
                  ),
                ],
              ),
            ],
          ),
          if (rango.isNotEmpty)
            Text(rango, style: tema.textTheme.bodyMedium),
          const SizedBox(height: 12),
          if (materias == null)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (materias.isEmpty)
            const _SinMaterias()
          else
            ..._listaMaterias(materias),
        ],
      ),
    );
  }

  List<Widget> _listaMaterias(List<Materia> materias) {
    final tema = Theme.of(context);
    final resumen = resumenCreditos(materias);
    final enCurso =
        materias.where((m) => m.estado == EstadoMateria.enCurso).toList();
    final cerradas = materias.where((m) => m.estado.estaCerrada).toList();
    final canceladas =
        materias.where((m) => m.estado == EstadoMateria.cancelada).toList();

    final partesResumen = [
      if (resumen.enCurso > 0) '${resumen.enCurso} en curso',
      if (resumen.aprobados > 0) '${resumen.aprobados} aprobados',
      if (resumen.reprobados > 0) '${resumen.reprobados} reprobados',
      if (resumen.cancelados > 0) '${resumen.cancelados} cancelados',
    ];

    Widget seccion(String titulo, List<Materia> lista) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(titulo, style: tema.textTheme.titleMedium),
            const SizedBox(height: 4),
            for (final m in lista)
              MateriaTile(materia: m, onTap: () => _abrirMateria(m)),
          ],
        );

    final escala = escalaActual(ref);
    final promedio = promedioPonderado(materias, escala);

    return [
      if (promedio != null)
        Text(
          'Promedio del semestre: ${escala.formatear(promedio)}',
          style: tema.textTheme.titleMedium,
        ),
      Text(
        'Créditos: ${partesResumen.join(' · ')}',
        style: tema.textTheme.bodyMedium,
      ),
      if (enCurso.isNotEmpty) seccion('En curso', enCurso),
      if (cerradas.isNotEmpty) seccion('Cerradas', cerradas),
      if (canceladas.isNotEmpty) seccion('Canceladas', canceladas),
    ];
  }
}

class _SinSemestres extends StatelessWidget {
  const _SinSemestres({required this.onCrear});

  final VoidCallback onCrear;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined,
                size: 56, color: tema.colorScheme.primary),
            const SizedBox(height: 12),
            Text('Crea tu primer semestre',
                style: tema.textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Por ejemplo 2026-2. Después le agregas sus materias.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCrear,
              icon: const Icon(Icons.add),
              label: const Text('Crear semestre'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SinMaterias extends StatelessWidget {
  const _SinMaterias();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text(
        'Este semestre aún no tiene materias.\n'
        'Toca "+ Materia" para agregar la primera.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
