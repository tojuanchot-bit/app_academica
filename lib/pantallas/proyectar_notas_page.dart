import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/estado_notas.dart';
import '../dominio/evaluacion.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'resultado_materia.dart';
import 'widgets_materia.dart';

/// "Proyectar notas" (D-024). Paso 1: elegir materias. Paso 2: una tarjeta
/// por materia con su proyección y sus notas supuestas (lo de la Fase 2b).
/// La selección vive solo en esta pantalla; no se guarda.
class ProyectarNotasPage extends ConsumerStatefulWidget {
  const ProyectarNotasPage({
    super.key,
    required this.semestreId,
    this.preelegidas = const {},
    this.directo = false,
  });

  final int semestreId;

  /// Materias que llegan ya marcadas, además de las en riesgo.
  final Set<int> preelegidas;

  /// Desde una alerta de Hoy: solo quedan marcadas las [preelegidas] y se
  /// abre de una vez en el paso 2.
  final bool directo;

  @override
  ConsumerState<ProyectarNotasPage> createState() =>
      _ProyectarNotasPageState();
}

class _ProyectarNotasPageState extends ConsumerState<ProyectarNotasPage> {
  /// null hasta que cargan las evaluaciones; ahí se hace la preselección.
  Set<int>? _elegidas;
  late bool _proyectando = widget.directo;

  void _alternar(int id) => setState(() {
        final e = _elegidas!;
        if (!e.remove(id)) e.add(id);
      });

  @override
  Widget build(BuildContext context) {
    final escala = escalaActual(ref);
    final materias =
        switch (ref.watch(materiasProvider(widget.semestreId))) {
      AsyncData(:final value) => value,
      _ => null,
    };

    // Evaluaciones de cada materia en curso; si alguna no ha cargado, espera.
    final datos = <(Materia, List<Evaluacion>)>[];
    var cargando = materias == null;
    for (final m in materias ?? const <Materia>[]) {
      if (m.estado != EstadoMateria.enCurso) continue;
      switch (ref.watch(evaluacionesProvider(m.id!))) {
        case AsyncData(:final value):
          datos.add((m, value));
        default:
          cargando = true;
      }
    }
    if (cargando) {
      return Scaffold(
        appBar: AppBar(title: const Text('Proyectar notas')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final proyectables = [
      for (final d in datos)
        if (sePuedeProyectar(d.$1, d.$2)) d,
    ];
    final sinProyeccion = [
      for (final d in datos)
        if (!sePuedeProyectar(d.$1, d.$2)) d,
    ];
    final elegidas = _elegidas ??= {
      for (final (m, todas) in proyectables)
        if (widget.preelegidas.contains(m.id) ||
            (!widget.directo && estadoNotas(m, todas, escala).esAlerta))
          m.id!,
    };
    // Si una materia dejó de poder proyectarse, se ignora su marca.
    final validas = elegidas.intersection({
      for (final (m, _) in proyectables) m.id!,
    });

    // Sin nada elegido no hay paso 2 (p. ej., la materia de la alerta ya
    // no se puede proyectar).
    final enPaso2 = _proyectando && validas.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Proyectar notas')),
      body: enPaso2
          ? _paso2([
              for (final (m, _) in proyectables)
                if (validas.contains(m.id)) m,
            ])
          : _paso1(proyectables, sinProyeccion, validas),
      bottomNavigationBar: enPaso2
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: validas.isEmpty
                      ? null
                      : () => setState(() => _proyectando = true),
                  icon: const Icon(Icons.trending_up),
                  label: Text('Proyectar (${validas.length})'),
                ),
              ),
            ),
    );
  }

  Widget _paso1(
    List<(Materia, List<Evaluacion>)> proyectables,
    List<(Materia, List<Evaluacion>)> sinProyeccion,
    Set<int> validas,
  ) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('¿Qué materias quieres proyectar?',
              style: tema.textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
          child: Text('Las que están en riesgo ya vienen marcadas.',
              style: tema.textTheme.bodySmall),
        ),
        if (proyectables.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
                'No hay materias en curso con evaluaciones pendientes.'),
          ),
        for (final (m, todas) in proyectables)
          CheckboxListTile(
            value: validas.contains(m.id),
            onChanged: (_) => _alternar(m.id!),
            secondary: BarraColor(m.color),
            title: Text(m.nombre),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: EstadoNotasChip(estadoNotas(m, todas, escala)),
              ),
            ),
          ),
        if (sinProyeccion.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Text(
              'Sin proyección: ${sinProyeccion.map((d) {
                final (m, todas) = d;
                final motivo = sumaPorcentajes(primerNivel(todas)) ==
                        porcentajeCompleto
                    ? 'sin pendientes'
                    : 'faltan porcentajes';
                return '${m.nombre} ($motivo)';
              }).join(', ')}.',
              style: tema.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _paso2(List<Materia> elegidas) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _proyectando = false),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Cambiar materias'),
          ),
        ),
        for (final m in elegidas)
          Card(
            key: ValueKey(m.id),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      BarraColor(m.color, alto: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child:
                            Text(m.nombre, style: tema.textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ResultadoMateria(materia: m, conTitulo: false),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
