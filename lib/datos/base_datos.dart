import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../dominio/configuracion_escala.dart';
import '../dominio/materia.dart';
import '../dominio/perfil.dart';
import '../dominio/redondeo.dart';
import '../dominio/semestre.dart';

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

@DataClassName('SemestreFila')
class Semestres extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  DateTimeColumn get fechaInicio => dateTime().nullable()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(false))();
}

@DataClassName('MateriaFila')
class Materias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get semestreId => integer()
      .references(Semestres, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  TextColumn get docente => text().withDefault(const Constant(''))();
  IntColumn get creditos => integer()();
  IntColumn get color => integer()();
  TextColumn get estado => textEnum<EstadoMateria>()();
  DateTimeColumn get fechaCancelacion => dateTime().nullable()();

  /// En centésimas; solo en materias aprobadas o reprobadas.
  IntColumn get notaFinal => integer().nullable()();
}

@DriftDatabase(tables: [Perfiles, Semestres, Materias])
class BaseDatos extends _$BaseDatos {
  BaseDatos([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'app_academica'));

  /// 1: perfil y escala. 2: semestres y materias.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(semestres);
            await m.createTable(materias);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------- Perfil

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

  // ------------------------------------------------------------- Semestres

  static Semestre _aSemestre(SemestreFila f) => Semestre(
        id: f.id,
        nombre: f.nombre,
        fechaInicio: f.fechaInicio,
        fechaFin: f.fechaFin,
        activo: f.activo,
      );

  /// Del más reciente al más antiguo ("2026-2" antes que "2026-1").
  Stream<List<Semestre>> observarSemestres() {
    final consulta = select(semestres)
      ..orderBy([(t) => OrderingTerm.desc(t.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aSemestre).toList());
  }

  /// Crea o actualiza. Si queda activo, desactiva los demás.
  /// Devuelve el id del semestre.
  Future<int> guardarSemestre(Semestre s) {
    return transaction(() async {
      if (s.activo) {
        await update(semestres)
            .write(const SemestresCompanion(activo: Value(false)));
      }
      final datos = SemestresCompanion(
        nombre: Value(s.nombre.trim()),
        fechaInicio: Value(s.fechaInicio),
        fechaFin: Value(s.fechaFin),
        activo: Value(s.activo),
      );
      final id = s.id;
      if (id == null) return into(semestres).insert(datos);
      await (update(semestres)..where((t) => t.id.equals(id))).write(datos);
      return id;
    });
  }

  Future<void> marcarActivo(int id) {
    return transaction(() async {
      await update(semestres)
          .write(const SemestresCompanion(activo: Value(false)));
      await (update(semestres)..where((t) => t.id.equals(id)))
          .write(const SemestresCompanion(activo: Value(true)));
    });
  }

  /// Borra el semestre y todas sus materias.
  Future<void> eliminarSemestre(int id) {
    return transaction(() async {
      await (delete(materias)..where((t) => t.semestreId.equals(id))).go();
      await (delete(semestres)..where((t) => t.id.equals(id))).go();
    });
  }

  // -------------------------------------------------------------- Materias

  static Materia _aMateria(MateriaFila f) => Materia(
        id: f.id,
        semestreId: f.semestreId,
        nombre: f.nombre,
        docente: f.docente,
        creditos: f.creditos,
        color: f.color,
        estado: f.estado,
        fechaCancelacion: f.fechaCancelacion,
        notaFinal: f.notaFinal,
      );

  Stream<List<Materia>> observarMaterias(int semestreId) {
    final consulta = select(materias)
      ..where((t) => t.semestreId.equals(semestreId))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aMateria).toList());
  }

  Stream<Materia?> observarMateria(int id) {
    final consulta = select(materias)..where((t) => t.id.equals(id));
    return consulta
        .watchSingleOrNull()
        .map((fila) => fila == null ? null : _aMateria(fila));
  }

  /// Crea o actualiza. Devuelve el id de la materia.
  Future<int> guardarMateria(Materia m) async {
    final datos = MateriasCompanion(
      semestreId: Value(m.semestreId),
      nombre: Value(m.nombre.trim()),
      docente: Value(m.docente.trim()),
      creditos: Value(m.creditos),
      color: Value(m.color),
      estado: Value(m.estado),
      fechaCancelacion: Value(m.fechaCancelacion),
      notaFinal: Value(m.notaFinal),
    );
    final id = m.id;
    if (id == null) return into(materias).insert(datos);
    await (update(materias)..where((t) => t.id.equals(id))).write(datos);
    return id;
  }

  Future<void> eliminarMateria(int id) async {
    await (delete(materias)..where((t) => t.id.equals(id))).go();
  }
}
