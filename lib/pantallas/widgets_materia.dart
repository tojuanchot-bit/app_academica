import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/configuracion_escala.dart';
import '../dominio/estado_notas.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'resultado_materia.dart';

/// Colores de materia del tema (D-012).
class ColorMateria {
  const ColorMateria(this.nombre, this.valor);
  final String nombre;
  final int valor;
}

const coloresMateria = [
  ColorMateria('Violeta', 0xFF6A4BC4),
  ColorMateria('Magenta', 0xFFB03A7A),
  ColorMateria('Petróleo', 0xFF00838F),
  ColorMateria('Pizarra', 0xFF455A64),
  ColorMateria('Café', 0xFF8D5A3B),
  ColorMateria('Púrpura', 0xFF7B1FA2),
];

/// Va rotando los colores según cuántas materias hay.
int colorSugerido(int cantidadMaterias) =>
    coloresMateria[cantidadMaterias % coloresMateria.length].valor;

/// La escala guardada, o la del ITM mientras carga.
ConfiguracionEscala escalaActual(WidgetRef ref) {
  return switch (ref.watch(configuracionProvider)) {
    AsyncData(:final value) => value.escala,
    _ => ConfiguracionEscala.itm,
  };
}

/// Confirma y cierra [materia] con [nota]: aprobada o reprobada según la
/// escala. La usan el detalle de la materia y el atajo de Notas (D-024).
Future<void> cerrarMateriaCon(
  BuildContext context,
  WidgetRef ref,
  Materia materia,
  int nota,
  ConfiguracionEscala escala,
) async {
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
  await db.guardarMateria(materia.cerrar(nota, escala));
}

/// Diálogo de sí/no. Devuelve true solo si se toca [accion].
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String accion,
}) async {
  final respuesta = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Volver'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: Text(accion),
        ),
      ],
    ),
  );
  return respuesta ?? false;
}

class BarraColor extends StatelessWidget {
  const BarraColor(this.color, {super.key, this.alto = 40});

  final int color;
  final double alto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: alto,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

/// Estado con ícono y texto, nunca solo color (D-012).
class EstadoChip extends StatelessWidget {
  const EstadoChip(this.estado, {super.key});

  final EstadoMateria estado;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (icono, texto, fondo) = switch (estado) {
      EstadoMateria.enCurso => (
          Icons.play_circle_outline,
          cs.onPrimaryContainer,
          cs.primaryContainer,
        ),
      EstadoMateria.aprobada => (
          Icons.check_circle_outline,
          const Color(0xFF17663A),
          const Color(0xFFDDF3E4),
        ),
      EstadoMateria.reprobada => (
          Icons.cancel_outlined,
          const Color(0xFF8C1D18),
          const Color(0xFFFCE4E2),
        ),
      EstadoMateria.cancelada => (
          Icons.block,
          cs.onSurfaceVariant,
          cs.surfaceContainerHighest,
        ),
    };
    return _Pastilla(
        icono: icono, texto: estado.etiqueta, color: texto, fondo: fondo);
  }
}

/// Estado de notas de una materia (D-024), con ícono y texto (D-012).
class EstadoNotasChip extends StatelessWidget {
  const EstadoNotasChip(this.estado, {super.key});

  final EstadoNotas estado;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const verde = (Color(0xFF17663A), Color(0xFFDDF3E4));
    const ambar = (Color(0xFF8A5A00), Color(0xFFFFF0CC));
    const rojo = (Color(0xFF8C1D18), Color(0xFFFCE4E2));
    final (icono, (texto, fondo)) = switch (estado) {
      EstadoNotas.aprobando ||
      EstadoNotas.completa ||
      EstadoNotas.aprobada =>
        (Icons.check_circle_outline, verde),
      EstadoNotas.enRiesgo => (Icons.warning_amber_rounded, ambar),
      EstadoNotas.noAlcanza ||
      EstadoNotas.reprobada =>
        (Icons.cancel_outlined, rojo),
      EstadoNotas.sinPorcentajes => (
          Icons.pie_chart_outline,
          (cs.onSurfaceVariant, cs.surfaceContainerHighest),
        ),
      EstadoNotas.cancelada => (
          Icons.block,
          (cs.onSurfaceVariant, cs.surfaceContainerHighest),
        ),
    };
    return _Pastilla(
        icono: icono, texto: estado.etiqueta, color: texto, fondo: fondo);
  }
}

/// La forma común de los chips de estado: ícono + texto sobre un fondo.
class _Pastilla extends StatelessWidget {
  const _Pastilla({
    required this.icono,
    required this.texto,
    required this.color,
    required this.fondo,
  });

  final IconData icono;
  final String texto;
  final Color color;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Fila de una materia en la lista del semestre.
class MateriaTile extends ConsumerWidget {
  const MateriaTile({super.key, required this.materia, required this.onTap});

  final Materia materia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escala = escalaActual(ref);
    final detalles = [
      if (materia.docente.isNotEmpty) materia.docente,
      '${materia.creditos} ${materia.creditos == 1 ? 'crédito' : 'créditos'}',
    ].join(' · ');
    final enCurso = materia.estado == EstadoMateria.enCurso;
    final calculada = enCurso ? definitivaDe(ref, materia) : null;
    final nota = enCurso ? calculada : materia.notaFinal;

    final Widget derecha;
    if ((materia.estado.estaCerrada || enCurso) && nota != null) {
      derecha = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            escala.formatear(nota),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            enCurso ? 'definitiva' : materia.estado.etiqueta,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      );
    } else if (materia.estado == EstadoMateria.cancelada) {
      derecha = EstadoChip(materia.estado);
    } else {
      derecha = const Icon(Icons.chevron_right);
    }

    return Opacity(
      opacity: materia.estado == EstadoMateria.cancelada ? 0.6 : 1,
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: BarraColor(materia.color),
          title: Text(materia.nombre),
          subtitle: Text(detalles),
          trailing: derecha,
        ),
      ),
    );
  }
}
