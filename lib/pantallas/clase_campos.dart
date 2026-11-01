import 'package:flutter/material.dart';

import '../dominio/bloque_horario.dart';
import '../dominio/horario.dart';

/// Texto y fondo "en riesgo" (D-012), usados para los choques de horario.
const colorAviso = Color(0xFF8A5A00);
const fondoAviso = Color(0xFFFFF0CC);

/// Campos de una clase: día(s), hora de inicio y fin con el reloj, y salón.
/// Es controlado: el estado lo guarda quien lo usa.
class ClaseCampos extends StatelessWidget {
  const ClaseCampos({
    super.key,
    required this.dias,
    required this.variosDias,
    required this.onDias,
    required this.inicio,
    required this.fin,
    required this.onHoras,
    required this.salon,
    this.onSalon,
  });

  final Set<int> dias;

  /// Al crear se pueden marcar varios días; al editar, uno solo.
  final bool variosDias;
  final ValueChanged<Set<int>> onDias;
  final int inicio;
  final int fin;
  final void Function(int inicio, int fin) onHoras;
  final TextEditingController salon;
  final ValueChanged<String>? onSalon;

  /// Abre el reloj. Al cambiar el inicio, el fin se mueve con él y conserva
  /// la duración (una clase de 2 horas sigue siendo de 2 horas).
  Future<void> _elegirHora(BuildContext context, {required bool esInicio}) async {
    final actual = esInicio ? inicio : fin;
    final elegida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (actual ~/ 60) % 24, minute: actual % 60),
      helpText: esInicio ? 'Hora de inicio' : 'Hora de fin',
    );
    if (elegida == null) return;
    final minutos = elegida.hour * 60 + elegida.minute;
    if (esInicio) {
      final duracion = fin > inicio ? fin - inicio : 120;
      final nuevoFin = minutos + duracion;
      onHoras(minutos, nuevoFin > minutosPorDia ? minutosPorDia : nuevoFin);
    } else {
      onHoras(inicio, minutos);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final finMal = fin <= inicio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(variosDias ? 'Días (puedes marcar varios)' : 'Día',
            style: tema.textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var d = 1; d <= 7; d++)
              FilterChip(
                label: Text(nombreDiaCorto(d)),
                showCheckmark: false,
                selected: dias.contains(d),
                onSelected: (marcado) {
                  if (!variosDias) {
                    onDias({d});
                  } else if (marcado) {
                    onDias({...dias, d});
                  } else {
                    onDias({...dias}..remove(d));
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _CampoHora(
                etiqueta: 'Inicio',
                minutos: inicio,
                onTap: () => _elegirHora(context, esInicio: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CampoHora(
                etiqueta: 'Fin',
                minutos: fin,
                error: finMal,
                onTap: () => _elegirHora(context, esInicio: false),
              ),
            ),
          ],
        ),
        if (finMal)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              ErrorBloque.finNoPosterior.mensaje,
              style: TextStyle(color: tema.colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: salon,
          onChanged: onSalon,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Salón (opcional)',
            hintText: 'B-201',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _CampoHora extends StatelessWidget {
  const _CampoHora({
    required this.etiqueta,
    required this.minutos,
    required this.onTap,
    this.error = false,
  });

  final String etiqueta;
  final int minutos;
  final VoidCallback onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
          enabledBorder: error
              ? OutlineInputBorder(borderSide: BorderSide(color: cs.error))
              : null,
          suffixIcon: const Icon(Icons.schedule),
        ),
        child: Text(
          formatearHora(minutos),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

/// Tarjeta ámbar con la lista de choques. Solo advierte (D-021).
class AvisoChoque extends StatelessWidget {
  const AvisoChoque({super.key, required this.lineas, this.pie});

  final List<String> lineas;
  final String? pie;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fondoAviso,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: colorAviso),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                [
                  'Se cruza con:',
                  ...lineas,
                  ?pie,
                ].join('\n'),
                style: const TextStyle(color: colorAviso),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Cálculo Integral (Lun 10:00 – 12:00)"
String describirBloque(BloqueHorario b, Map<int, String> nombres) =>
    '${nombres[b.materiaId] ?? 'Otra clase de esta materia'} '
    '(${nombreDiaCorto(b.dia)} ${b.rango})';

/// Pregunta antes de guardar si hay choques. true = guardar.
Future<bool> confirmarChoques(
  BuildContext context,
  List<String> lineas,
) async {
  final seguir = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: colorAviso),
      title: const Text('Hay clases que se cruzan'),
      content: Text([for (final l in lineas) '• $l'].join('\n')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Revisar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Guardar de todos modos'),
        ),
      ],
    ),
  );
  return seguir ?? false;
}

/// Ventana para agregar (uno o varios días) o editar (un día) una clase de
/// una materia que aún no se guarda. Devuelve las clases resultantes, o
/// null si se cierra sin aceptar. Las clases devueltas conservan el id de
/// [inicial] al editar.
Future<List<BloqueHorario>?> pedirClases(
  BuildContext context, {
  BloqueHorario? inicial,
}) {
  return showDialog<List<BloqueHorario>>(
    context: context,
    builder: (_) => _DialogoClase(inicial: inicial),
  );
}

class _DialogoClase extends StatefulWidget {
  const _DialogoClase({this.inicial});

  final BloqueHorario? inicial;

  @override
  State<_DialogoClase> createState() => _DialogoClaseState();
}

class _DialogoClaseState extends State<_DialogoClase> {
  late Set<int> _dias;
  late int _inicio;
  late int _fin;
  late final TextEditingController _salon;

  @override
  void initState() {
    super.initState();
    final i = widget.inicial;
    _dias = i == null ? <int>{} : {i.dia};
    _inicio = i?.inicio ?? 7 * 60;
    _fin = i?.fin ?? 9 * 60;
    _salon = TextEditingController(text: i?.salon ?? '');
  }

  @override
  void dispose() {
    _salon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inicial = widget.inicial;
    final modelo = BloqueHorario(
      id: inicial?.id,
      materiaId: inicial?.materiaId ?? 0,
      dia: _dias.isEmpty ? 1 : _dias.first,
      inicio: _inicio,
      fin: _fin,
      salon: _salon.text.trim(),
    );
    final valido = _dias.isNotEmpty && modelo.esValido;

    return AlertDialog(
      title: Text(inicial == null ? 'Agregar clase' : 'Editar clase'),
      content: SingleChildScrollView(
        child: ClaseCampos(
          dias: _dias,
          variosDias: inicial == null,
          onDias: (d) => setState(() => _dias = d),
          inicio: _inicio,
          fin: _fin,
          onHoras: (i, f) => setState(() {
            _inicio = i;
            _fin = f;
          }),
          salon: _salon,
          onSalon: (_) => setState(() {}),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Volver'),
        ),
        FilledButton(
          onPressed: !valido
              ? null
              : () => Navigator.pop(
                    context,
                    inicial == null ? clasesEnDias(modelo, _dias) : [modelo],
                  ),
          child: Text(inicial == null && _dias.length > 1
              ? 'Agregar ${_dias.length}'
              : 'Aceptar'),
        ),
      ],
    );
  }
}
