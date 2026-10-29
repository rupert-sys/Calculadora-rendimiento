// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_datos.dart';

// ignore_for_file: type=lint
class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, MovimientoFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<int> tipo = GeneratedColumn<int>(
      'tipo', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoCentavosMeta =
      const VerificationMeta('montoCentavos');
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
      'monto_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<String> categoriaId = GeneratedColumn<String>(
      'categoria_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frecuenciaMeta =
      const VerificationMeta('frecuencia');
  @override
  late final GeneratedColumn<int> frecuencia = GeneratedColumn<int>(
      'frecuencia', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaInicioMeta =
      const VerificationMeta('fechaInicio');
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
      'fecha_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fechaFinMeta =
      const VerificationMeta('fechaFin');
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
      'fecha_fin', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tipo,
        descripcion,
        montoCentavos,
        categoriaId,
        frecuencia,
        fechaInicio,
        fechaFin
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(Insertable<MovimientoFila> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
          _montoCentavosMeta,
          montoCentavos.isAcceptableOrUnknown(
              data['monto_centavos']!, _montoCentavosMeta));
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
          _frecuenciaMeta,
          frecuencia.isAcceptableOrUnknown(
              data['frecuencia']!, _frecuenciaMeta));
    } else if (isInserting) {
      context.missing(_frecuenciaMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
          _fechaInicioMeta,
          fechaInicio.isAcceptableOrUnknown(
              data['fecha_inicio']!, _fechaInicioMeta));
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(_fechaFinMeta,
          fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoFila(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      montoCentavos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}monto_centavos'])!,
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria_id'])!,
      frecuencia: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frecuencia'])!,
      fechaInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_inicio'])!,
      fechaFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_fin']),
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }
}

class MovimientoFila extends DataClass implements Insertable<MovimientoFila> {
  final String id;
  final int tipo;
  final String descripcion;
  final int montoCentavos;
  final String categoriaId;
  final int frecuencia;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  const MovimientoFila(
      {required this.id,
      required this.tipo,
      required this.descripcion,
      required this.montoCentavos,
      required this.categoriaId,
      required this.frecuencia,
      required this.fechaInicio,
      this.fechaFin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tipo'] = Variable<int>(tipo);
    map['descripcion'] = Variable<String>(descripcion);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['categoria_id'] = Variable<String>(categoriaId);
    map['frecuencia'] = Variable<int>(frecuencia);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      tipo: Value(tipo),
      descripcion: Value(descripcion),
      montoCentavos: Value(montoCentavos),
      categoriaId: Value(categoriaId),
      frecuencia: Value(frecuencia),
      fechaInicio: Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
    );
  }

