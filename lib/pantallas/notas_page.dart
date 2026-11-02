import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/configuracion_escala.dart';
import '../dominio/estado_notas.dart';
import '../dominio/materia.dart';
import '../dominio/semestre.dart';
import '../estado/navegacion_provider.dart';
import '../estado/notas_provider.dart';
import '../estado/providers.dart';
import 'proyectar_notas_page.dart';
import 'tabla_evaluaciones.dart';
import 'widgets_materia.dart';

/// Abre la pestaña Notas con [materia] desplegada en su semestre y cierra
/// las pantallas abiertas encima de la barra ("Ver notas", D-024).
void abrirNotasDe(BuildContext context, WidgetRef ref, Materia materia) {
  ref.read(semestreNotasProvider.notifier).elegir(materia.semestreId);
  ref.read(materiasDesplegadasProvider.notifier).desplegar(materia.id!);
  ref.read(materiaEnfocadaProvider.notifier).enfocar(materia.id!);
  ref.read(destinoProvider.notifier).ir(Destino.notas);
  Navigator.of(context).popUntil((ruta) => ruta.isFirst);
}

/// Pestaña Notas (D-024): todas las materias de un semestre en filas
/// plegables, con su acumulado, definitiva y estado.
class NotasPage extends ConsumerWidget {
  const NotasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(semestresProvider)) {
      AsyncData(:final value) => _conSemestres(context, ref, value),
      AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('No se pudieron cargar los semestres: $error'),
          ),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }

  Widget _conSemestres(
    BuildContext context,
    WidgetRef ref,
    List<Semestre> lista,
  ) {
    final tema = Theme.of(context);
    final semestre = elegirSemestre(lista, ref.watch(semestreNotasProvider));
    if (semestre == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Crea un semestre en Materias para ver tus notas.',
              textAlign: TextAlign.center),
        ),
      );
    }
    final id = semestre.id!;
    final materias = switch (ref.watch(materiasProvider(id))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final desplegadas = ref.watch(materiasDesplegadasProvider);
    final escala = escalaActual(ref);

    // Column y no ListView: así todas las filas existen y "Ver notas" puede
    // desplazarse hasta una que esté fuera de pantalla. Son pocas materias.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        DropdownButton<int>(
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
          onChanged: (v) => ref.read(semestreNotasProvider.notifier).elegir(v),
        ),
        const SizedBox(height: 8),
        if (materias == null)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _BotonProyectar(semestreId: id, materias: materias),
          const SizedBox(height: 8),
          _PromedioSemestre(
            promedio: promedioPonderado(materias, escala),
            escala: escala,
          ),
          const SizedBox(height: 8),
          if (materias.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Este semestre no tiene materias. Agrégalas en Materias.',
                style: tema.textTheme.bodyMedium,
              ),
            ),
          for (final m in ordenParaNotas(materias))
            FilaNotas(
              key: ValueKey(m.id),
              materia: m,
              desplegada: desplegadas.contains(m.id),
              onAlternar: () =>
                  ref.read(materiasDesplegadasProvider.notifier).alternar(m.id!),
            ),
        ],
      ],
      ),
    );
  }
}

/// Abre "Proyectar notas". Desactivado si ninguna materia se puede
/// proyectar, con la razón debajo.
class _BotonProyectar extends ConsumerWidget {
  const _BotonProyectar({required this.semestreId, required this.materias});

  final int semestreId;
  final List<Materia> materias;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var proyectables = 0;
    for (final m in materias) {
      final todas = switch (ref.watch(evaluacionesProvider(m.id!))) {
        AsyncData(:final value) => value,
        _ => null,
      };
      if (todas != null && sePuedeProyectar(m, todas)) proyectables++;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.tonalIcon(
          onPressed: proyectables == 0
              ? null
              : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ProyectarNotasPage(semestreId: semestreId),
                    ),
                  ),
          icon: const Icon(Icons.trending_up),
          label: const Text('Proyectar notas'),
        ),
        if (proyectables == 0 && materias.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Ninguna materia en curso tiene evaluaciones pendientes con '
              'el 100 % definido.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

/// Promedio ponderado del semestre con la regla de siempre (D-014): solo
/// cuentan las materias aprobadas y reprobadas.
class _PromedioSemestre extends StatelessWidget {
  const _PromedioSemestre({required this.promedio, required this.escala});

  final int? promedio;
  final ConfiguracionEscala escala;

  @override
  Widget build(BuildContext context) {
    final p = promedio;
    return Card(
      child: ListTile(
        title: const Text('Promedio del semestre'),
        subtitle: Text(p == null
            ? 'Se calcula al cerrar materias'
            : 'Sobre las materias aprobadas y reprobadas'),
        trailing: Text(
          p == null ? '—' : escala.formatear(p),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

/// Una materia en la pestaña Notas. Plegada: color, nombre, acumulado,
/// definitiva y estado. Desplegada: además, la tabla de evaluaciones.
class FilaNotas extends ConsumerWidget {
  const FilaNotas({
    super.key,
    required this.materia,
    required this.desplegada,
    required this.onAlternar,
  });

  final Materia materia;
  final bool desplegada;
  final VoidCallback onAlternar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    final f = escala.formatear;
    final m = materia;
    final todas = switch (ref.watch(evaluacionesProvider(m.id!))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final estado = todas == null ? null : estadoNotas(m, todas, escala);
    final cancelada = m.estado == EstadoMateria.cancelada;

    // Llegó desde "Ver notas": después de dibujarse, se desplaza hasta aquí.
    if (ref.watch(materiaEnfocadaProvider) == m.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(materiaEnfocadaProvider.notifier).limpiar();
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.05,
        );
      });
    }

    final String resumen;
    switch (m.estado) {
      case EstadoMateria.enCurso:
        final acumulado =
            todas == null ? null : acumuladoPresentado(todas, escala);
        final def = todas == null ? null : definitiva(todas, escala);
        resumen = 'Llevas ${acumulado == null ? '—' : f(acumulado)} · '
            'Definitiva ${def == null ? '—' : f(def)}';
      case EstadoMateria.aprobada || EstadoMateria.reprobada:
        final nota = m.notaFinal;
        resumen = 'Definitiva ${nota == null ? '—' : f(nota)}';
      case EstadoMateria.cancelada:
        resumen = 'Fuera del promedio';
    }

    return Opacity(
      opacity: cancelada ? 0.6 : 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onAlternar,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    BarraColor(m.color, alto: 64),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.nombre, style: tema.textTheme.titleMedium),
                          Text(
                            '${m.creditos} '
                            '${m.creditos == 1 ? 'crédito' : 'créditos'}',
                            style: tema.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(resumen, style: tema.textTheme.bodyMedium),
                          if (estado != null) ...[
                            const SizedBox(height: 6),
                            EstadoNotasChip(estado),
                          ],
                        ],
                      ),
                    ),
                    Icon(desplegada ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ),
            ),
            if (desplegada) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
                child: TablaEvaluaciones(materia: m),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
