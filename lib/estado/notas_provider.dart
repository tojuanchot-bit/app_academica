import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Semestre elegido en la pestaña Notas; null = el activo (lo resuelve
/// `elegirSemestre`). Es independiente del selector de Materias.
class SemestreNotas extends Notifier<int?> {
  @override
  int? build() => null;

  void elegir(int? id) => state = id;
}

final semestreNotasProvider =
    NotifierProvider<SemestreNotas, int?>(SemestreNotas.new);

/// Ids de las materias desplegadas en Notas. Vive en un provider (no en la
/// pantalla) para que otras pantallas puedan abrir Notas con una materia
/// ya desplegada ("Ver notas", punto 4).
class MateriasDesplegadas extends Notifier<Set<int>> {
  @override
  Set<int> build() => const {};

  void alternar(int id) => state =
      state.contains(id) ? ({...state}..remove(id)) : {...state, id};

  void desplegar(int id) {
    if (!state.contains(id)) state = {...state, id};
  }
}

final materiasDesplegadasProvider =
    NotifierProvider<MateriasDesplegadas, Set<int>>(MateriasDesplegadas.new);

/// Materia hasta la que Notas debe desplazarse una vez ("Ver notas").
/// La fila la limpia apenas se hace visible.
class MateriaEnfocada extends Notifier<int?> {
  @override
  int? build() => null;

  void enfocar(int id) => state = id;

  void limpiar() => state = null;
}

final materiaEnfocadaProvider =
    NotifierProvider<MateriaEnfocada, int?>(MateriaEnfocada.new);
