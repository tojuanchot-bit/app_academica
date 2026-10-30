import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datos/base_datos.dart';
import '../dominio/evaluacion.dart';
import '../dominio/materia.dart';
import '../dominio/perfil.dart';
import '../dominio/semestre.dart';

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

/// Todos los semestres, del más reciente al más antiguo.
final semestresProvider = StreamProvider<List<Semestre>>((ref) {
  return ref.watch(baseDatosProvider).observarSemestres();
});

/// Materias de un semestre (el argumento es el id del semestre).
final materiasProvider =
    StreamProvider.family<List<Materia>, int>((ref, semestreId) {
  return ref.watch(baseDatosProvider).observarMaterias(semestreId);
});

/// Una materia por id; null si se eliminó.
final materiaProvider = StreamProvider.family<Materia?, int>((ref, id) {
  return ref.watch(baseDatosProvider).observarMateria(id);
});

/// Evaluaciones de una materia (el argumento es el id de la materia).
final evaluacionesProvider =
    StreamProvider.family<List<Evaluacion>, int>((ref, materiaId) {
  return ref.watch(baseDatosProvider).observarEvaluaciones(materiaId);
});
