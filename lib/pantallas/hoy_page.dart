import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/calculo_notas.dart';
import '../dominio/formato_fecha.dart';
import '../dominio/horario.dart';
import '../dominio/materia.dart';
import '../dominio/perfil.dart';
import '../estado/horario_provider.dart';
import '../estado/providers.dart';
import 'configuracion_page.dart';
import 'horario_page.dart';
import 'materia_detalle_page.dart';
import 'proyectar_notas_page.dart';
import 'resultado_materia.dart';
import 'widgets_materia.dart';

/// Pantalla Hoy. Saludo, promedio acumulado, alertas y clases de hoy son
/// reales; avance de carrera (Fase 5) y pendientes (Fase 4) siguen con
/// datos fijos hasta sus fases.
class HoyPage extends ConsumerWidget {
  const HoyPage({super.key});

  void _abrirConfiguracion(BuildContext context, ConfiguracionUsuario actual) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConfiguracionPage(inicial: actual),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final config = switch (ref.watch(configuracionProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final nombre = config?.perfil.nombre ?? '';
    final saludo = nombre.isEmpty ? 'Hola' : 'Hola, $nombre';
    final activo = switch (ref.watch(semestresProvider)) {
      AsyncData(:final value) => value.where((s) => s.activo).firstOrNull,
      _ => null,
    };
    final hoy = formatearFechaLarga(DateTime.now());
    final subtitulo =
        activo == null ? 'Sin semestre activo · $hoy' : 'Periodo ${activo.nombre} · $hoy';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(saludo, style: tema.textTheme.headlineSmall),
                  Text(subtitulo, style: tema.textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Configuración',
              onPressed: config == null
                  ? null
                  : () => _abrirConfiguracion(context, config),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        if (config != null && !config.perfil.esValido) ...[
          const SizedBox(height: 12),
          Card(
            color: tema.colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Configura tu perfil'),
              subtitle: const Text('Tu nombre y la escala de notas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _abrirConfiguracion(context, config),
            ),
          ),
        ],
        const SizedBox(height: 16),
        const _TarjetaPromedio(),
        const SizedBox(height: 12),
        const _TarjetaAvance(aprobados: 32, total: 92, nivel: 3),
        const SizedBox(height: 12),
        if (activo?.id case final idActivo?) _Alertas(semestreId: idActivo),
        const SizedBox(height: 20),
        Text('Clases de hoy', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        const _ClasesDeHoy(),
        const SizedBox(height: 20),
        Text('Pendientes', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: Icon(Icons.radio_button_unchecked),
            title: Text('Entrega taller de Física'),
            subtitle: Text('Mañana · Física Mecánica'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.radio_button_unchecked),
            title: Text('Parcial de Cálculo Integral'),
            subtitle: Text('Viernes · Cálculo Integral'),
          ),
        ),
      ],
    );
  }
}

class _TarjetaAvance extends StatelessWidget {
  const _TarjetaAvance({
    required this.aprobados,
    required this.total,
    required this.nivel,
  });

  final int aprobados;
  final int total;
  final int nivel;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Avance de carrera', style: tema.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('Nivel $nivel', style: tema.textTheme.headlineMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: aprobados / total,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('$aprobados de $total créditos aprobados'),
          ],
        ),
      ),
    );
  }
}

/// Promedio acumulado de todos los semestres (D-014).
class _TarjetaPromedio extends ConsumerWidget {
  const _TarjetaPromedio();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    final materias = switch (ref.watch(todasLasMateriasProvider)) {
      AsyncData(:final value) => value,
      _ => const <Materia>[],
    };
    final promedio = promedioPonderado(materias, escala);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.insights_outlined),
        title: const Text('Promedio acumulado'),
        subtitle: Text(promedio == null
            ? 'Aparece cuando cierres tu primera materia'
            : 'Sobre las materias aprobadas y reprobadas'),
        trailing: promedio == null
            ? null
            : Text(escala.formatear(promedio),
                style: tema.textTheme.headlineSmall),
      ),
    );
  }
}

/// Alertas de las materias en curso del semestre activo que están en
/// riesgo o ya no alcanzan para aprobar.
class _Alertas extends ConsumerWidget {
  const _Alertas({required this.semestreId});

  final int semestreId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materias = switch (ref.watch(materiasProvider(semestreId))) {
      AsyncData(:final value) => value,
      _ => const <Materia>[],
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final m in materias)
          if (m.estado == EstadoMateria.enCurso)
            AlertaMateria(
              materia: m,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProyectarNotasPage(
                    semestreId: semestreId,
                    preelegidas: {m.id!},
                    directo: true,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

/// Las clases de hoy según el horario del semestre activo. Las que ya
/// pasaron van en gris; la que está en curso (o la siguiente) va resaltada.
/// Se actualiza sola con [relojProvider].
class _ClasesDeHoy extends ConsumerWidget {
  const _ClasesDeHoy();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final ahora = switch (ref.watch(relojProvider)) {
      AsyncData(:final value) => value,
      _ => DateTime.now(),
    };
    final datos = switch (ref.watch(horarioActivoProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (datos == null) {
      return Text('Activa un semestre en Materias para ver tus clases.',
          style: tema.textTheme.bodySmall);
    }

    final clases = clasesDeHoy(datos.bloques, datos.materias, ahora);
    if (clases.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.free_breakfast_outlined),
          title: Text('Hoy no tienes clases'),
        ),
      );
    }
    final conChoque = idsConChoque([
      for (final c in clasesVisibles(datos.bloques, datos.materias)) c.bloque,
    ]);
    final hayEnCurso = clases.any((c) => c.momento == MomentoClase.ahora);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in clases)
          ClaseTile(
            clase: c.clase,
            conChoque: conChoque.contains(c.clase.bloque.id),
            atenuada: c.momento == MomentoClase.pasada,
            // Se resalta la que está en curso; si no hay, la siguiente.
            resaltada: c.momento == MomentoClase.ahora ||
                (!hayEnCurso && c.momento == MomentoClase.siguiente),
            etiqueta: switch (c.momento) {
              MomentoClase.pasada => null,
              MomentoClase.ahora => 'Ahora',
              MomentoClase.siguiente ||
              MomentoClase.despues =>
                formatearFaltan(c.faltan!),
            },
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    MateriaDetallePage(materiaId: c.clase.materia.id!),
              ),
            ),
          ),
      ],
    );
  }
}
