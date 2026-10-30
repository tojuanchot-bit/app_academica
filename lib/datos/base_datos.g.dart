// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_datos.dart';

// ignore_for_file: type=lint
class $PerfilesTable extends Perfiles
    with TableInfo<$PerfilesTable, PerfilFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institucionMeta = const VerificationMeta(
    'institucion',
  );
  @override
  late final GeneratedColumn<String> institucion = GeneratedColumn<String>(
    'institucion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programaMeta = const VerificationMeta(
    'programa',
  );
  @override
  late final GeneratedColumn<String> programa = GeneratedColumn<String>(
    'programa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMinimaMeta = const VerificationMeta(
    'notaMinima',
  );
  @override
  late final GeneratedColumn<int> notaMinima = GeneratedColumn<int>(
    'nota_minima',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMaximaMeta = const VerificationMeta(
    'notaMaxima',
  );
  @override
  late final GeneratedColumn<int> notaMaxima = GeneratedColumn<int>(
    'nota_maxima',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaAprobatoriaMeta = const VerificationMeta(
    'notaAprobatoria',
  );
  @override
  late final GeneratedColumn<int> notaAprobatoria = GeneratedColumn<int>(
    'nota_aprobatoria',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalesMeta = const VerificationMeta(
    'decimales',
  );
  @override
  late final GeneratedColumn<int> decimales = GeneratedColumn<int>(
    'decimales',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ModoRedondeo, String>
  modoRedondeo = GeneratedColumn<String>(
    'modo_redondeo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ModoRedondeo>($PerfilesTable.$convertermodoRedondeo);
  static const VerificationMeta _redondearIntermediasMeta =
      const VerificationMeta('redondearIntermedias');
  @override
  late final GeneratedColumn<bool> redondearIntermedias = GeneratedColumn<bool>(
    'redondear_intermedias',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("redondear_intermedias" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    institucion,
    programa,
    notaMinima,
    notaMaxima,
    notaAprobatoria,
    decimales,
    modoRedondeo,
    redondearIntermedias,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perfiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerfilFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('institucion')) {
      context.handle(
        _institucionMeta,
        institucion.isAcceptableOrUnknown(
          data['institucion']!,
          _institucionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institucionMeta);
    }
    if (data.containsKey('programa')) {
      context.handle(
        _programaMeta,
        programa.isAcceptableOrUnknown(data['programa']!, _programaMeta),
      );
    } else if (isInserting) {
      context.missing(_programaMeta);
    }
    if (data.containsKey('nota_minima')) {
      context.handle(
        _notaMinimaMeta,
        notaMinima.isAcceptableOrUnknown(data['nota_minima']!, _notaMinimaMeta),
      );
    } else if (isInserting) {
      context.missing(_notaMinimaMeta);
    }
    if (data.containsKey('nota_maxima')) {
      context.handle(
        _notaMaximaMeta,
        notaMaxima.isAcceptableOrUnknown(data['nota_maxima']!, _notaMaximaMeta),
      );
    } else if (isInserting) {
      context.missing(_notaMaximaMeta);
    }
    if (data.containsKey('nota_aprobatoria')) {
      context.handle(
        _notaAprobatoriaMeta,
        notaAprobatoria.isAcceptableOrUnknown(
          data['nota_aprobatoria']!,
          _notaAprobatoriaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notaAprobatoriaMeta);
    }
    if (data.containsKey('decimales')) {
      context.handle(
        _decimalesMeta,
        decimales.isAcceptableOrUnknown(data['decimales']!, _decimalesMeta),
      );
    } else if (isInserting) {
      context.missing(_decimalesMeta);
    }
    if (data.containsKey('redondear_intermedias')) {
      context.handle(
        _redondearIntermediasMeta,
        redondearIntermedias.isAcceptableOrUnknown(
          data['redondear_intermedias']!,
          _redondearIntermediasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_redondearIntermediasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerfilFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerfilFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      institucion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institucion'],
      )!,
      programa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}programa'],
      )!,
      notaMinima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_minima'],
      )!,
      notaMaxima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_maxima'],
      )!,
      notaAprobatoria: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_aprobatoria'],
      )!,
      decimales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}decimales'],
      )!,
      modoRedondeo: $PerfilesTable.$convertermodoRedondeo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}modo_redondeo'],
        )!,
      ),
      redondearIntermedias: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}redondear_intermedias'],
      )!,
    );
  }

  @override
  $PerfilesTable createAlias(String alias) {
    return $PerfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ModoRedondeo, String, String>
  $convertermodoRedondeo = const EnumNameConverter<ModoRedondeo>(
    ModoRedondeo.values,
  );
}

