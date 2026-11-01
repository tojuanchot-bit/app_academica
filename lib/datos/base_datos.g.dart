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

class $SemestresTable extends Semestres
    with TableInfo<$SemestresTable, SemestreFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SemestresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
    'fecha_fin',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    fechaInicio,
    fechaFin,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'semestres';
  @override
  VerificationContext validateIntegrity(
    Insertable<SemestreFila> instance, {
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
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SemestreFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SemestreFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      ),
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $SemestresTable createAlias(String alias) {
    return $SemestresTable(attachedDatabase, alias);
  }
}

class SemestreFila extends DataClass implements Insertable<SemestreFila> {
  final int id;
  final String nombre;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final bool activo;
  const SemestreFila({
    required this.id,
    required this.nombre,
    this.fechaInicio,
    this.fechaFin,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || fechaInicio != null) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    }
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  SemestresCompanion toCompanion(bool nullToAbsent) {
    return SemestresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      fechaInicio: fechaInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      activo: Value(activo),
    );
  }

  factory SemestreFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SemestreFila(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      fechaInicio: serializer.fromJson<DateTime?>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'fechaInicio': serializer.toJson<DateTime?>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  SemestreFila copyWith({
    int? id,
    String? nombre,
    Value<DateTime?> fechaInicio = const Value.absent(),
    Value<DateTime?> fechaFin = const Value.absent(),
    bool? activo,
  }) => SemestreFila(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    fechaInicio: fechaInicio.present ? fechaInicio.value : this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    activo: activo ?? this.activo,
  );
  SemestreFila copyWithCompanion(SemestresCompanion data) {
    return SemestreFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SemestreFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, fechaInicio, fechaFin, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SemestreFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.activo == this.activo);
}

