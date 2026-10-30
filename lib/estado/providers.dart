import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datos/base_datos.dart';
import '../dominio/perfil.dart';

/// Una sola base de datos para toda la app; se cierra si el provider se destruye.
final baseDatosProvider = Provider<BaseDatos>((ref) {
  final db = BaseDatos();
  ref.onDispose(db.close);
  return db;
});

/// Perfil y escala actuales. Cualquier pantalla que lo observe se
/// reconstruye sola cuando se guarda un cambio.
final configuracionProvider = StreamProvider<ConfiguracionUsuario>((ref) {
  return ref.watch(baseDatosProvider).observarConfiguracion();
});
