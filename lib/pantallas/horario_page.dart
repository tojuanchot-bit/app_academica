import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/bloque_horario.dart';
import '../dominio/horario.dart';
import '../dominio/materia.dart';
import '../estado/horario_provider.dart';
import '../estado/providers.dart';
import 'bloque_form_page.dart';
import 'widgets_materia.dart';

/// Texto y fondo "en riesgo" (D-012), usados para los choques de horario.
const _colorAviso = Color(0xFF8A5A00);
const _fondoAviso = Color(0xFFFFF0CC);

enum _Vista { semana, dia }

/// Pestaña Horario del semestre activo: vista semanal y vista por día.
class HorarioPage extends ConsumerStatefulWidget {
  const HorarioPage({super.key});

  @override
  ConsumerState<HorarioPage> createState() => _HorarioPageState();
}

class _HorarioPageState extends ConsumerState<HorarioPage> {
  _Vista _vista = _Vista.semana;

  /// Día que se ve en la vista por día; empieza en hoy.
  int _dia = DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return switch (ref.watch(horarioActivoProvider)) {
      AsyncData(value: final datos?) => _conDatos(datos),
      AsyncData() => const _Mensaje(
          icono: Icons.event_busy_outlined,
          titulo: 'Sin semestre activo',
          texto: 'En Materias, abre el menú del semestre y márcalo como '
              'activo para ver su horario.',
        ),
      AsyncError(:final error) => _Mensaje(
          icono: Icons.error_outline,
          titulo: 'No se pudo cargar el horario',
          texto: '$error',
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }

  Widget _conDatos(DatosHorario datos) {
    final tema = Theme.of(context);
    final semestreId = datos.semestre.id!;
    final enCurso = datos.materias.where(apareceEnHorario).toList();
    final visibles = clasesVisibles(datos.bloques, datos.materias);
    final conChoque = idsConChoque([for (final c in visibles) c.bloque]);

    void editar(Clase c) => abrirFormularioBloque(
          context,
          semestreId: semestreId,
          existente: c.bloque,
        );

    final contenido = <Widget>[];
    if (enCurso.isEmpty) {
      contenido.add(const _Vacio(
        'El semestre activo no tiene materias en curso.\n'
        'Agrégalas en Materias y vuelve aquí.',
      ));
    } else if (_vista == _Vista.semana) {
      contenido.addAll(_semana(datos, conChoque, editar));
    } else {
      contenido.addAll(_unDia(datos, conChoque, editar));
    }

    return Scaffold(
      floatingActionButton: enCurso.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => abrirFormularioBloque(
                context,
                semestreId: semestreId,
                diaInicial: _vista == _Vista.dia ? _dia : null,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Clase'),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          Text('Horario', style: tema.textTheme.headlineSmall),
          Text('Periodo ${datos.semestre.nombre}',
              style: tema.textTheme.bodyMedium),
          const SizedBox(height: 12),
          SegmentedButton<_Vista>(
            segments: const [
              ButtonSegment(
                value: _Vista.semana,
                icon: Icon(Icons.view_week_outlined),
                label: Text('Semana'),
              ),
              ButtonSegment(
                value: _Vista.dia,
                icon: Icon(Icons.today_outlined),
                label: Text('Día'),
              ),
            ],
            selected: {_vista},
            onSelectionChanged: (s) => setState(() => _vista = s.first),
          ),
          if (conChoque.isNotEmpty) ...[
            const SizedBox(height: 12),
            _AvisoChoques(cantidad: conChoque.length),
          ],
          const SizedBox(height: 8),
          ...contenido,
        ],
      ),
    );
  }

