import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../dominio/configuracion_escala.dart';
import '../dominio/perfil.dart';
import '../dominio/redondeo.dart';

// Lo genera `dart run build_runner build`. No se edita a mano.
part 'base_datos.g.dart';

/// Una sola fila (id = 1) con el perfil y la escala de notas.
/// Las notas de la escala van en centésimas (300 = 3.0).
@DataClassName('PerfilFila')
class Perfiles extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text()();
  TextColumn get institucion => text()();
  TextColumn get programa => text()();
  IntColumn get notaMinima => integer()();
  IntColumn get notaMaxima => integer()();
  IntColumn get notaAprobatoria => integer()();
  IntColumn get decimales => integer()();
  TextColumn get modoRedondeo => textEnum<ModoRedondeo>()();
  BoolColumn get redondearIntermedias => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Perfiles])
class BaseDatos extends _$BaseDatos {
  BaseDatos([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'app_academica'));

  @override
  int get schemaVersion => 1;

  static const _idPerfil = 1;

  /// Emite la configuración cada vez que cambia en la base de datos.
  /// Si aún no se ha guardado nada, emite el perfil vacío con la escala ITM.
  Stream<ConfiguracionUsuario> observarConfiguracion() {
    final consulta = select(perfiles)..where((t) => t.id.equals(_idPerfil));
    return consulta.watchSingleOrNull().map((fila) {
      if (fila == null) return configuracionInicial;
      return (
        perfil: Perfil(
          nombre: fila.nombre,
          institucion: fila.institucion,
          programa: fila.programa,
        ),
        escala: ConfiguracionEscala(
          notaMinima: fila.notaMinima,
          notaMaxima: fila.notaMaxima,
          notaAprobatoria: fila.notaAprobatoria,
          decimales: fila.decimales,
          modo: fila.modoRedondeo,
          redondearIntermedias: fila.redondearIntermedias,
        ),
      );
    });
  }

  /// Inserta la fila la primera vez y la actualiza las siguientes.
  Future<void> guardarConfiguracion(
    Perfil perfil,
    ConfiguracionEscala escala,
  ) async {
    await into(perfiles).insertOnConflictUpdate(
      PerfilesCompanion(
        id: const Value(_idPerfil),
        nombre: Value(perfil.nombre.trim()),
        institucion: Value(perfil.institucion.trim()),
        programa: Value(perfil.programa.trim()),
        notaMinima: Value(escala.notaMinima),
        notaMaxima: Value(escala.notaMaxima),
        notaAprobatoria: Value(escala.notaAprobatoria),
        decimales: Value(escala.decimales),
        modoRedondeo: Value(escala.modo),
        redondearIntermedias: Value(escala.redondearIntermedias),
      ),
    );
  }
}