class PerfilFila extends DataClass implements Insertable<PerfilFila> {
  final int id;
  final String nombre;
  final String institucion;
  final String programa;
  final int notaMinima;
  final int notaMaxima;
  final int notaAprobatoria;
  final int decimales;
  final ModoRedondeo modoRedondeo;
  final bool redondearIntermedias;
  const PerfilFila({
    required this.id,
    required this.nombre,
    required this.institucion,
    required this.programa,
    required this.notaMinima,
    required this.notaMaxima,
    required this.notaAprobatoria,
    required this.decimales,
    required this.modoRedondeo,
    required this.redondearIntermedias,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['institucion'] = Variable<String>(institucion);
    map['programa'] = Variable<String>(programa);
    map['nota_minima'] = Variable<int>(notaMinima);
    map['nota_maxima'] = Variable<int>(notaMaxima);
    map['nota_aprobatoria'] = Variable<int>(notaAprobatoria);
    map['decimales'] = Variable<int>(decimales);
    {
      map['modo_redondeo'] = Variable<String>(
        $PerfilesTable.$convertermodoRedondeo.toSql(modoRedondeo),
      );
    }
    map['redondear_intermedias'] = Variable<bool>(redondearIntermedias);
    return map;
  }

  PerfilesCompanion toCompanion(bool nullToAbsent) {
    return PerfilesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      institucion: Value(institucion),
      programa: Value(programa),
      notaMinima: Value(notaMinima),
      notaMaxima: Value(notaMaxima),
      notaAprobatoria: Value(notaAprobatoria),
      decimales: Value(decimales),
      modoRedondeo: Value(modoRedondeo),
      redondearIntermedias: Value(redondearIntermedias),
    );
  }