  factory MovimientoFila.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoFila(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<int>(json['tipo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      categoriaId: serializer.fromJson<String>(json['categoriaId']),
      frecuencia: serializer.fromJson<int>(json['frecuencia']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<int>(tipo),
      'descripcion': serializer.toJson<String>(descripcion),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'categoriaId': serializer.toJson<String>(categoriaId),
      'frecuencia': serializer.toJson<int>(frecuencia),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
    };
  }

  MovimientoFila copyWith(
          {String? id,
          int? tipo,
          String? descripcion,
          int? montoCentavos,
          String? categoriaId,
          int? frecuencia,
          DateTime? fechaInicio,
          Value<DateTime?> fechaFin = const Value.absent()}) =>
      MovimientoFila(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        descripcion: descripcion ?? this.descripcion,
        montoCentavos: montoCentavos ?? this.montoCentavos,
        categoriaId: categoriaId ?? this.categoriaId,
        frecuencia: frecuencia ?? this.frecuencia,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
      );
  MovimientoFila copyWithCompanion(MovimientosCompanion data) {
    return MovimientoFila(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      frecuencia:
          data.frecuencia.present ? data.frecuencia.value : this.frecuencia,
      fechaInicio:
          data.fechaInicio.present ? data.fechaInicio.value : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoFila(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('descripcion: $descripcion, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tipo, descripcion, montoCentavos,
      categoriaId, frecuencia, fechaInicio, fechaFin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoFila &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.descripcion == this.descripcion &&
          other.montoCentavos == this.montoCentavos &&
          other.categoriaId == this.categoriaId &&
          other.frecuencia == this.frecuencia &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin);
}

class MovimientosCompanion extends UpdateCompanion<MovimientoFila> {
  final Value<String> id;
  final Value<int> tipo;
  final Value<String> descripcion;
  final Value<int> montoCentavos;
  final Value<String> categoriaId;
  final Value<int> frecuencia;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<int> rowid;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovimientosCompanion.insert({
    required String id,
    required int tipo,
    required String descripcion,
    required int montoCentavos,
    required String categoriaId,
    required int frecuencia,
    required DateTime fechaInicio,
    this.fechaFin = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tipo = Value(tipo),
        descripcion = Value(descripcion),
        montoCentavos = Value(montoCentavos),
        categoriaId = Value(categoriaId),
        frecuencia = Value(frecuencia),
        fechaInicio = Value(fechaInicio);
  static Insertable<MovimientoFila> custom({
    Expression<String>? id,
    Expression<int>? tipo,
    Expression<String>? descripcion,
    Expression<int>? montoCentavos,
    Expression<String>? categoriaId,
    Expression<int>? frecuencia,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (descripcion != null) 'descripcion': descripcion,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovimientosCompanion copyWith(
      {Value<String>? id,
      Value<int>? tipo,
      Value<String>? descripcion,
      Value<int>? montoCentavos,
      Value<String>? categoriaId,
      Value<int>? frecuencia,
      Value<DateTime>? fechaInicio,
      Value<DateTime?>? fechaFin,
      Value<int>? rowid}) {
    return MovimientosCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      categoriaId: categoriaId ?? this.categoriaId,
      frecuencia: frecuencia ?? this.frecuencia,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(tipo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<String>(categoriaId.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<int>(frecuencia.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('descripcion: $descripcion, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [movimientos];
}

typedef $$MovimientosTableCreateCompanionBuilder = MovimientosCompanion
    Function({
  required String id,
  required int tipo,
  required String descripcion,
  required int montoCentavos,
  required String categoriaId,
  required int frecuencia,
  required DateTime fechaInicio,
  Value<DateTime?> fechaFin,
  Value<int> rowid,
});
typedef $$MovimientosTableUpdateCompanionBuilder = MovimientosCompanion
    Function({
  Value<String> id,
  Value<int> tipo,
  Value<String> descripcion,
  Value<int> montoCentavos,
  Value<String> categoriaId,
  Value<int> frecuencia,
  Value<DateTime> fechaInicio,
  Value<DateTime?> fechaFin,
  Value<int> rowid,
});

class $$MovimientosTableFilterComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get montoCentavos => $composableBuilder(
      column: $table.montoCentavos, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frecuencia => $composableBuilder(
      column: $table.frecuencia, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnFilters(column));
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
      column: $table.montoCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frecuencia => $composableBuilder(
      column: $table.frecuencia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnOrderings(column));
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
      column: $table.montoCentavos, builder: (column) => column);

  GeneratedColumn<String> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => column);

  GeneratedColumn<int> get frecuencia => $composableBuilder(
      column: $table.frecuencia, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);
}

class $$MovimientosTableTableManager extends RootTableManager<
    _$BaseDatos,
    $MovimientosTable,
    MovimientoFila,
    $$MovimientosTableFilterComposer,
    $$MovimientosTableOrderingComposer,
    $$MovimientosTableAnnotationComposer,
    $$MovimientosTableCreateCompanionBuilder,
    $$MovimientosTableUpdateCompanionBuilder,
    (
      MovimientoFila,
      BaseReferences<_$BaseDatos, $MovimientosTable, MovimientoFila>
    ),
    MovimientoFila,
    PrefetchHooks Function()> {
  $$MovimientosTableTableManager(_$BaseDatos db, $MovimientosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> tipo = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<int> montoCentavos = const Value.absent(),
            Value<String> categoriaId = const Value.absent(),
            Value<int> frecuencia = const Value.absent(),
            Value<DateTime> fechaInicio = const Value.absent(),
            Value<DateTime?> fechaFin = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MovimientosCompanion(
            id: id,
            tipo: tipo,
            descripcion: descripcion,
            montoCentavos: montoCentavos,
            categoriaId: categoriaId,
            frecuencia: frecuencia,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int tipo,
            required String descripcion,
            required int montoCentavos,
            required String categoriaId,
            required int frecuencia,
            required DateTime fechaInicio,
            Value<DateTime?> fechaFin = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MovimientosCompanion.insert(
            id: id,
            tipo: tipo,
            descripcion: descripcion,
            montoCentavos: montoCentavos,
            categoriaId: categoriaId,
            frecuencia: frecuencia,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MovimientosTable, MovimientoFila>(table),
                    BaseReferences<_$BaseDatos, $MovimientosTable,
                        MovimientoFila>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MovimientosTableProcessedTableManager = ProcessedTableManager<
    _$BaseDatos,
    $MovimientosTable,
    MovimientoFila,
    $$MovimientosTableFilterComposer,
    $$MovimientosTableOrderingComposer,
    $$MovimientosTableAnnotationComposer,
    $$MovimientosTableCreateCompanionBuilder,
    $$MovimientosTableUpdateCompanionBuilder,
    (
      MovimientoFila,
      BaseReferences<_$BaseDatos, $MovimientosTable, MovimientoFila>
    ),
    MovimientoFila,
    PrefetchHooks Function()>;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
}
