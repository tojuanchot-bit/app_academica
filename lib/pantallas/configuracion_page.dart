import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/configuracion_escala.dart';
import '../dominio/perfil.dart';
import '../dominio/redondeo.dart';
import '../estado/providers.dart';

/// Perfil y escala de notas. Se abre desde el ícono de ajustes de Hoy.
class ConfiguracionPage extends ConsumerStatefulWidget {
  const ConfiguracionPage({super.key, required this.inicial});

  final ConfiguracionUsuario inicial;

  @override
  ConsumerState<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends ConsumerState<ConfiguracionPage> {
  late final TextEditingController _nombre;
  late final TextEditingController _institucion;
  late final TextEditingController _programa;
  late final TextEditingController _minima;
  late final TextEditingController _maxima;
  late final TextEditingController _aprobatoria;
  late int _decimales;
  late ModoRedondeo _modo;
  late bool _intermedias;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final perfil = widget.inicial.perfil;
    final escala = widget.inicial.escala;
    _nombre = TextEditingController(text: perfil.nombre);
    _institucion = TextEditingController(text: perfil.institucion);
    _programa = TextEditingController(text: perfil.programa);
    _minima = TextEditingController(text: escala.formatear(escala.notaMinima));
    _maxima = TextEditingController(text: escala.formatear(escala.notaMaxima));
    _aprobatoria =
        TextEditingController(text: escala.formatear(escala.notaAprobatoria));
    _decimales = escala.decimales;
    _modo = escala.modo;
    _intermedias = escala.redondearIntermedias;
  }

  @override
  void dispose() {
    for (final c in [
      _nombre,
      _institucion,
      _programa,
      _minima,
      _maxima,
      _aprobatoria,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _aplicarPlantilla(ConfiguracionEscala p) {
    setState(() {
      _minima.text = p.formatear(p.notaMinima);
      _maxima.text = p.formatear(p.notaMaxima);
      _aprobatoria.text = p.formatear(p.notaAprobatoria);
      _decimales = p.decimales;
      _modo = p.modo;
      _intermedias = p.redondearIntermedias;
    });
  }

  /// La escala tal como está escrita; null si algún número no se puede leer.
  ConfiguracionEscala? _escalaEscrita() {
    final minima = parsearCentesimas(_minima.text);
    final maxima = parsearCentesimas(_maxima.text);
    final aprobatoria = parsearCentesimas(_aprobatoria.text);
    if (minima == null || maxima == null || aprobatoria == null) return null;
    return ConfiguracionEscala(
      notaMinima: minima,
      notaMaxima: maxima,
      notaAprobatoria: aprobatoria,
      decimales: _decimales,
      modo: _modo,
      redondearIntermedias: _intermedias,
    );
  }

  Future<void> _guardar(Perfil perfil, ConfiguracionEscala escala) async {
    setState(() => _guardando = true);
    try {
      await ref.read(baseDatosProvider).guardarConfiguracion(perfil, escala);
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
    final colorError = tema.colorScheme.error;

    final perfil = Perfil(
      nombre: _nombre.text.trim(),
      institucion: _institucion.text.trim(),
      programa: _programa.text.trim(),
    );
    final escala = _escalaEscrita();
    final errores = escala?.validar() ?? const <ErrorEscala>{};
    // Solo deja de ser null si la escala se puede leer y es válida.
    final escalaLista = (escala != null && errores.isEmpty) ? escala : null;
    final puedeGuardar =
        perfil.esValido && escalaLista != null && !_guardando;

    void alCambiar(String _) => setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: puedeGuardar && escalaLista != null
                  ? () => _guardar(perfil, escalaLista)
                  : null,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _Titulo('Perfil'),
            TextField(
              controller: _nombre,
              onChanged: alCambiar,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: const OutlineInputBorder(),
                helperText: perfil.esValido ? null : 'Obligatorio',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _institucion,
              onChanged: alCambiar,
              decoration: const InputDecoration(
                labelText: 'Institución',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _programa,
              onChanged: alCambiar,
              decoration: const InputDecoration(
                labelText: 'Programa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const _Titulo('Escala de notas'),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('ITM 0–5'),
                  onPressed: () => _aplicarPlantilla(ConfiguracionEscala.itm),
                ),
                ActionChip(
                  label: const Text('0–10'),
                  onPressed: () => _aplicarPlantilla(ConfiguracionEscala.diez),
                ),
                ActionChip(
                  label: const Text('0–100'),
                  onPressed: () => _aplicarPlantilla(ConfiguracionEscala.cien),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _CampoNota('Mínima', _minima, alCambiar)),
                const SizedBox(width: 8),
                Expanded(child: _CampoNota('Máxima', _maxima, alCambiar)),
                const SizedBox(width: 8),
                Expanded(child: _CampoNota('Aprueba con', _aprobatoria, alCambiar)),
              ],
            ),
            if (escala == null)
              _MensajeError(
                'Escribe números con máximo 2 decimales.',
                colorError,
              ),
            for (final e in errores) _MensajeError(e.mensaje, colorError),
            const SizedBox(height: 16),
            Text('Decimales', style: tema.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('0')),
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 2, label: Text('2')),
              ],
              selected: {_decimales},
              onSelectionChanged: (s) => setState(() => _decimales = s.first),
            ),
            const SizedBox(height: 16),
            Text('Redondeo', style: tema.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ModoRedondeo>(
              segments: const [
                ButtonSegment(
                  value: ModoRedondeo.redondear,
                  label: Text('Redondear'),
                ),
                ButtonSegment(
                  value: ModoRedondeo.truncar,
                  label: Text('Truncar'),
                ),
              ],
              selected: {_modo},
              onSelectionChanged: (s) => setState(() => _modo = s.first),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Redondear notas intermedias'),
              subtitle: const Text(
                'Evaluaciones compuestas, como un seguimiento de varios quices',
              ),
              value: _intermedias,
              onChanged: (v) => setState(() => _intermedias = v),
            ),
            const SizedBox(height: 8),
            if (escalaLista != null) _VistaPrevia(escalaLista),
          ],
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto.toUpperCase(),
        style: tema.textTheme.labelMedium?.copyWith(
          color: tema.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _CampoNota extends StatelessWidget {
  const _CampoNota(this.etiqueta, this.controller, this.alCambiar);

  final String etiqueta;
  final TextEditingController controller;
  final ValueChanged<String> alCambiar;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: alCambiar,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError(this.texto, this.color);

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(texto, style: TextStyle(color: color)),
    );
  }
}

class _VistaPrevia extends StatelessWidget {
  const _VistaPrevia(this.escala);

  final ConfiguracionEscala escala;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ejemplos = ejemplosRedondeo(escala);
    return Card(
      color: tema.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vista previa', style: tema.textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final e in ejemplos)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      e.aprueba ? Icons.check_circle_outline : Icons.cancel_outlined,
                      size: 18,
                      color: e.aprueba
                          ? const Color(0xFF17663A)
                          : const Color(0xFF8C1D18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${e.original} → ${e.redondeada} · '
                      '${e.aprueba ? 'aprueba' : 'no aprueba'}',
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Aprueba con ${escala.formatear(escala.notaAprobatoria)} '
              'de ${escala.formatear(escala.notaMaxima)}',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