  factory PerfilFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerfilFila(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      institucion: serializer.fromJson<String>(json['institucion']),
      programa: serializer.fromJson<String>(json['programa']),
      notaMinima: serializer.fromJson<int>(json['notaMinima']),
      notaMaxima: serializer.fromJson<int>(json['notaMaxima']),
      notaAprobatoria: serializer.fromJson<int>(json['notaAprobatoria']),
      decimales: serializer.fromJson<int>(json['decimales']),
      modoRedondeo: $PerfilesTable.$convertermodoRedondeo.fromJson(
        serializer.fromJson<String>(json['modoRedondeo']),
      ),
      redondearIntermedias: serializer.fromJson<bool>(
        json['redondearIntermedias'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'institucion': serializer.toJson<String>(institucion),
      'programa': serializer.toJson<String>(programa),
      'notaMinima': serializer.toJson<int>(notaMinima),
      'notaMaxima': serializer.toJson<int>(notaMaxima),
      'notaAprobatoria': serializer.toJson<int>(notaAprobatoria),
      'decimales': serializer.toJson<int>(decimales),
      'modoRedondeo': serializer.toJson<String>(
        $PerfilesTable.$convertermodoRedondeo.toJson(modoRedondeo),
      ),
      'redondearIntermedias': serializer.toJson<bool>(redondearIntermedias),
    };
  }

  PerfilFila copyWith({
    int? id,
    String? nombre,
    String? institucion,
    String? programa,
    int? notaMinima,
    int? notaMaxima,
    int? notaAprobatoria,
    int? decimales,
    ModoRedondeo? modoRedondeo,
    bool? redondearIntermedias,
  }) => PerfilFila(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    institucion: institucion ?? this.institucion,
    programa: programa ?? this.programa,
    notaMinima: notaMinima ?? this.notaMinima,
    notaMaxima: notaMaxima ?? this.notaMaxima,
    notaAprobatoria: notaAprobatoria ?? this.notaAprobatoria,
    decimales: decimales ?? this.decimales,
    modoRedondeo: modoRedondeo ?? this.modoRedondeo,
    redondearIntermedias: redondearIntermedias ?? this.redondearIntermedias,
  );
  PerfilFila copyWithCompanion(PerfilesCompanion data) {
    return PerfilFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      institucion: data.institucion.present
          ? data.institucion.value
          : this.institucion,
      programa: data.programa.present ? data.programa.value : this.programa,
      notaMinima: data.notaMinima.present
          ? data.notaMinima.value
          : this.notaMinima,
      notaMaxima: data.notaMaxima.present
          ? data.notaMaxima.value
          : this.notaMaxima,
      notaAprobatoria: data.notaAprobatoria.present
          ? data.notaAprobatoria.value
          : this.notaAprobatoria,
      decimales: data.decimales.present ? data.decimales.value : this.decimales,
      modoRedondeo: data.modoRedondeo.present
          ? data.modoRedondeo.value
          : this.modoRedondeo,
      redondearIntermedias: data.redondearIntermedias.present
          ? data.redondearIntermedias.value
          : this.redondearIntermedias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerfilFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('institucion: $institucion, ')
          ..write('programa: $programa, ')
          ..write('notaMinima: $notaMinima, ')
          ..write('notaMaxima: $notaMaxima, ')
          ..write('notaAprobatoria: $notaAprobatoria, ')
          ..write('decimales: $decimales, ')
          ..write('modoRedondeo: $modoRedondeo, ')
          ..write('redondearIntermedias: $redondearIntermedias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    institucion,
    programa,
    notaMinima,
    notaMaxima,
    notaAprobatoria,
    decimales,
    modoRedondeo,
    redondearIntermedias,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerfilFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.institucion == this.institucion &&
          other.programa == this.programa &&
          other.notaMinima == this.notaMinima &&
          other.notaMaxima == this.notaMaxima &&
          other.notaAprobatoria == this.notaAprobatoria &&
          other.decimales == this.decimales &&
          other.modoRedondeo == this.modoRedondeo &&
          other.redondearIntermedias == this.redondearIntermedias);
}

class PerfilesCompanion extends UpdateCompanion<PerfilFila> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> institucion;
  final Value<String> programa;
  final Value<int> notaMinima;
  final Value<int> notaMaxima;
  final Value<int> notaAprobatoria;
  final Value<int> decimales;
  final Value<ModoRedondeo> modoRedondeo;
  final Value<bool> redondearIntermedias;
  const PerfilesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.institucion = const Value.absent(),
    this.programa = const Value.absent(),
    this.notaMinima = const Value.absent(),
    this.notaMaxima = const Value.absent(),
    this.notaAprobatoria = const Value.absent(),
    this.decimales = const Value.absent(),
    this.modoRedondeo = const Value.absent(),
    this.redondearIntermedias = const Value.absent(),
  });
  PerfilesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String institucion,
    required String programa,
    required int notaMinima,
    required int notaMaxima,
    required int notaAprobatoria,
    required int decimales,
    required ModoRedondeo modoRedondeo,
    required bool redondearIntermedias,
  }) : nombre = Value(nombre),
       institucion = Value(institucion),
       programa = Value(programa),
       notaMinima = Value(notaMinima),
       notaMaxima = Value(notaMaxima),
       notaAprobatoria = Value(notaAprobatoria),
       decimales = Value(decimales),
       modoRedondeo = Value(modoRedondeo),
       redondearIntermedias = Value(redondearIntermedias);
  static Insertable<PerfilFila> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? institucion,
    Expression<String>? programa,
    Expression<int>? notaMinima,
    Expression<int>? notaMaxima,
    Expression<int>? notaAprobatoria,
    Expression<int>? decimales,
    Expression<String>? modoRedondeo,
    Expression<bool>? redondearIntermedias,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (institucion != null) 'institucion': institucion,
      if (programa != null) 'programa': programa,
      if (notaMinima != null) 'nota_minima': notaMinima,
      if (notaMaxima != null) 'nota_maxima': notaMaxima,
      if (notaAprobatoria != null) 'nota_aprobatoria': notaAprobatoria,
      if (decimales != null) 'decimales': decimales,
      if (modoRedondeo != null) 'modo_redondeo': modoRedondeo,
      if (redondearIntermedias != null)
        'redondear_intermedias': redondearIntermedias,
    });
  }

  PerfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? institucion,
    Value<String>? programa,
    Value<int>? notaMinima,
    Value<int>? notaMaxima,
    Value<int>? notaAprobatoria,
    Value<int>? decimales,
    Value<ModoRedondeo>? modoRedondeo,
    Value<bool>? redondearIntermedias,
  }) {
    return PerfilesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      institucion: institucion ?? this.institucion,
      programa: programa ?? this.programa,
      notaMinima: notaMinima ?? this.notaMinima,
      notaMaxima: notaMaxima ?? this.notaMaxima,
      notaAprobatoria: notaAprobatoria ?? this.notaAprobatoria,
      decimales: decimales ?? this.decimales,
      modoRedondeo: modoRedondeo ?? this.modoRedondeo,
      redondearIntermedias: redondearIntermedias ?? this.redondearIntermedias,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (institucion.present) {
      map['institucion'] = Variable<String>(institucion.value);
    }
    if (programa.present) {
      map['programa'] = Variable<String>(programa.value);
    }
    if (notaMinima.present) {
      map['nota_minima'] = Variable<int>(notaMinima.value);
    }
    if (notaMaxima.present) {
      map['nota_maxima'] = Variable<int>(notaMaxima.value);
    }
    if (notaAprobatoria.present) {
      map['nota_aprobatoria'] = Variable<int>(notaAprobatoria.value);
    }
    if (decimales.present) {
      map['decimales'] = Variable<int>(decimales.value);
    }
    if (modoRedondeo.present) {
      map['modo_redondeo'] = Variable<String>(
        $PerfilesTable.$convertermodoRedondeo.toSql(modoRedondeo.value),
      );
    }
    if (redondearIntermedias.present) {
      map['redondear_intermedias'] = Variable<bool>(redondearIntermedias.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerfilesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('institucion: $institucion, ')
          ..write('programa: $programa, ')
          ..write('notaMinima: $notaMinima, ')
          ..write('notaMaxima: $notaMaxima, ')
          ..write('notaAprobatoria: $notaAprobatoria, ')
          ..write('decimales: $decimales, ')
          ..write('modoRedondeo: $modoRedondeo, ')
          ..write('redondearIntermedias: $redondearIntermedias')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $PerfilesTable perfiles = $PerfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [perfiles];
}

typedef $$PerfilesTableCreateCompanionBuilder = PerfilesCompanion Function({
  Value<int> id,
  required String nombre,
  required String institucion,
  required String programa,
  required int notaMinima,
  required int notaMaxima,
  required int notaAprobatoria,
  required int decimales,
  required ModoRedondeo modoRedondeo,
  required bool redondearIntermedias,
});
typedef $$PerfilesTableUpdateCompanionBuilder = PerfilesCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> institucion,
  Value<String> programa,
  Value<int> notaMinima,
  Value<int> notaMaxima,
  Value<int> notaAprobatoria,
  Value<int> decimales,
  Value<ModoRedondeo> modoRedondeo,
  Value<bool> redondearIntermedias,
});

