import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/formato_fecha.dart';
import '../dominio/semestre.dart';
import '../estado/providers.dart';

/// Crear o editar un semestre. Al guardar devuelve su id con Navigator.pop.
class SemestreFormPage extends ConsumerStatefulWidget {
  const SemestreFormPage({super.key, this.existente});

  final Semestre? existente;

  @override
  ConsumerState<SemestreFormPage> createState() => _SemestreFormPageState();
}

class _SemestreFormPageState extends ConsumerState<SemestreFormPage> {
  late final TextEditingController _nombre;
  DateTime? _inicio;
  DateTime? _fin;
  late bool _activo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _nombre = TextEditingController(text: e?.nombre ?? '');
    _inicio = e?.fechaInicio;
    _fin = e?.fechaFin;
    _activo = e?.activo ?? true;
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha({required bool esInicio}) async {
    final actual = esInicio ? _inicio : _fin;
    final elegida = await showDatePicker(
      context: context,
      initialDate: actual ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (elegida == null) return;
    setState(() {
      if (esInicio) {
        _inicio = elegida;
      } else {
        _fin = elegida;
      }
    });
  }

  Future<void> _guardar(Semestre semestre) async {
    setState(() => _guardando = true);
    try {
      final id = await ref.read(baseDatosProvider).guardarSemestre(semestre);
      if (!mounted) return;
      Navigator.of(context).pop(id);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final semestre = Semestre(
      id: widget.existente?.id,
      nombre: _nombre.text.trim(),
      fechaInicio: _inicio,
      fechaFin: _fin,
      activo: _activo,
    );
    final errores = semestre.validar();
    final puedeGuardar = errores.isEmpty && !_guardando;

    Widget campoFecha(String titulo, DateTime? valor, bool esInicio) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.event_outlined),
        title: Text(titulo),
        subtitle: Text(valor == null ? 'Sin definir' : formatearFecha(valor)),
        onTap: () => _elegirFecha(esInicio: esInicio),
        trailing: valor == null
            ? null
            : IconButton(
                tooltip: 'Quitar fecha',
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  if (esInicio) {
                    _inicio = null;
                  } else {
                    _fin = null;
                  }
                }),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existente == null ? 'Nuevo semestre' : 'Editar semestre'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: puedeGuardar ? () => _guardar(semestre) : null,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _nombre,
              autofocus: widget.existente == null,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: '2026-2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            campoFecha('Fecha de inicio', _inicio, true),
            campoFecha('Fecha de fin', _fin, false),
            if (errores.contains(ErrorSemestre.finAntesDeInicio))
              Text(
                ErrorSemestre.finAntesDeInicio.mensaje,
                style: TextStyle(color: tema.colorScheme.error),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Semestre activo'),
              subtitle: const Text(
                'Es el que se muestra por defecto. Solo puede haber uno.',
              ),
              value: _activo,
              onChanged: (v) => setState(() => _activo = v),
            ),
          ],
        ),
      ),
    );
  }
}
