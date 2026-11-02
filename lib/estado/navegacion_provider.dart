import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Los destinos de la barra, en el mismo orden en que se muestran (D-011).
enum Destino { hoy, materias, notas, horario, agenda }

/// Pestaña actual de la barra. Vive en un provider para que otras
/// pantallas puedan cambiarla ("Ver notas", la alerta de Hoy).
class DestinoActual extends Notifier<Destino> {
  @override
  Destino build() => Destino.hoy;

  void ir(Destino destino) => state = destino;
}

final destinoProvider =
    NotifierProvider<DestinoActual, Destino>(DestinoActual.new);