class SemestresCompanion extends UpdateCompanion<SemestreFila> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<DateTime?> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<bool> activo;
  const SemestresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
  });
  SemestresCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<SemestreFila> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (activo != null) 'activo': activo,
    });
  }

  SemestresCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<DateTime?>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<bool>? activo,
  }) {
    return SemestresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activo: activo ?? this.activo,
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
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SemestresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $MateriasTable extends Materias
    with TableInfo<$MateriasTable, MateriaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MateriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _semestreIdMeta = const VerificationMeta(
    'semestreId',
  );
  @override
  late final GeneratedColumn<int> semestreId = GeneratedColumn<int>(
    'semestre_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES semestres (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _docenteMeta = const VerificationMeta(
    'docente',
  );
  @override
  late final GeneratedColumn<String> docente = GeneratedColumn<String>(
    'docente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _creditosMeta = const VerificationMeta(
    'creditos',
  );
  @override
  late final GeneratedColumn<int> creditos = GeneratedColumn<int>(
    'creditos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoMateria, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoMateria>($MateriasTable.$converterestado);
  static const VerificationMeta _fechaCancelacionMeta = const VerificationMeta(
    'fechaCancelacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCancelacion =
      GeneratedColumn<DateTime>(
        'fecha_cancelacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notaFinalMeta = const VerificationMeta(
    'notaFinal',
  );
  @override
  late final GeneratedColumn<int> notaFinal = GeneratedColumn<int>(
    'nota_final',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    semestreId,
    nombre,
    docente,
    creditos,
    color,
    estado,
    fechaCancelacion,
    notaFinal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materias';
  @override
  VerificationContext validateIntegrity(
    Insertable<MateriaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('semestre_id')) {
      context.handle(
        _semestreIdMeta,
        semestreId.isAcceptableOrUnknown(data['semestre_id']!, _semestreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_semestreIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('docente')) {
      context.handle(
        _docenteMeta,
        docente.isAcceptableOrUnknown(data['docente']!, _docenteMeta),
      );
    }
    if (data.containsKey('creditos')) {
      context.handle(
        _creditosMeta,
        creditos.isAcceptableOrUnknown(data['creditos']!, _creditosMeta),
      );
    } else if (isInserting) {
      context.missing(_creditosMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('fecha_cancelacion')) {
      context.handle(
        _fechaCancelacionMeta,
        fechaCancelacion.isAcceptableOrUnknown(
          data['fecha_cancelacion']!,
          _fechaCancelacionMeta,
        ),
      );
    }
    if (data.containsKey('nota_final')) {
      context.handle(
        _notaFinalMeta,
        notaFinal.isAcceptableOrUnknown(data['nota_final']!, _notaFinalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MateriaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MateriaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      semestreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semestre_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      docente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}docente'],
      )!,
      creditos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creditos'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      estado: $MateriasTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
      fechaCancelacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cancelacion'],
      ),
      notaFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_final'],
      ),
    );
  }

  @override
  $MateriasTable createAlias(String alias) {
    return $MateriasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoMateria, String, String> $converterestado =
      const EnumNameConverter<EstadoMateria>(EstadoMateria.values);
}

class MateriaFila extends DataClass implements Insertable<MateriaFila> {
  final int id;
  final int semestreId;
  final String nombre;
  final String docente;
  final int creditos;
  final int color;
  final EstadoMateria estado;
  final DateTime? fechaCancelacion;

  /// En centésimas; solo en materias aprobadas o reprobadas.
  final int? notaFinal;
  const MateriaFila({
    required this.id,
    required this.semestreId,
    required this.nombre,
    required this.docente,
    required this.creditos,
    required this.color,
    required this.estado,
    this.fechaCancelacion,
    this.notaFinal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['semestre_id'] = Variable<int>(semestreId);
    map['nombre'] = Variable<String>(nombre);
    map['docente'] = Variable<String>(docente);
    map['creditos'] = Variable<int>(creditos);
    map['color'] = Variable<int>(color);
    {
      map['estado'] = Variable<String>(
        $MateriasTable.$converterestado.toSql(estado),
      );
    }
    if (!nullToAbsent || fechaCancelacion != null) {
      map['fecha_cancelacion'] = Variable<DateTime>(fechaCancelacion);
    }
    if (!nullToAbsent || notaFinal != null) {
      map['nota_final'] = Variable<int>(notaFinal);
    }
    return map;
  }

  MateriasCompanion toCompanion(bool nullToAbsent) {
    return MateriasCompanion(
      id: Value(id),
      semestreId: Value(semestreId),
      nombre: Value(nombre),
      docente: Value(docente),
      creditos: Value(creditos),
      color: Value(color),
      estado: Value(estado),
      fechaCancelacion: fechaCancelacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCancelacion),
      notaFinal: notaFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(notaFinal),
    );
  }

  factory MateriaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MateriaFila(
      id: serializer.fromJson<int>(json['id']),
      semestreId: serializer.fromJson<int>(json['semestreId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      docente: serializer.fromJson<String>(json['docente']),
      creditos: serializer.fromJson<int>(json['creditos']),
      color: serializer.fromJson<int>(json['color']),
      estado: $MateriasTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
      fechaCancelacion: serializer.fromJson<DateTime?>(
        json['fechaCancelacion'],
      ),
      notaFinal: serializer.fromJson<int?>(json['notaFinal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'semestreId': serializer.toJson<int>(semestreId),
      'nombre': serializer.toJson<String>(nombre),
      'docente': serializer.toJson<String>(docente),
      'creditos': serializer.toJson<int>(creditos),
      'color': serializer.toJson<int>(color),
      'estado': serializer.toJson<String>(
        $MateriasTable.$converterestado.toJson(estado),
      ),
      'fechaCancelacion': serializer.toJson<DateTime?>(fechaCancelacion),
      'notaFinal': serializer.toJson<int?>(notaFinal),
    };
  }

  MateriaFila copyWith({
    int? id,
    int? semestreId,
    String? nombre,
    String? docente,
    int? creditos,
    int? color,
    EstadoMateria? estado,
    Value<DateTime?> fechaCancelacion = const Value.absent(),
    Value<int?> notaFinal = const Value.absent(),
  }) => MateriaFila(
    id: id ?? this.id,
    semestreId: semestreId ?? this.semestreId,
    nombre: nombre ?? this.nombre,
    docente: docente ?? this.docente,
    creditos: creditos ?? this.creditos,
    color: color ?? this.color,
    estado: estado ?? this.estado,
    fechaCancelacion: fechaCancelacion.present
        ? fechaCancelacion.value
        : this.fechaCancelacion,
    notaFinal: notaFinal.present ? notaFinal.value : this.notaFinal,
  );
  MateriaFila copyWithCompanion(MateriasCompanion data) {
    return MateriaFila(
      id: data.id.present ? data.id.value : this.id,
      semestreId: data.semestreId.present
          ? data.semestreId.value
          : this.semestreId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      docente: data.docente.present ? data.docente.value : this.docente,
      creditos: data.creditos.present ? data.creditos.value : this.creditos,
      color: data.color.present ? data.color.value : this.color,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaCancelacion: data.fechaCancelacion.present
          ? data.fechaCancelacion.value
          : this.fechaCancelacion,
      notaFinal: data.notaFinal.present ? data.notaFinal.value : this.notaFinal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MateriaFila(')
          ..write('id: $id, ')
          ..write('semestreId: $semestreId, ')
          ..write('nombre: $nombre, ')
          ..write('docente: $docente, ')
          ..write('creditos: $creditos, ')
          ..write('color: $color, ')
          ..write('estado: $estado, ')
          ..write('fechaCancelacion: $fechaCancelacion, ')
          ..write('notaFinal: $notaFinal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    semestreId,
    nombre,
    docente,
    creditos,
    color,
    estado,
    fechaCancelacion,
    notaFinal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MateriaFila &&
          other.id == this.id &&
          other.semestreId == this.semestreId &&
          other.nombre == this.nombre &&
          other.docente == this.docente &&
          other.creditos == this.creditos &&
          other.color == this.color &&
          other.estado == this.estado &&
          other.fechaCancelacion == this.fechaCancelacion &&
          other.notaFinal == this.notaFinal);
}

class MateriasCompanion extends UpdateCompanion<MateriaFila> {
  final Value<int> id;
  final Value<int> semestreId;
  final Value<String> nombre;
  final Value<String> docente;
  final Value<int> creditos;
  final Value<int> color;
  final Value<EstadoMateria> estado;
  final Value<DateTime?> fechaCancelacion;
  final Value<int?> notaFinal;
  const MateriasCompanion({
    this.id = const Value.absent(),
    this.semestreId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.docente = const Value.absent(),
    this.creditos = const Value.absent(),
    this.color = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaCancelacion = const Value.absent(),
    this.notaFinal = const Value.absent(),
  });
  MateriasCompanion.insert({
    this.id = const Value.absent(),
    required int semestreId,
    required String nombre,
    this.docente = const Value.absent(),
    required int creditos,
    required int color,
    required EstadoMateria estado,
    this.fechaCancelacion = const Value.absent(),
    this.notaFinal = const Value.absent(),
  }) : semestreId = Value(semestreId),
       nombre = Value(nombre),
       creditos = Value(creditos),
       color = Value(color),
       estado = Value(estado);
  static Insertable<MateriaFila> custom({
    Expression<int>? id,
    Expression<int>? semestreId,
    Expression<String>? nombre,
    Expression<String>? docente,
    Expression<int>? creditos,
    Expression<int>? color,
    Expression<String>? estado,
    Expression<DateTime>? fechaCancelacion,
    Expression<int>? notaFinal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (semestreId != null) 'semestre_id': semestreId,
      if (nombre != null) 'nombre': nombre,
      if (docente != null) 'docente': docente,
      if (creditos != null) 'creditos': creditos,
      if (color != null) 'color': color,
      if (estado != null) 'estado': estado,
      if (fechaCancelacion != null) 'fecha_cancelacion': fechaCancelacion,
      if (notaFinal != null) 'nota_final': notaFinal,
    });
  }

  MateriasCompanion copyWith({
    Value<int>? id,
    Value<int>? semestreId,
    Value<String>? nombre,
    Value<String>? docente,
    Value<int>? creditos,
    Value<int>? color,
    Value<EstadoMateria>? estado,
    Value<DateTime?>? fechaCancelacion,
    Value<int?>? notaFinal,
  }) {
    return MateriasCompanion(
      id: id ?? this.id,
      semestreId: semestreId ?? this.semestreId,
      nombre: nombre ?? this.nombre,
      docente: docente ?? this.docente,
      creditos: creditos ?? this.creditos,
      color: color ?? this.color,
      estado: estado ?? this.estado,
      fechaCancelacion: fechaCancelacion ?? this.fechaCancelacion,
      notaFinal: notaFinal ?? this.notaFinal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (semestreId.present) {
      map['semestre_id'] = Variable<int>(semestreId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (docente.present) {
      map['docente'] = Variable<String>(docente.value);
    }
    if (creditos.present) {
      map['creditos'] = Variable<int>(creditos.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $MateriasTable.$converterestado.toSql(estado.value),
      );
    }
    if (fechaCancelacion.present) {
      map['fecha_cancelacion'] = Variable<DateTime>(fechaCancelacion.value);
    }
    if (notaFinal.present) {
      map['nota_final'] = Variable<int>(notaFinal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MateriasCompanion(')
          ..write('id: $id, ')
          ..write('semestreId: $semestreId, ')
          ..write('nombre: $nombre, ')
          ..write('docente: $docente, ')
          ..write('creditos: $creditos, ')
          ..write('color: $color, ')
          ..write('estado: $estado, ')
          ..write('fechaCancelacion: $fechaCancelacion, ')
          ..write('notaFinal: $notaFinal')
          ..write(')'))
        .toString();
  }
}

class $EvaluacionesTable extends Evaluaciones
    with TableInfo<$EvaluacionesTable, EvaluacionFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvaluacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _materiaIdMeta = const VerificationMeta(
    'materiaId',
  );
  @override
  late final GeneratedColumn<int> materiaId = GeneratedColumn<int>(
    'materia_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materias (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _padreIdMeta = const VerificationMeta(
    'padreId',
  );
  @override
  late final GeneratedColumn<int> padreId = GeneratedColumn<int>(
    'padre_id',
    aliasedName,
    true,
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
  static const VerificationMeta _porcentajeMeta = const VerificationMeta(
    'porcentaje',
  );
  @override
  late final GeneratedColumn<int> porcentaje = GeneratedColumn<int>(
    'porcentaje',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<int> nota = GeneratedColumn<int>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notaSupuestaMeta = const VerificationMeta(
    'notaSupuesta',
  );
  @override
  late final GeneratedColumn<int> notaSupuesta = GeneratedColumn<int>(
    'nota_supuesta',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    materiaId,
    padreId,
    nombre,
    porcentaje,
    nota,
    fecha,
    notaSupuesta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evaluaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvaluacionFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('materia_id')) {
      context.handle(
        _materiaIdMeta,
        materiaId.isAcceptableOrUnknown(data['materia_id']!, _materiaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materiaIdMeta);
    }
    if (data.containsKey('padre_id')) {
      context.handle(
        _padreIdMeta,
        padreId.isAcceptableOrUnknown(data['padre_id']!, _padreIdMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('porcentaje')) {
      context.handle(
        _porcentajeMeta,
        porcentaje.isAcceptableOrUnknown(data['porcentaje']!, _porcentajeMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('nota_supuesta')) {
      context.handle(
        _notaSupuestaMeta,
        notaSupuesta.isAcceptableOrUnknown(
          data['nota_supuesta']!,
          _notaSupuestaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvaluacionFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvaluacionFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      materiaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}materia_id'],
      )!,
      padreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}padre_id'],
      ),
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      porcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcentaje'],
      ),
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      ),
      notaSupuesta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_supuesta'],
      ),
    );
  }

  @override
  $EvaluacionesTable createAlias(String alias) {
    return $EvaluacionesTable(attachedDatabase, alias);
  }
}

class EvaluacionFila extends DataClass implements Insertable<EvaluacionFila> {
  final int id;
  final int materiaId;

  /// Evaluación compuesta a la que pertenece; null en el primer nivel.
  final int? padreId;
  final String nombre;

  /// En centésimas de % (30 % = 3000).
  final int? porcentaje;

  /// En centésimas (3.5 = 350).
  final int? nota;
  final DateTime? fecha;
  final int? notaSupuesta;
  const EvaluacionFila({
    required this.id,
    required this.materiaId,
    this.padreId,
    required this.nombre,
    this.porcentaje,
    this.nota,
    this.fecha,
    this.notaSupuesta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['materia_id'] = Variable<int>(materiaId);
    if (!nullToAbsent || padreId != null) {
      map['padre_id'] = Variable<int>(padreId);
    }
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || porcentaje != null) {
      map['porcentaje'] = Variable<int>(porcentaje);
    }
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<int>(nota);
    }
    if (!nullToAbsent || fecha != null) {
      map['fecha'] = Variable<DateTime>(fecha);
    }
    if (!nullToAbsent || notaSupuesta != null) {
      map['nota_supuesta'] = Variable<int>(notaSupuesta);
    }
    return map;
  }

  EvaluacionesCompanion toCompanion(bool nullToAbsent) {
    return EvaluacionesCompanion(
      id: Value(id),
      materiaId: Value(materiaId),
      padreId: padreId == null && nullToAbsent
          ? const Value.absent()
          : Value(padreId),
      nombre: Value(nombre),
      porcentaje: porcentaje == null && nullToAbsent
          ? const Value.absent()
          : Value(porcentaje),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      fecha: fecha == null && nullToAbsent
          ? const Value.absent()
          : Value(fecha),
      notaSupuesta: notaSupuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(notaSupuesta),
    );
  }

  factory EvaluacionFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvaluacionFila(
      id: serializer.fromJson<int>(json['id']),
      materiaId: serializer.fromJson<int>(json['materiaId']),
      padreId: serializer.fromJson<int?>(json['padreId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      porcentaje: serializer.fromJson<int?>(json['porcentaje']),
      nota: serializer.fromJson<int?>(json['nota']),
      fecha: serializer.fromJson<DateTime?>(json['fecha']),
      notaSupuesta: serializer.fromJson<int?>(json['notaSupuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'materiaId': serializer.toJson<int>(materiaId),
      'padreId': serializer.toJson<int?>(padreId),
      'nombre': serializer.toJson<String>(nombre),
      'porcentaje': serializer.toJson<int?>(porcentaje),
      'nota': serializer.toJson<int?>(nota),
      'fecha': serializer.toJson<DateTime?>(fecha),
      'notaSupuesta': serializer.toJson<int?>(notaSupuesta),
    };
  }

  EvaluacionFila copyWith({
    int? id,
    int? materiaId,
    Value<int?> padreId = const Value.absent(),
    String? nombre,
    Value<int?> porcentaje = const Value.absent(),
    Value<int?> nota = const Value.absent(),
    Value<DateTime?> fecha = const Value.absent(),
    Value<int?> notaSupuesta = const Value.absent(),
  }) => EvaluacionFila(
    id: id ?? this.id,
    materiaId: materiaId ?? this.materiaId,
    padreId: padreId.present ? padreId.value : this.padreId,
    nombre: nombre ?? this.nombre,
    porcentaje: porcentaje.present ? porcentaje.value : this.porcentaje,
    nota: nota.present ? nota.value : this.nota,
    fecha: fecha.present ? fecha.value : this.fecha,
    notaSupuesta: notaSupuesta.present ? notaSupuesta.value : this.notaSupuesta,
  );
  EvaluacionFila copyWithCompanion(EvaluacionesCompanion data) {
    return EvaluacionFila(
      id: data.id.present ? data.id.value : this.id,
      materiaId: data.materiaId.present ? data.materiaId.value : this.materiaId,
      padreId: data.padreId.present ? data.padreId.value : this.padreId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      porcentaje: data.porcentaje.present
          ? data.porcentaje.value
          : this.porcentaje,
      nota: data.nota.present ? data.nota.value : this.nota,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      notaSupuesta: data.notaSupuesta.present
          ? data.notaSupuesta.value
          : this.notaSupuesta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvaluacionFila(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('padreId: $padreId, ')
          ..write('nombre: $nombre, ')
          ..write('porcentaje: $porcentaje, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha, ')
          ..write('notaSupuesta: $notaSupuesta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    materiaId,
    padreId,
    nombre,
    porcentaje,
    nota,
    fecha,
    notaSupuesta,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvaluacionFila &&
          other.id == this.id &&
          other.materiaId == this.materiaId &&
          other.padreId == this.padreId &&
          other.nombre == this.nombre &&
          other.porcentaje == this.porcentaje &&
          other.nota == this.nota &&
          other.fecha == this.fecha &&
          other.notaSupuesta == this.notaSupuesta);
}

class EvaluacionesCompanion extends UpdateCompanion<EvaluacionFila> {
  final Value<int> id;
  final Value<int> materiaId;
  final Value<int?> padreId;
  final Value<String> nombre;
  final Value<int?> porcentaje;
  final Value<int?> nota;
  final Value<DateTime?> fecha;
  final Value<int?> notaSupuesta;
  const EvaluacionesCompanion({
    this.id = const Value.absent(),
    this.materiaId = const Value.absent(),
    this.padreId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.porcentaje = const Value.absent(),
    this.nota = const Value.absent(),
    this.fecha = const Value.absent(),
    this.notaSupuesta = const Value.absent(),
  });
  EvaluacionesCompanion.insert({
    this.id = const Value.absent(),
    required int materiaId,
    this.padreId = const Value.absent(),
    required String nombre,
    this.porcentaje = const Value.absent(),
    this.nota = const Value.absent(),
    this.fecha = const Value.absent(),
    this.notaSupuesta = const Value.absent(),
  }) : materiaId = Value(materiaId),
       nombre = Value(nombre);
  static Insertable<EvaluacionFila> custom({
    Expression<int>? id,
    Expression<int>? materiaId,
    Expression<int>? padreId,
    Expression<String>? nombre,
    Expression<int>? porcentaje,
    Expression<int>? nota,
    Expression<DateTime>? fecha,
    Expression<int>? notaSupuesta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materiaId != null) 'materia_id': materiaId,
      if (padreId != null) 'padre_id': padreId,
      if (nombre != null) 'nombre': nombre,
      if (porcentaje != null) 'porcentaje': porcentaje,
      if (nota != null) 'nota': nota,
      if (fecha != null) 'fecha': fecha,
      if (notaSupuesta != null) 'nota_supuesta': notaSupuesta,
    });
  }

  EvaluacionesCompanion copyWith({
    Value<int>? id,
    Value<int>? materiaId,
    Value<int?>? padreId,
    Value<String>? nombre,
    Value<int?>? porcentaje,
    Value<int?>? nota,
    Value<DateTime?>? fecha,
    Value<int?>? notaSupuesta,
  }) {
    return EvaluacionesCompanion(
      id: id ?? this.id,
      materiaId: materiaId ?? this.materiaId,
      padreId: padreId ?? this.padreId,
      nombre: nombre ?? this.nombre,
      porcentaje: porcentaje ?? this.porcentaje,
      nota: nota ?? this.nota,
      fecha: fecha ?? this.fecha,
      notaSupuesta: notaSupuesta ?? this.notaSupuesta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (materiaId.present) {
      map['materia_id'] = Variable<int>(materiaId.value);
    }
    if (padreId.present) {
      map['padre_id'] = Variable<int>(padreId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (porcentaje.present) {
      map['porcentaje'] = Variable<int>(porcentaje.value);
    }
    if (nota.present) {
      map['nota'] = Variable<int>(nota.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (notaSupuesta.present) {
      map['nota_supuesta'] = Variable<int>(notaSupuesta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvaluacionesCompanion(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('padreId: $padreId, ')
          ..write('nombre: $nombre, ')
          ..write('porcentaje: $porcentaje, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha, ')
          ..write('notaSupuesta: $notaSupuesta')
          ..write(')'))
        .toString();
  }
}

class $BloquesHorarioTable extends BloquesHorario
    with TableInfo<$BloquesHorarioTable, BloqueFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloquesHorarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _materiaIdMeta = const VerificationMeta(
    'materiaId',
  );
  @override
  late final GeneratedColumn<int> materiaId = GeneratedColumn<int>(
    'materia_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materias (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _diaMeta = const VerificationMeta('dia');
  @override
  late final GeneratedColumn<int> dia = GeneratedColumn<int>(
    'dia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  @override
  late final GeneratedColumn<int> inicio = GeneratedColumn<int>(
    'inicio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<int> fin = GeneratedColumn<int>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salonMeta = const VerificationMeta('salon');
  @override
  late final GeneratedColumn<String> salon = GeneratedColumn<String>(
    'salon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    materiaId,
    dia,
    inicio,
    fin,
    salon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bloques_horario';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloqueFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('materia_id')) {
      context.handle(
        _materiaIdMeta,
        materiaId.isAcceptableOrUnknown(data['materia_id']!, _materiaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materiaIdMeta);
    }
    if (data.containsKey('dia')) {
      context.handle(
        _diaMeta,
        dia.isAcceptableOrUnknown(data['dia']!, _diaMeta),
      );
    } else if (isInserting) {
      context.missing(_diaMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(
        _inicioMeta,
        inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta),
      );
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('salon')) {
      context.handle(
        _salonMeta,
        salon.isAcceptableOrUnknown(data['salon']!, _salonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloqueFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloqueFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      materiaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}materia_id'],
      )!,
      dia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia'],
      )!,
      inicio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inicio'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fin'],
      )!,
      salon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salon'],
      )!,
    );
  }

  @override
  $BloquesHorarioTable createAlias(String alias) {
    return $BloquesHorarioTable(attachedDatabase, alias);
  }
}

class BloqueFila extends DataClass implements Insertable<BloqueFila> {
  final int id;
  final int materiaId;
  final int dia;
  final int inicio;
  final int fin;
  final String salon;
  const BloqueFila({
    required this.id,
    required this.materiaId,
    required this.dia,
    required this.inicio,
    required this.fin,
    required this.salon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['materia_id'] = Variable<int>(materiaId);
    map['dia'] = Variable<int>(dia);
    map['inicio'] = Variable<int>(inicio);
    map['fin'] = Variable<int>(fin);
    map['salon'] = Variable<String>(salon);
    return map;
  }

  BloquesHorarioCompanion toCompanion(bool nullToAbsent) {
    return BloquesHorarioCompanion(
      id: Value(id),
      materiaId: Value(materiaId),
      dia: Value(dia),
      inicio: Value(inicio),
      fin: Value(fin),
      salon: Value(salon),
    );
  }

  factory BloqueFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloqueFila(
      id: serializer.fromJson<int>(json['id']),
      materiaId: serializer.fromJson<int>(json['materiaId']),
      dia: serializer.fromJson<int>(json['dia']),
      inicio: serializer.fromJson<int>(json['inicio']),
      fin: serializer.fromJson<int>(json['fin']),
      salon: serializer.fromJson<String>(json['salon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'materiaId': serializer.toJson<int>(materiaId),
      'dia': serializer.toJson<int>(dia),
      'inicio': serializer.toJson<int>(inicio),
      'fin': serializer.toJson<int>(fin),
      'salon': serializer.toJson<String>(salon),
    };
  }

  BloqueFila copyWith({
    int? id,
    int? materiaId,
    int? dia,
    int? inicio,
    int? fin,
    String? salon,
  }) => BloqueFila(
    id: id ?? this.id,
    materiaId: materiaId ?? this.materiaId,
    dia: dia ?? this.dia,
    inicio: inicio ?? this.inicio,
    fin: fin ?? this.fin,
    salon: salon ?? this.salon,
  );
  BloqueFila copyWithCompanion(BloquesHorarioCompanion data) {
    return BloqueFila(
      id: data.id.present ? data.id.value : this.id,
      materiaId: data.materiaId.present ? data.materiaId.value : this.materiaId,
      dia: data.dia.present ? data.dia.value : this.dia,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      fin: data.fin.present ? data.fin.value : this.fin,
      salon: data.salon.present ? data.salon.value : this.salon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloqueFila(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('dia: $dia, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('salon: $salon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, materiaId, dia, inicio, fin, salon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloqueFila &&
          other.id == this.id &&
          other.materiaId == this.materiaId &&
          other.dia == this.dia &&
          other.inicio == this.inicio &&
          other.fin == this.fin &&
          other.salon == this.salon);
}

class BloquesHorarioCompanion extends UpdateCompanion<BloqueFila> {
  final Value<int> id;
  final Value<int> materiaId;
  final Value<int> dia;
  final Value<int> inicio;
  final Value<int> fin;
  final Value<String> salon;
  const BloquesHorarioCompanion({
    this.id = const Value.absent(),
    this.materiaId = const Value.absent(),
    this.dia = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fin = const Value.absent(),
    this.salon = const Value.absent(),
  });
  BloquesHorarioCompanion.insert({
    this.id = const Value.absent(),
    required int materiaId,
    required int dia,
    required int inicio,
    required int fin,
    this.salon = const Value.absent(),
  }) : materiaId = Value(materiaId),
       dia = Value(dia),
       inicio = Value(inicio),
       fin = Value(fin);
  static Insertable<BloqueFila> custom({
    Expression<int>? id,
    Expression<int>? materiaId,
    Expression<int>? dia,
    Expression<int>? inicio,
    Expression<int>? fin,
    Expression<String>? salon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materiaId != null) 'materia_id': materiaId,
      if (dia != null) 'dia': dia,
      if (inicio != null) 'inicio': inicio,
      if (fin != null) 'fin': fin,
      if (salon != null) 'salon': salon,
    });
  }

  BloquesHorarioCompanion copyWith({
    Value<int>? id,
    Value<int>? materiaId,
    Value<int>? dia,
    Value<int>? inicio,
    Value<int>? fin,
    Value<String>? salon,
  }) {
    return BloquesHorarioCompanion(
      id: id ?? this.id,
      materiaId: materiaId ?? this.materiaId,
      dia: dia ?? this.dia,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      salon: salon ?? this.salon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (materiaId.present) {
      map['materia_id'] = Variable<int>(materiaId.value);
    }
    if (dia.present) {
      map['dia'] = Variable<int>(dia.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<int>(inicio.value);
    }
    if (fin.present) {
      map['fin'] = Variable<int>(fin.value);
    }
    if (salon.present) {
      map['salon'] = Variable<String>(salon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloquesHorarioCompanion(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('dia: $dia, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('salon: $salon')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $PerfilesTable perfiles = $PerfilesTable(this);
  late final $SemestresTable semestres = $SemestresTable(this);
  late final $MateriasTable materias = $MateriasTable(this);
  late final $EvaluacionesTable evaluaciones = $EvaluacionesTable(this);
  late final $BloquesHorarioTable bloquesHorario = $BloquesHorarioTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    perfiles,
    semestres,
    materias,
    evaluaciones,
    bloquesHorario,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'semestres',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('materias', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'materias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evaluaciones', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'materias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bloques_horario', kind: UpdateKind.delete)],
    ),
  ]);
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
typedef $$SemestresTableCreateCompanionBuilder = SemestresCompanion Function({
  Value<int> id,
  required String nombre,
  Value<DateTime?> fechaInicio,
  Value<DateTime?> fechaFin,
  Value<bool> activo,
});
typedef $$SemestresTableUpdateCompanionBuilder = SemestresCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<DateTime?> fechaInicio,
  Value<DateTime?> fechaFin,
  Value<bool> activo,
});

final class $$SemestresTableReferences
    extends BaseReferences<_$BaseDatos, $SemestresTable, SemestreFila> {
  $$SemestresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MateriasTable, List<MateriaFila>>
  _materiasRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.materias,
    aliasName: 'semestres__id__materias__semestre_id',
  );

  $$MateriasTableProcessedTableManager get materiasRefs {
    final manager = $$MateriasTableTableManager(
      $_db,
      $_db.materias,
    ).filter((f) => f.semestreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materiasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SemestresTableFilterComposer
    extends Composer<_$BaseDatos, $SemestresTable> {
  $$SemestresTableFilterComposer({
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

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> materiasRefs(
    Expression<bool> Function($$MateriasTableFilterComposer f) f,
  ) {
    final $$MateriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.semestreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableFilterComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SemestresTableOrderingComposer
    extends Composer<_$BaseDatos, $SemestresTable> {
  $$SemestresTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SemestresTableAnnotationComposer
    extends Composer<_$BaseDatos, $SemestresTable> {
  $$SemestresTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> materiasRefs<T extends Object>(
    Expression<T> Function($$MateriasTableAnnotationComposer a) f,
  ) {
    final $$MateriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.semestreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableAnnotationComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SemestresTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $SemestresTable,
          SemestreFila,
          $$SemestresTableFilterComposer,
          $$SemestresTableOrderingComposer,
          $$SemestresTableAnnotationComposer,
          $$SemestresTableCreateCompanionBuilder,
          $$SemestresTableUpdateCompanionBuilder,
          (SemestreFila, $$SemestresTableReferences),
          SemestreFila,
          PrefetchHooks Function({bool materiasRefs})
        > {
  $$SemestresTableTableManager(_$BaseDatos db, $SemestresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SemestresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SemestresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SemestresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => SemestresCompanion(
                id: id,
                nombre: nombre,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => SemestresCompanion.insert(
                id: id,
                nombre: nombre,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SemestresTable, SemestreFila>(table),
                  $$SemestresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materiasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (materiasRefs) db.materias],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (materiasRefs)
                    await $_getPrefetchedDataByColumns<
                      SemestreFila,
                      $SemestresTable,
                      MateriaFila,
                      $MateriasTable
                    >(
                      currentTable: table,
                      referencedTable: $$SemestresTableReferences
                          ._materiasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SemestresTableReferences(
                            db,
                            table,
                            p0,
                          ).materiasRefs,
                      currentColumn: 'id',
                      referencedColumn: 'semestre_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SemestresTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $SemestresTable,
      SemestreFila,
      $$SemestresTableFilterComposer,
      $$SemestresTableOrderingComposer,
      $$SemestresTableAnnotationComposer,
      $$SemestresTableCreateCompanionBuilder,
      $$SemestresTableUpdateCompanionBuilder,
      (SemestreFila, $$SemestresTableReferences),
      SemestreFila,
      PrefetchHooks Function({bool materiasRefs})
    >;
typedef $$MateriasTableCreateCompanionBuilder = MateriasCompanion Function({
  Value<int> id,
  required int semestreId,
  required String nombre,
  Value<String> docente,
  required int creditos,
  required int color,
  required EstadoMateria estado,
  Value<DateTime?> fechaCancelacion,
  Value<int?> notaFinal,
});
typedef $$MateriasTableUpdateCompanionBuilder = MateriasCompanion Function({
  Value<int> id,
  Value<int> semestreId,
  Value<String> nombre,
  Value<String> docente,
  Value<int> creditos,
  Value<int> color,
  Value<EstadoMateria> estado,
  Value<DateTime?> fechaCancelacion,
  Value<int?> notaFinal,
});

final class $$MateriasTableReferences
    extends BaseReferences<_$BaseDatos, $MateriasTable, MateriaFila> {
  $$MateriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SemestresTable _semestreIdTable(_$BaseDatos db) =>
      db.semestres.createAlias('materias__semestre_id__semestres__id');

  $$SemestresTableProcessedTableManager get semestreId {
    final $_column = $_itemColumn<int>('semestre_id')!;

    final manager = $$SemestresTableTableManager(
      $_db,
      $_db.semestres,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_semestreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EvaluacionesTable, List<EvaluacionFila>>
  _evaluacionesRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.evaluaciones,
    aliasName: 'materias__id__evaluaciones__materia_id',
  );

  $$EvaluacionesTableProcessedTableManager get evaluacionesRefs {
    final manager = $$EvaluacionesTableTableManager(
      $_db,
      $_db.evaluaciones,
    ).filter((f) => f.materiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_evaluacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BloquesHorarioTable, List<BloqueFila>>
  _bloquesHorarioRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.bloquesHorario,
    aliasName: 'materias__id__bloques_horario__materia_id',
  );

  $$BloquesHorarioTableProcessedTableManager get bloquesHorarioRefs {
    final manager = $$BloquesHorarioTableTableManager(
      $_db,
      $_db.bloquesHorario,
    ).filter((f) => f.materiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bloquesHorarioRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MateriasTableFilterComposer
    extends Composer<_$BaseDatos, $MateriasTable> {
  $$MateriasTableFilterComposer({
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

  ColumnFilters<String> get docente => $composableBuilder(
    column: $table.docente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditos => $composableBuilder(
    column: $table.creditos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoMateria, EstadoMateria, String>
  get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fechaCancelacion => $composableBuilder(
    column: $table.fechaCancelacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaFinal => $composableBuilder(
    column: $table.notaFinal,
    builder: (column) => ColumnFilters(column),
  );

  $$SemestresTableFilterComposer get semestreId {
    final $$SemestresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semestreId,
      referencedTable: $db.semestres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemestresTableFilterComposer(
            $db: $db,
            $table: $db.semestres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> evaluacionesRefs(
    Expression<bool> Function($$EvaluacionesTableFilterComposer f) f,
  ) {
    final $$EvaluacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluaciones,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionesTableFilterComposer(
            $db: $db,
            $table: $db.evaluaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bloquesHorarioRefs(
    Expression<bool> Function($$BloquesHorarioTableFilterComposer f) f,
  ) {
    final $$BloquesHorarioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bloquesHorario,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloquesHorarioTableFilterComposer(
            $db: $db,
            $table: $db.bloquesHorario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MateriasTableOrderingComposer
    extends Composer<_$BaseDatos, $MateriasTable> {
  $$MateriasTableOrderingComposer({
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

  ColumnOrderings<String> get docente => $composableBuilder(
    column: $table.docente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditos => $composableBuilder(
    column: $table.creditos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCancelacion => $composableBuilder(
    column: $table.fechaCancelacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaFinal => $composableBuilder(
    column: $table.notaFinal,
    builder: (column) => ColumnOrderings(column),
  );

  $$SemestresTableOrderingComposer get semestreId {
    final $$SemestresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semestreId,
      referencedTable: $db.semestres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemestresTableOrderingComposer(
            $db: $db,
            $table: $db.semestres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MateriasTableAnnotationComposer
    extends Composer<_$BaseDatos, $MateriasTable> {
  $$MateriasTableAnnotationComposer({
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

  GeneratedColumn<String> get docente =>
      $composableBuilder(column: $table.docente, builder: (column) => column);

  GeneratedColumn<int> get creditos =>
      $composableBuilder(column: $table.creditos, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoMateria, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCancelacion => $composableBuilder(
    column: $table.fechaCancelacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notaFinal =>
      $composableBuilder(column: $table.notaFinal, builder: (column) => column);

  $$SemestresTableAnnotationComposer get semestreId {
    final $$SemestresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semestreId,
      referencedTable: $db.semestres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemestresTableAnnotationComposer(
            $db: $db,
            $table: $db.semestres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> evaluacionesRefs<T extends Object>(
    Expression<T> Function($$EvaluacionesTableAnnotationComposer a) f,
  ) {
    final $$EvaluacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluaciones,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.evaluaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bloquesHorarioRefs<T extends Object>(
    Expression<T> Function($$BloquesHorarioTableAnnotationComposer a) f,
  ) {
    final $$BloquesHorarioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bloquesHorario,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloquesHorarioTableAnnotationComposer(
            $db: $db,
            $table: $db.bloquesHorario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MateriasTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $MateriasTable,
          MateriaFila,
          $$MateriasTableFilterComposer,
          $$MateriasTableOrderingComposer,
          $$MateriasTableAnnotationComposer,
          $$MateriasTableCreateCompanionBuilder,
          $$MateriasTableUpdateCompanionBuilder,
          (MateriaFila, $$MateriasTableReferences),
          MateriaFila,
          PrefetchHooks Function({
            bool semestreId,
            bool evaluacionesRefs,
            bool bloquesHorarioRefs,
          })
        > {
  $$MateriasTableTableManager(_$BaseDatos db, $MateriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MateriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MateriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MateriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> semestreId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> docente = const Value.absent(),
                Value<int> creditos = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<EstadoMateria> estado = const Value.absent(),
                Value<DateTime?> fechaCancelacion = const Value.absent(),
                Value<int?> notaFinal = const Value.absent(),
              }) => MateriasCompanion(
                id: id,
                semestreId: semestreId,
                nombre: nombre,
                docente: docente,
                creditos: creditos,
                color: color,
                estado: estado,
                fechaCancelacion: fechaCancelacion,
                notaFinal: notaFinal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int semestreId,
                required String nombre,
                Value<String> docente = const Value.absent(),
                required int creditos,
                required int color,
                required EstadoMateria estado,
                Value<DateTime?> fechaCancelacion = const Value.absent(),
                Value<int?> notaFinal = const Value.absent(),
              }) => MateriasCompanion.insert(
                id: id,
                semestreId: semestreId,
                nombre: nombre,
                docente: docente,
                creditos: creditos,
                color: color,
                estado: estado,
                fechaCancelacion: fechaCancelacion,
                notaFinal: notaFinal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MateriasTable, MateriaFila>(table),
                  $$MateriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                semestreId = false,
                evaluacionesRefs = false,
                bloquesHorarioRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (evaluacionesRefs) db.evaluaciones,
                    if (bloquesHorarioRefs) db.bloquesHorario,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (semestreId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.semestreId,
                            referencedTable: $$MateriasTableReferences
                                ._semestreIdTable(db),
                            referencedColumn: $$MateriasTableReferences
                                ._semestreIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (evaluacionesRefs)
                        await $_getPrefetchedDataByColumns<
                          MateriaFila,
                          $MateriasTable,
                          EvaluacionFila,
                          $EvaluacionesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MateriasTableReferences
                              ._evaluacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MateriasTableReferences(
                                db,
                                table,
                                p0,
                              ).evaluacionesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'materia_id',
                          typedResults: items,
                        ),
                      if (bloquesHorarioRefs)
                        await $_getPrefetchedDataByColumns<
                          MateriaFila,
                          $MateriasTable,
                          BloqueFila,
                          $BloquesHorarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$MateriasTableReferences
                              ._bloquesHorarioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MateriasTableReferences(
                                db,
                                table,
                                p0,
                              ).bloquesHorarioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'materia_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MateriasTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $MateriasTable,
      MateriaFila,
      $$MateriasTableFilterComposer,
      $$MateriasTableOrderingComposer,
      $$MateriasTableAnnotationComposer,
      $$MateriasTableCreateCompanionBuilder,
      $$MateriasTableUpdateCompanionBuilder,
      (MateriaFila, $$MateriasTableReferences),
      MateriaFila,
      PrefetchHooks Function({
        bool semestreId,
        bool evaluacionesRefs,
        bool bloquesHorarioRefs,
      })
    >;
typedef $$EvaluacionesTableCreateCompanionBuilder =
    EvaluacionesCompanion Function({
      Value<int> id,
      required int materiaId,
      Value<int?> padreId,
      required String nombre,
      Value<int?> porcentaje,
      Value<int?> nota,
      Value<DateTime?> fecha,
      Value<int?> notaSupuesta,
    });
typedef $$EvaluacionesTableUpdateCompanionBuilder =
    EvaluacionesCompanion Function({
      Value<int> id,
      Value<int> materiaId,
      Value<int?> padreId,
      Value<String> nombre,
      Value<int?> porcentaje,
      Value<int?> nota,
      Value<DateTime?> fecha,
      Value<int?> notaSupuesta,
    });

final class $$EvaluacionesTableReferences
    extends BaseReferences<_$BaseDatos, $EvaluacionesTable, EvaluacionFila> {
  $$EvaluacionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MateriasTable _materiaIdTable(_$BaseDatos db) =>
      db.materias.createAlias('evaluaciones__materia_id__materias__id');

  $$MateriasTableProcessedTableManager get materiaId {
    final $_column = $_itemColumn<int>('materia_id')!;

    final manager = $$MateriasTableTableManager(
      $_db,
      $_db.materias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EvaluacionesTableFilterComposer
    extends Composer<_$BaseDatos, $EvaluacionesTable> {
  $$EvaluacionesTableFilterComposer({
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

  ColumnFilters<int> get padreId => $composableBuilder(
    column: $table.padreId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcentaje => $composableBuilder(
    column: $table.porcentaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaSupuesta => $composableBuilder(
    column: $table.notaSupuesta,
    builder: (column) => ColumnFilters(column),
  );

  $$MateriasTableFilterComposer get materiaId {
    final $$MateriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableFilterComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvaluacionesTableOrderingComposer
    extends Composer<_$BaseDatos, $EvaluacionesTable> {
  $$EvaluacionesTableOrderingComposer({
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

  ColumnOrderings<int> get padreId => $composableBuilder(
    column: $table.padreId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcentaje => $composableBuilder(
    column: $table.porcentaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaSupuesta => $composableBuilder(
    column: $table.notaSupuesta,
    builder: (column) => ColumnOrderings(column),
  );

  $$MateriasTableOrderingComposer get materiaId {
    final $$MateriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableOrderingComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvaluacionesTableAnnotationComposer
    extends Composer<_$BaseDatos, $EvaluacionesTable> {
  $$EvaluacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get padreId =>
      $composableBuilder(column: $table.padreId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get porcentaje => $composableBuilder(
    column: $table.porcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get notaSupuesta => $composableBuilder(
    column: $table.notaSupuesta,
    builder: (column) => column,
  );

  $$MateriasTableAnnotationComposer get materiaId {
    final $$MateriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableAnnotationComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvaluacionesTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $EvaluacionesTable,
          EvaluacionFila,
          $$EvaluacionesTableFilterComposer,
          $$EvaluacionesTableOrderingComposer,
          $$EvaluacionesTableAnnotationComposer,
          $$EvaluacionesTableCreateCompanionBuilder,
          $$EvaluacionesTableUpdateCompanionBuilder,
          (EvaluacionFila, $$EvaluacionesTableReferences),
          EvaluacionFila,
          PrefetchHooks Function({bool materiaId})
        > {
  $$EvaluacionesTableTableManager(_$BaseDatos db, $EvaluacionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvaluacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvaluacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvaluacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> materiaId = const Value.absent(),
                Value<int?> padreId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int?> porcentaje = const Value.absent(),
                Value<int?> nota = const Value.absent(),
                Value<DateTime?> fecha = const Value.absent(),
                Value<int?> notaSupuesta = const Value.absent(),
              }) => EvaluacionesCompanion(
                id: id,
                materiaId: materiaId,
                padreId: padreId,
                nombre: nombre,
                porcentaje: porcentaje,
                nota: nota,
                fecha: fecha,
                notaSupuesta: notaSupuesta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int materiaId,
                Value<int?> padreId = const Value.absent(),
                required String nombre,
                Value<int?> porcentaje = const Value.absent(),
                Value<int?> nota = const Value.absent(),
                Value<DateTime?> fecha = const Value.absent(),
                Value<int?> notaSupuesta = const Value.absent(),
              }) => EvaluacionesCompanion.insert(
                id: id,
                materiaId: materiaId,
                padreId: padreId,
                nombre: nombre,
                porcentaje: porcentaje,
                nota: nota,
                fecha: fecha,
                notaSupuesta: notaSupuesta,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EvaluacionesTable, EvaluacionFila>(table),
                  $$EvaluacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materiaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (materiaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.materiaId,
                        referencedTable: $$EvaluacionesTableReferences
                            ._materiaIdTable(db),
                        referencedColumn: $$EvaluacionesTableReferences
                            ._materiaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EvaluacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $EvaluacionesTable,
      EvaluacionFila,
      $$EvaluacionesTableFilterComposer,
      $$EvaluacionesTableOrderingComposer,
      $$EvaluacionesTableAnnotationComposer,
      $$EvaluacionesTableCreateCompanionBuilder,
      $$EvaluacionesTableUpdateCompanionBuilder,
      (EvaluacionFila, $$EvaluacionesTableReferences),
      EvaluacionFila,
      PrefetchHooks Function({bool materiaId})
    >;
typedef $$BloquesHorarioTableCreateCompanionBuilder =
    BloquesHorarioCompanion Function({
      Value<int> id,
      required int materiaId,
      required int dia,
      required int inicio,
      required int fin,
      Value<String> salon,
    });
typedef $$BloquesHorarioTableUpdateCompanionBuilder =
    BloquesHorarioCompanion Function({
      Value<int> id,
      Value<int> materiaId,
      Value<int> dia,
      Value<int> inicio,
      Value<int> fin,
      Value<String> salon,
    });

final class $$BloquesHorarioTableReferences
    extends BaseReferences<_$BaseDatos, $BloquesHorarioTable, BloqueFila> {
  $$BloquesHorarioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MateriasTable _materiaIdTable(_$BaseDatos db) =>
      db.materias.createAlias('bloques_horario__materia_id__materias__id');

  $$MateriasTableProcessedTableManager get materiaId {
    final $_column = $_itemColumn<int>('materia_id')!;

    final manager = $$MateriasTableTableManager(
      $_db,
      $_db.materias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BloquesHorarioTableFilterComposer
    extends Composer<_$BaseDatos, $BloquesHorarioTable> {
  $$BloquesHorarioTableFilterComposer({
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

  ColumnFilters<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salon => $composableBuilder(
    column: $table.salon,
    builder: (column) => ColumnFilters(column),
  );

  $$MateriasTableFilterComposer get materiaId {
    final $$MateriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableFilterComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloquesHorarioTableOrderingComposer
    extends Composer<_$BaseDatos, $BloquesHorarioTable> {
  $$BloquesHorarioTableOrderingComposer({
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

  ColumnOrderings<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salon => $composableBuilder(
    column: $table.salon,
    builder: (column) => ColumnOrderings(column),
  );

  $$MateriasTableOrderingComposer get materiaId {
    final $$MateriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableOrderingComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloquesHorarioTableAnnotationComposer
    extends Composer<_$BaseDatos, $BloquesHorarioTable> {
  $$BloquesHorarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dia =>
      $composableBuilder(column: $table.dia, builder: (column) => column);

  GeneratedColumn<int> get inicio =>
      $composableBuilder(column: $table.inicio, builder: (column) => column);

  GeneratedColumn<int> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<String> get salon =>
      $composableBuilder(column: $table.salon, builder: (column) => column);

  $$MateriasTableAnnotationComposer get materiaId {
    final $$MateriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableAnnotationComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BloquesHorarioTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $BloquesHorarioTable,
          BloqueFila,
          $$BloquesHorarioTableFilterComposer,
          $$BloquesHorarioTableOrderingComposer,
          $$BloquesHorarioTableAnnotationComposer,
          $$BloquesHorarioTableCreateCompanionBuilder,
          $$BloquesHorarioTableUpdateCompanionBuilder,
          (BloqueFila, $$BloquesHorarioTableReferences),
          BloqueFila,
          PrefetchHooks Function({bool materiaId})
        > {
  $$BloquesHorarioTableTableManager(_$BaseDatos db, $BloquesHorarioTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloquesHorarioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloquesHorarioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BloquesHorarioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> materiaId = const Value.absent(),
                Value<int> dia = const Value.absent(),
                Value<int> inicio = const Value.absent(),
                Value<int> fin = const Value.absent(),
                Value<String> salon = const Value.absent(),
              }) => BloquesHorarioCompanion(
                id: id,
                materiaId: materiaId,
                dia: dia,
                inicio: inicio,
                fin: fin,
                salon: salon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int materiaId,
                required int dia,
                required int inicio,
                required int fin,
                Value<String> salon = const Value.absent(),
              }) => BloquesHorarioCompanion.insert(
                id: id,
                materiaId: materiaId,
                dia: dia,
                inicio: inicio,
                fin: fin,
                salon: salon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BloquesHorarioTable, BloqueFila>(table),
                  $$BloquesHorarioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materiaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (materiaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.materiaId,
                        referencedTable: $$BloquesHorarioTableReferences
                            ._materiaIdTable(db),
                        referencedColumn: $$BloquesHorarioTableReferences
                            ._materiaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BloquesHorarioTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $BloquesHorarioTable,
      BloqueFila,
      $$BloquesHorarioTableFilterComposer,
      $$BloquesHorarioTableOrderingComposer,
      $$BloquesHorarioTableAnnotationComposer,
      $$BloquesHorarioTableCreateCompanionBuilder,
      $$BloquesHorarioTableUpdateCompanionBuilder,
      (BloqueFila, $$BloquesHorarioTableReferences),
      BloqueFila,
      PrefetchHooks Function({bool materiaId})
    >;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$PerfilesTableTableManager get perfiles =>
      $$PerfilesTableTableManager(_db, _db.perfiles);
  $$SemestresTableTableManager get semestres =>
      $$SemestresTableTableManager(_db, _db.semestres);
  $$MateriasTableTableManager get materias =>
      $$MateriasTableTableManager(_db, _db.materias);
  $$EvaluacionesTableTableManager get evaluaciones =>
      $$EvaluacionesTableTableManager(_db, _db.evaluaciones);
  $$BloquesHorarioTableTableManager get bloquesHorario =>
      $$BloquesHorarioTableTableManager(_db, _db.bloquesHorario);
}