class $$PerfilesTableFilterComposer
    extends Composer<_$BaseDatos, $PerfilesTable> {
  $$PerfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institucion => $composableBuilder(
    column: $table.institucion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programa => $composableBuilder(
    column: $table.programa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaMaxima => $composableBuilder(
    column: $table.notaMaxima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaAprobatoria => $composableBuilder(
    column: $table.notaAprobatoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get decimales => $composableBuilder(
    column: $table.decimales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ModoRedondeo, ModoRedondeo, String>
  get modoRedondeo => $composableBuilder(
    column: $table.modoRedondeo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get redondearIntermedias => $composableBuilder(
    column: $table.redondearIntermedias,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PerfilesTableOrderingComposer
    extends Composer<_$BaseDatos, $PerfilesTable> {
  $$PerfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institucion => $composableBuilder(
    column: $table.institucion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programa => $composableBuilder(
    column: $table.programa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaMaxima => $composableBuilder(
    column: $table.notaMaxima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaAprobatoria => $composableBuilder(
    column: $table.notaAprobatoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decimales => $composableBuilder(
    column: $table.decimales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modoRedondeo => $composableBuilder(
    column: $table.modoRedondeo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get redondearIntermedias => $composableBuilder(
    column: $table.redondearIntermedias,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerfilesTableAnnotationComposer
    extends Composer<_$BaseDatos, $PerfilesTable> {
  $$PerfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get institucion => $composableBuilder(
    column: $table.institucion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get programa =>
      $composableBuilder(column: $table.programa, builder: (column) => column);

  GeneratedColumn<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notaMaxima => $composableBuilder(
    column: $table.notaMaxima,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notaAprobatoria => $composableBuilder(
    column: $table.notaAprobatoria,
    builder: (column) => column,
  );

  GeneratedColumn<int> get decimales =>
      $composableBuilder(column: $table.decimales, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ModoRedondeo, String> get modoRedondeo =>
      $composableBuilder(
        column: $table.modoRedondeo,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get redondearIntermedias => $composableBuilder(
    column: $table.redondearIntermedias,
    builder: (column) => column,
  );
}

class $$PerfilesTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $PerfilesTable,
          PerfilFila,
          $$PerfilesTableFilterComposer,
          $$PerfilesTableOrderingComposer,
          $$PerfilesTableAnnotationComposer,
          $$PerfilesTableCreateCompanionBuilder,
          $$PerfilesTableUpdateCompanionBuilder,
          (PerfilFila, BaseReferences<_$BaseDatos, $PerfilesTable, PerfilFila>),
          PerfilFila,
          PrefetchHooks Function()
        > {
  $$PerfilesTableTableManager(_$BaseDatos db, $PerfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> institucion = const Value.absent(),
                Value<String> programa = const Value.absent(),
                Value<int> notaMinima = const Value.absent(),
                Value<int> notaMaxima = const Value.absent(),
                Value<int> notaAprobatoria = const Value.absent(),
                Value<int> decimales = const Value.absent(),
                Value<ModoRedondeo> modoRedondeo = const Value.absent(),
                Value<bool> redondearIntermedias = const Value.absent(),
              }) => PerfilesCompanion(
                id: id,
                nombre: nombre,
                institucion: institucion,
                programa: programa,
                notaMinima: notaMinima,
                notaMaxima: notaMaxima,
                notaAprobatoria: notaAprobatoria,
                decimales: decimales,
                modoRedondeo: modoRedondeo,
                redondearIntermedias: redondearIntermedias,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String institucion,
                required String programa,
                required int notaMinima,
                required int notaMaxima,
                required int notaAprobatoria,
                required int decimales,
                required ModoRedondeo modoRedondeo,
                required bool redondearIntermedias,
              }) => PerfilesCompanion.insert(
                id: id,
                nombre: nombre,
                institucion: institucion,
                programa: programa,
                notaMinima: notaMinima,
                notaMaxima: notaMaxima,
                notaAprobatoria: notaAprobatoria,
                decimales: decimales,
                modoRedondeo: modoRedondeo,
                redondearIntermedias: redondearIntermedias,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PerfilesTable, PerfilFila>(table),
                  BaseReferences<_$BaseDatos, $PerfilesTable, PerfilFila>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PerfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $PerfilesTable,
      PerfilFila,
      $$PerfilesTableFilterComposer,
      $$PerfilesTableOrderingComposer,
      $$PerfilesTableAnnotationComposer,
      $$PerfilesTableCreateCompanionBuilder,
      $$PerfilesTableUpdateCompanionBuilder,
      (PerfilFila, BaseReferences<_$BaseDatos, $PerfilesTable, PerfilFila>),
      PerfilFila,
      PrefetchHooks Function()
    >;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$PerfilesTableTableManager get perfiles =>
      $$PerfilesTableTableManager(_db, _db.perfiles);
}
