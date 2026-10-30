import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'widgets_materia.dart';

/// Crear una materia en un semestre, o editar sus datos.
class MateriaFormPage extends ConsumerStatefulWidget {
  const MateriaFormPage({
    super.key,
    required this.semestreId,
    this.existente,
    this.colorInicial = 0xFF6A4BC4,
  });

  final int semestreId;
  final Materia? existente;
  final int colorInicial;

  @override
  ConsumerState<MateriaFormPage> createState() => _MateriaFormPageState();
}

class _MateriaFormPageState extends ConsumerState<MateriaFormPage> {
  late final TextEditingController _nombre;
  late final TextEditingController _docente;
  late final TextEditingController _creditos;
  late int _color;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _nombre = TextEditingController(text: e?.nombre ?? '');
    _docente = TextEditingController(text: e?.docente ?? '');
    _creditos = TextEditingController(text: e?.creditos.toString() ?? '');
    _color = e?.color ?? widget.colorInicial;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _docente.dispose();
    _creditos.dispose();
    super.dispose();
  }

  /// La materia tal como está escrita; null si los créditos no son un número.
  Materia? _materiaEscrita() {
    final creditos = int.tryParse(_creditos.text.trim());
    if (creditos == null) return null;
    final nombre = _nombre.text.trim();
    final docente = _docente.text.trim();
    final e = widget.existente;
    if (e != null) {
      return e.copyWith(
        nombre: nombre,
        docente: docente,
        creditos: creditos,
        color: _color,
      );
    }
    return Materia(
      semestreId: widget.semestreId,
      nombre: nombre,
      docente: docente,
      creditos: creditos,
      color: _color,
    );
  }

  Future<void> _guardar(Materia materia) async {
    setState(() => _guardando = true);
    try {
      await ref.read(baseDatosProvider).guardarMateria(materia);
      if (!mounted) return;
      Navigator.of(context).pop();
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
    final materia = _materiaEscrita();
    final errores = materia?.validar() ?? const <ErrorMateria>{};
    final lista = (materia != null && errores.isEmpty) ? materia : null;
    final puedeGuardar = lista != null && !_guardando;

    String? errorCreditos;
    if (_creditos.text.trim().isNotEmpty && materia == null) {
      errorCreditos = 'Escribe un número entero.';
    } else if (errores.contains(ErrorMateria.creditosFueraDeRango)) {
      errorCreditos = ErrorMateria.creditosFueraDeRango.mensaje;
    }

    void alCambiar(String _) => setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existente == null ? 'Nueva materia' : 'Editar materia'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed:
                  puedeGuardar ? () => _guardar(lista) : null,
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
              onChanged: alCambiar,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Cálculo Integral',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _docente,
              onChanged: alCambiar,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Docente (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _creditos,
              onChanged: alCambiar,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Créditos',
                border: const OutlineInputBorder(),
                errorText: errorCreditos,
              ),
            ),
            const SizedBox(height: 20),
            Text('Color', style: tema.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final c in coloresMateria)
                  Tooltip(
                    message: c.nombre,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => setState(() => _color = c.valor),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(c.valor),
                          shape: BoxShape.circle,
                          border: _color == c.valor
                              ? Border.all(
                                  color: tema.colorScheme.onSurface,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: _color == c.valor
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