  List<Widget> _semana(
    DatosHorario datos,
    Set<int> conChoque,
    void Function(Clase) editar,
  ) {
    final semana = horarioSemanal(datos.bloques, datos.materias);
    if (semana.values.every((clases) => clases.isEmpty)) {
      return const [
        _Vacio('Aún no tienes clases.\nToca "+ Clase" para agregar la primera.'),
      ];
    }
    final tema = Theme.of(context);
    final hoy = DateTime.now().weekday;
    return [
      for (var d = 1; d <= 7; d++)
        if (d <= 6 || semana[d]!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(
              d == hoy ? '${nombreDia(d)} · hoy' : nombreDia(d),
              style: tema.textTheme.titleMedium?.copyWith(
                color: d == hoy ? tema.colorScheme.primary : null,
              ),
            ),
          ),
          if (semana[d]!.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text('Sin clases', style: tema.textTheme.bodySmall),
            ),
          for (final c in semana[d]!)
            ClaseTile(
              clase: c,
              conChoque: conChoque.contains(c.bloque.id),
              onTap: () => editar(c),
            ),
        ],
    ];
  }

  List<Widget> _unDia(
    DatosHorario datos,
    Set<int> conChoque,
    void Function(Clase) editar,
  ) {
    final tema = Theme.of(context);
    final hoy = DateTime.now().weekday;
    final clases = clasesDelDia(datos.bloques, datos.materias, _dia);
    int mover(int pasos) => (_dia - 1 + pasos) % 7 + 1;

    return [
      Row(
        children: [
          IconButton(
            tooltip: 'Día anterior',
            onPressed: () => setState(() => _dia = mover(-1)),
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              _dia == hoy ? 'Hoy · ${nombreDia(_dia)}' : nombreDia(_dia),
              textAlign: TextAlign.center,
              style: tema.textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: 'Día siguiente',
            onPressed: () => setState(() => _dia = mover(1)),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      if (_dia != hoy)
        Center(
          child: TextButton(
            onPressed: () => setState(() => _dia = hoy),
            child: const Text('Volver a hoy'),
          ),
        ),
      if (clases.isEmpty)
        _Vacio(_dia == hoy ? 'Hoy no tienes clases.' : 'Sin clases este día.'),
      for (final c in clases)
        ClaseTile(
          clase: c,
          conChoque: conChoque.contains(c.bloque.id),
          onTap: () => editar(c),
        ),
    ];
  }
}

/// Abre el formulario para crear o editar un bloque.
void abrirFormularioBloque(
  BuildContext context, {
  required int semestreId,
  BloqueHorario? existente,
  int? materiaInicial,
  int? diaInicial,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BloqueFormPage(
        semestreId: semestreId,
        existente: existente,
        materiaInicial: materiaInicial,
        diaInicial: diaInicial,
      ),
    ),
  );
}

/// Una clase: color de la materia, nombre, hora y salón; ⚠ si choca.
class ClaseTile extends StatelessWidget {
  const ClaseTile({
    super.key,
    required this.clase,
    this.conChoque = false,
    this.onTap,
    this.etiqueta,
    this.resaltada = false,
    this.atenuada = false,
  });

  final Clase clase;
  final bool conChoque;
  final VoidCallback? onTap;

  /// Texto corto a la derecha, por ejemplo "Ahora" o "En 25 min".
  final String? etiqueta;

  /// Fondo del color primario suave (la clase en curso o la siguiente).
  final bool resaltada;

  /// En gris (una clase de hoy que ya pasó).
  final bool atenuada;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final b = clase.bloque;
    final detalle = [
      b.rango,
      if (b.salon.isNotEmpty) 'Salón ${b.salon}',
    ].join(' · ');
    final etiqueta = this.etiqueta;
    return Opacity(
      opacity: atenuada ? 0.5 : 1,
      child: Card(
        color: resaltada ? cs.primaryContainer : null,
        child: ListTile(
          onTap: onTap,
          leading: BarraColor(clase.materia.color),
          title: Text(clase.materia.nombre),
          subtitle: Text(detalle),
          trailing: (etiqueta == null && !conChoque)
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (etiqueta != null)
                      Text(
                        etiqueta,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: resaltada ? cs.onPrimaryContainer : null,
                              fontWeight: resaltada ? FontWeight.bold : null,
                            ),
                      ),
                    if (conChoque) ...[
                      const SizedBox(width: 4),
                      const Tooltip(
                        message: 'Se cruza con otra clase',
                        child: Icon(Icons.warning_amber_rounded,
                            color: _colorAviso),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _AvisoChoques extends StatelessWidget {
  const _AvisoChoques({required this.cantidad});

  final int cantidad;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _fondoAviso,
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded, color: _colorAviso),
        title: Text(
          '$cantidad clases se cruzan',
          style: const TextStyle(color: _colorAviso),
        ),
        subtitle: const Text(
          'Están marcadas con ⚠. Puedes dejarlas así si es a propósito.',
          style: TextStyle(color: _colorAviso),
        ),
      ),
    );
  }
}

/// Sección "Horario" del detalle de una materia. Editable solo en curso;
/// en canceladas y cerradas se ve en gris y en solo lectura.
class HorarioMateriaSeccion extends ConsumerWidget {
  const HorarioMateriaSeccion({super.key, required this.materia});

  final Materia materia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final editable = apareceEnHorario(materia);
    final bloques = switch (ref.watch(bloquesMateriaProvider(materia.id!))) {
      AsyncData(:final value) => value,
      _ => const <BloqueHorario>[],
    };

    return Opacity(
      opacity: editable ? 1 : 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Horario', style: tema.textTheme.titleMedium),
              ),
              if (editable)
                TextButton.icon(
                  onPressed: () => abrirFormularioBloque(
                    context,
                    semestreId: materia.semestreId,
                    materiaInicial: materia.id,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Clase'),
                ),
            ],
          ),
          if (bloques.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                editable
                    ? 'Sin clases registradas.'
                    : 'Sin clases registradas. No aparece en el horario.',
                style: tema.textTheme.bodySmall,
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final b in bloques)
                    ListTile(
                      enabled: editable,
                      leading: const Icon(Icons.schedule),
                      title: Text('${nombreDia(b.dia)} · ${b.rango}'),
                      subtitle:
                          b.salon.isEmpty ? null : Text('Salón ${b.salon}'),
                      onTap: editable
                          ? () => abrirFormularioBloque(
                                context,
                                semestreId: materia.semestreId,
                                existente: b,
                              )
                          : null,
                    ),
                ],
              ),
            ),
          if (!editable && bloques.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'No aparece en el horario porque está '
                '${materia.estado.etiqueta.toLowerCase()}.',
                style: tema.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(texto, textAlign: TextAlign.center),
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje({
    required this.icono,
    required this.titulo,
    required this.texto,
  });

  final IconData icono;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: tema.colorScheme.primary),
            const SizedBox(height: 12),
            Text(titulo, style: tema.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(texto, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
