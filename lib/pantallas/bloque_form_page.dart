import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/bloque_horario.dart';
import '../dominio/horario.dart';
import '../dominio/materia.dart';
import '../estado/providers.dart';
import 'clase_campos.dart';
import 'widgets_materia.dart';

/// Agregar clases a una materia ya creada (desde la pestaña Horario o el
/// detalle) o editar una. Al agregar se pueden marcar varios días.
/// Los errores de datos no dejan guardar; los choques solo advierten (D-021).
class BloqueFormPage extends ConsumerStatefulWidget {
  const BloqueFormPage({
    super.key,
    required this.semestreId,
    this.existente,
    this.materiaInicial,
    this.diaInicial,
  });

  final int semestreId;
  final BloqueHorario? existente;
  final int? materiaInicial;
  final int? diaInicial;

  @override
  ConsumerState<BloqueFormPage> createState() => _BloqueFormPageState();
}

class _BloqueFormPageState extends ConsumerState<BloqueFormPage> {
  int? _materiaId;
  late Set<int> _dias;
  late int _inicio;
  late int _fin;
  late final TextEditingController _salon;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _materiaId = e?.materiaId ?? widget.materiaInicial;
    final dia = e?.dia ?? widget.diaInicial;
    _dias = dia == null ? <int>{} : {dia};
    _inicio = e?.inicio ?? 7 * 60;
    _fin = e?.fin ?? 9 * 60;
    _salon = TextEditingController(text: e?.salon ?? '');
  }

  @override
  void dispose() {
    _salon.dispose();
    super.dispose();
  }

  Future<void> _guardar(
    List<BloqueHorario> nuevas,
    List<String> choques,
  ) async {
    if (choques.isNotEmpty && !await confirmarChoques(context, choques)) {
      return;
    }
    if (!mounted) return;
    setState(() => _guardando = true);
    try {
      await ref.read(baseDatosProvider).guardarBloques(nuevas);
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

  Future<void> _eliminar(BloqueHorario bloque) async {
    final db = ref.read(baseDatosProvider);
    final navegador = Navigator.of(context);
    final ok = await confirmar(
      context,
      titulo: '¿Eliminar esta clase?',
      mensaje: '${nombreDia(bloque.dia)} ${bloque.rango}. '
          'No se puede deshacer.',
      accion: 'Eliminar',
    );
    if (!ok) return;
    navegador.pop();
    await db.eliminarBloque(bloque.id!);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final materias = switch (ref.watch(materiasProvider(widget.semestreId))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final bloques =
        switch (ref.watch(bloquesSemestreProvider(widget.semestreId))) {
      AsyncData(:final value) => value,
      _ => const <BloqueHorario>[],
    };
    final todas = materias ?? const <Materia>[];
    final enCurso = todas.where(apareceEnHorario).toList();
    final nombres = {
      for (final m in todas)
        if (m.id != null) m.id!: m.nombre,
    };

    // Si hay una sola materia en curso, queda elegida.
    var materiaId =
        _materiaId ?? (enCurso.length == 1 ? enCurso.first.id : null);
    if (materiaId != null && !enCurso.any((m) => m.id == materiaId)) {
      materiaId = null;
    }

    final existente = widget.existente;
    final modelo = BloqueHorario(
      id: existente?.id,
      materiaId: materiaId ?? 0,
      dia: _dias.isEmpty ? 1 : _dias.first,
      inicio: _inicio,
      fin: _fin,
      salon: _salon.text.trim(),
    );
    final nuevas = existente == null ? clasesEnDias(modelo, _dias) : [modelo];
    final valido = materiaId != null && _dias.isNotEmpty && modelo.esValido;

    // Se compara con todo lo visible del semestre, menos la clase que se
    // está editando.
    final otras = [
      for (final c in clasesVisibles(bloques, todas))
        if (existente == null || c.bloque.id != existente.id) c.bloque,
    ];
    final choques = valido
        ? {
            for (final lista in choquesPorClase(nuevas, otras))
              for (final b in lista) describirBloque(b, nombres),
          }.toList()
        : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(existente == null ? 'Agregar clases' : 'Editar clase'),
        actions: [
          if (existente != null)
            IconButton(
              tooltip: 'Eliminar clase',
              onPressed: () => _eliminar(existente),
              icon: const Icon(Icons.delete_outline),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: valido && !_guardando
                  ? () => _guardar(nuevas, choques)
                  : null,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: materias == null
            ? const Center(child: CircularProgressIndicator())
            : enCurso.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Este semestre no tiene materias en curso.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Materia',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: materiaId,
                            isExpanded: true,
                            hint: const Text('Elige la materia'),
                            items: [
                              for (final m in enCurso)
                                DropdownMenuItem(
                                  value: m.id,
                                  child: Row(
                                    children: [
                                      BarraColor(m.color, alto: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(m.nombre,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (v) => setState(() => _materiaId = v),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClaseCampos(
                        dias: _dias,
                        variosDias: existente == null,
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
                      if (existente == null && _dias.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'Se crearán ${_dias.length} clases, una por día. '
                            'Después puedes cambiar cada una por separado.',
                            style: tema.textTheme.bodySmall,
                          ),
                        ),
                      if (choques.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        AvisoChoque(
                          lineas: choques,
                          pie: 'Puedes guardarla igual.',
                        ),
                      ],
                    ],
                  ),
      ),
    );
  }
}
