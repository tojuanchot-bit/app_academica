import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dominio/bloque_horario.dart';
import '../dominio/materia.dart';
import '../dominio/semestre.dart';
import 'providers.dart';

/// Lo que necesita la pantalla Horario: el semestre activo, sus materias
/// (de todos los estados) y sus bloques. El filtro de canceladas y cerradas
/// lo hacen las funciones de `dominio/horario.dart`.
typedef DatosHorario = ({
  Semestre semestre,
  List<Materia> materias,
  List<BloqueHorario> bloques,
});

/// Provider derivado: no consulta la base de datos, combina otros providers.
/// Si cambia el semestre activo, una materia o un bloque, se recalcula solo.
/// Devuelve AsyncData(null) si no hay semestre activo.
final horarioActivoProvider = Provider<AsyncValue<DatosHorario?>>((ref) {
  final semestres = ref.watch(semestresProvider);
  if (semestres case AsyncError(:final error, :final stackTrace)) {
    return AsyncError(error, stackTrace);
  }
  if (semestres is! AsyncData<List<Semestre>>) return const AsyncLoading();

  final activo = semestres.value.where((s) => s.activo).firstOrNull;
  if (activo == null) return const AsyncData(null);

  final id = activo.id!;
  final materias = ref.watch(materiasProvider(id));
  final bloques = ref.watch(bloquesSemestreProvider(id));

  if (materias case AsyncError(:final error, :final stackTrace)) {
    return AsyncError(error, stackTrace);
  }
  if (bloques case AsyncError(:final error, :final stackTrace)) {
    return AsyncError(error, stackTrace);
  }
  if (materias case AsyncData(value: final m)) {
    if (bloques case AsyncData(value: final b)) {
      return AsyncData((semestre: activo, materias: m, bloques: b));
    }
  }
  return const AsyncLoading();
});
