import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/bloque_horario.dart';
import '../dominio/horario.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'clase_campos.dart';
import 'widgets_materia.dart';

/// Crear una materia en un semestre con su horario, o editar ambos.
/// Cada clase tiene su propio día, hora y salón.
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

  /// Clases del formulario, aún sin guardar. Al editar, empiezan con las
  /// guardadas (con su id); las nuevas no tienen id.
  List<BloqueHorario> _clases = const [];

  /// Al editar hay que esperar a leer las clases guardadas; guardar antes
  /// borraría el horario.
  late bool _clasesCargadas;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _nombre = TextEditingController(text: e?.nombre ?? '');
    _docente = TextEditingController(text: e?.docente ?? '');
    _creditos = TextEditingController(text: e?.creditos.toString() ?? '');
    _color = e?.color ?? widget.colorInicial;
    _clasesCargadas = e == null;
    if (e != null) _cargarClases(e.id!);
  }

  Future<void> _cargarClases(int materiaId) async {
    final guardadas = await ref
        .read(baseDatosProvider)
        .observarBloquesDeMateria(materiaId)
        .first;
    if (!mounted) return;
    setState(() {
      _clases = ordenarBloques(guardadas);
      _clasesCargadas = true;
    });
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

  Future<void> _agregarClases() async {
    final nuevas = await pedirClases(context);
    if (nuevas == null || !mounted) return;
    setState(() => _clases = ordenarBloques([..._clases, ...nuevas]));
  }

  Future<void> _editarClase(int indice) async {
    final editada = await pedirClases(context, inicial: _clases[indice]);
    if (editada == null || !mounted) return;
    setState(() {
      final copia = [..._clases]..[indice] = editada.single;
      _clases = ordenarBloques(copia);
    });
  }

  void _quitarClase(int indice) {
    setState(() => _clases = [..._clases]..removeAt(indice));
  }

  Future<void> _guardar(Materia materia, List<String> choques) async {
    if (choques.isNotEmpty && !await confirmarChoques(context, choques)) {
      return;
    }
    if (!mounted) return;
    setState(() => _guardando = true);
    try {
      await ref
          .read(baseDatosProvider)
          .guardarMateriaConHorario(materia, _clases);
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
    final puedeGuardar = lista != null && _clasesCargadas && !_guardando;

    String? errorCreditos;
    if (_creditos.text.trim().isNotEmpty && materia == null) {
      errorCreditos = 'Escribe un número entero.';
    } else if (errores.contains(ErrorMateria.creditosFueraDeRango)) {
      errorCreditos = ErrorMateria.creditosFueraDeRango.mensaje;
    }

    // Choques: contra las clases visibles de las demás materias del
    // semestre y entre las clases de esta misma materia.
    final materias =
        switch (ref.watch(materiasProvider(widget.semestreId))) {
      AsyncData(:final value) => value,
      _ => const <Materia>[],
    };
    final bloques =
        switch (ref.watch(bloquesSemestreProvider(widget.semestreId))) {
      AsyncData(:final value) => value,
      _ => const <BloqueHorario>[],
    };
    final idPropia = widget.existente?.id;
    final otras = [
      for (final c in clasesVisibles(bloques, materias))
        if (c.materia.id != idPropia) c.bloque,
    ];
    final nombres = {
      for (final m in materias)
        if (m.id != null && m.id != idPropia) m.id!: m.nombre,
    };
    final choquesPorFila = choquesPorClase(_clases, otras);
    final choques = {
      for (var i = 0; i < _clases.length; i++)
        for (final b in choquesPorFila[i])
          '${nombreDiaCorto(_clases[i].dia)} ${_clases[i].rango} con '
              '${describirBloque(b, nombres)}',
    }.toList();

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
                  puedeGuardar ? () => _guardar(lista, choques) : null,
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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text('Horario', style: tema.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: _clasesCargadas ? _agregarClases : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar clase'),
                ),
              ],
            ),
            if (!_clasesCargadas)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_clases.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Agrega una clase por cada día, hora y salón; por ejemplo, '
                  'lunes 7:00 – 9:00 en B-201 y miércoles 9:00 – 11:00 en '
                  'L-3. Si es virtual o no tiene horario, déjalo vacío.',
                  style: tema.textTheme.bodySmall,
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (var i = 0; i < _clases.length; i++)
                      ListTile(
                        onTap: () => _editarClase(i),
                        leading: choquesPorFila[i].isEmpty
                            ? const Icon(Icons.schedule)
                            : const Tooltip(
                                message: 'Se cruza con otra clase',
                                child: Icon(Icons.warning_amber_rounded,
                                    color: colorAviso),
                              ),
                        title: Text(
                            '${nombreDia(_clases[i].dia)} · ${_clases[i].rango}'),
                        subtitle: _clases[i].salon.isEmpty
                            ? null
                            : Text('Salón ${_clases[i].salon}'),
                        trailing: IconButton(
                          tooltip: 'Quitar clase',
                          onPressed: () => _quitarClase(i),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                  ],
                ),
              ),
            if (choques.isNotEmpty) ...[
              const SizedBox(height: 8),
              AvisoChoque(
                lineas: choques,
                pie: 'Puedes guardar igual si es a propósito.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
