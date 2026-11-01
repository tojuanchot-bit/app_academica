import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/evaluacion.dart';
import '../dominio/formato_fecha.dart';
import '../dominio/redondeo.dart';
import '../estado/providers.dart';
import 'widgets_materia.dart';

/// Crear o editar una evaluación. Con [padre] es una sub-evaluación.
class EvaluacionFormPage extends ConsumerStatefulWidget {
  const EvaluacionFormPage({
    super.key,
    required this.materiaId,
    this.padre,
    this.existente,
  });

  final int materiaId;
  final Evaluacion? padre;
  final Evaluacion? existente;

  @override
  ConsumerState<EvaluacionFormPage> createState() =>
      _EvaluacionFormPageState();
}

class _EvaluacionFormPageState extends ConsumerState<EvaluacionFormPage> {
  late final TextEditingController _nombre;
  late final TextEditingController _porcentaje;
  late final TextEditingController _nota;
  DateTime? _fecha;
  bool _guardando = false;

  bool get _esHija => widget.padre != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    final escala = ref.read(configuracionProvider).value?.escala;
    final porcentaje = e?.porcentaje;
    final nota = e?.nota;
    _nombre = TextEditingController(text: e?.nombre ?? '');
    _porcentaje = TextEditingController(
      text: porcentaje == null ? '' : formatearCentesimas(porcentaje, 2)
          .replaceAll(RegExp(r'\.?0+$'), ''),
    );
    _nota = TextEditingController(
      text: nota == null
          ? ''
          : (escala?.formatear(nota) ?? formatearCentesimas(nota, 2)),
    );
    _fecha = e?.fecha;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _porcentaje.dispose();
    _nota.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  Future<void> _guardar(Evaluacion e) async {
    setState(() => _guardando = true);
    try {
      await ref.read(baseDatosProvider).guardarEvaluacion(e);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (err) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $err')),
      );
    }
  }

  Future<void> _eliminar(Evaluacion e, int cantidadHijas) async {
    final db = ref.read(baseDatosProvider);
    final navegador = Navigator.of(context);
    final ok = await confirmar(
      context,
      titulo: '¿Eliminar ${e.nombre}?',
      mensaje: cantidadHijas == 0
          ? 'No se puede deshacer.'
          : 'También se borran sus $cantidadHijas sub-evaluaciones. '
              'No se puede deshacer.',
      accion: 'Eliminar',
    );
    if (!ok) return;
    navegador.pop();
    await db.eliminarEvaluacion(e.id!);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final escala = escalaActual(ref);
    final todas = switch (ref.watch(evaluacionesProvider(widget.materiaId))) {
      AsyncData(:final value) => value,
      _ => const <Evaluacion>[],
    };
    final existente = widget.existente;
    final padre = widget.padre;
    final hermanas = padre == null ? primerNivel(todas) : hijasDe(todas, padre.id!);
    final hijas = existente?.id == null
        ? const <Evaluacion>[]
        : hijasDe(todas, existente!.id!);
    final esCompuesta = hijas.isNotEmpty;

    // Porcentaje: vacío es válido solo en sub-evaluaciones.
    final textoPorcentaje = _porcentaje.text.trim();
    final porcentaje =
        textoPorcentaje.isEmpty ? null : parsearCentesimas(textoPorcentaje);
    final porcentajeIlegible = textoPorcentaje.isNotEmpty && porcentaje == null;

    // Nota: opcional; no aplica a una compuesta.
    final textoNota = _nota.text.trim();
    final nota = (esCompuesta || textoNota.isEmpty)
        ? null
        : parsearCentesimas(textoNota);
    String? errorNota;
    if (!esCompuesta && textoNota.isNotEmpty) {
      errorNota = nota == null
          ? 'Escribe un número, por ejemplo 3.5'
          : escala.errorNota(nota);
    }

    final evaluacion = Evaluacion(
      id: existente?.id,
      materiaId: widget.materiaId,
      padreId: padre?.id,
      nombre: _nombre.text.trim(),
      porcentaje: porcentaje,
      nota: nota,
      fecha: _fecha,
      // Al registrar la nota real, la supuesta ya no sirve (fase 2b).
      notaSupuesta: nota == null ? existente?.notaSupuesta : null,
    );
    final errores = validarEvaluacion(evaluacion, hermanas: hermanas);

    String? errorPorcentaje;
    if (porcentajeIlegible) {
      errorPorcentaje = 'Escribe un número, por ejemplo 30';
    } else if (textoPorcentaje.isNotEmpty) {
      for (final err in errores) {
        if (err != ErrorEvaluacion.nombreVacio) errorPorcentaje = err.mensaje;
      }
    }
    final usado = sumaPorcentajes(
        hermanas.where((h) => existente == null || h.id != existente.id));
    final disponible = porcentajeCompleto - usado;

    final puedeGuardar = errores.isEmpty &&
        !porcentajeIlegible &&
        errorNota == null &&
        !_guardando;

    void alCambiar(String _) => setState(() {});

    final titulo = existente != null
        ? 'Editar evaluación'
        : (_esHija ? 'Nueva sub-evaluación' : 'Nueva evaluación');

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          if (existente != null)
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _eliminar(existente, hijas.length),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: puedeGuardar ? () => _guardar(evaluacion) : null,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (padre != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('Dentro de: ${padre.nombre}',
                    style: tema.textTheme.titleSmall),
              ),
            TextField(
              controller: _nombre,
              autofocus: existente == null,
              onChanged: alCambiar,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: _esHija ? 'Quiz 1' : 'Parcial 1',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _porcentaje,
              onChanged: alCambiar,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _esHija
                    ? 'Porcentaje dentro de ${padre!.nombre} (opcional)'
                    : 'Porcentaje de la materia',
                suffixText: '%',
                border: const OutlineInputBorder(),
                helperText: _esHija
                    ? 'Vacío = partes iguales con las demás'
                    : 'Disponible: ${formatearPorcentaje(disponible)}',
                errorText: errorPorcentaje,
              ),
            ),
            const SizedBox(height: 12),
            if (esCompuesta)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calculate_outlined),
                  title: const Text('Nota calculada'),
                  subtitle: Text(
                    'Se calcula con sus ${hijas.length} sub-evaluaciones.',
                  ),
                ),
              )
            else
              TextField(
                controller: _nota,
                onChanged: alCambiar,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Nota (opcional)',
                  border: const OutlineInputBorder(),
                  helperText: 'Déjala vacía si aún no la has presentado. '
                      'Entre ${escala.formatear(escala.notaMinima)} '
                      'y ${escala.formatear(escala.notaMaxima)}.',
                  errorText: errorNota,
                ),
              ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: const Text('Fecha (opcional)'),
              subtitle:
                  Text(_fecha == null ? 'Sin definir' : formatearFecha(_fecha!)),
              onTap: _elegirFecha,
              trailing: _fecha == null
                  ? null
                  : IconButton(
                      tooltip: 'Quitar fecha',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _fecha = null),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
