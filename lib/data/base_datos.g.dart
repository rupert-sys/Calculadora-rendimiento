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
  static const VerificationMeta _cuentaIdMeta =
      const VerificationMeta('cuentaId');
  @override
  late final GeneratedColumn<String> cuentaId = GeneratedColumn<String>(
      'cuenta_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tipo,
        descripcion,
        montoCentavos,
        categoriaId,
        frecuencia,
        fechaInicio,
        fechaFin,
        cuentaId
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
    if (data.containsKey('cuenta_id')) {
      context.handle(_cuentaIdMeta,
          cuentaId.isAcceptableOrUnknown(data['cuenta_id']!, _cuentaIdMeta));
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
      cuentaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cuenta_id']),
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
  final String? cuentaId;
  const MovimientoFila(
      {required this.id,
      required this.tipo,
      required this.descripcion,
      required this.montoCentavos,
      required this.categoriaId,
      required this.frecuencia,
      required this.fechaInicio,
      this.fechaFin,
      this.cuentaId});
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
    if (!nullToAbsent || cuentaId != null) {
      map['cuenta_id'] = Variable<String>(cuentaId);
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
      cuentaId: cuentaId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaId),
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
      cuentaId: serializer.fromJson<String?>(json['cuentaId']),
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
      'cuentaId': serializer.toJson<String?>(cuentaId),
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
          Value<DateTime?> fechaFin = const Value.absent(),
          Value<String?> cuentaId = const Value.absent()}) =>
      MovimientoFila(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        descripcion: descripcion ?? this.descripcion,
        montoCentavos: montoCentavos ?? this.montoCentavos,
        categoriaId: categoriaId ?? this.categoriaId,
        frecuencia: frecuencia ?? this.frecuencia,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
        cuentaId: cuentaId.present ? cuentaId.value : this.cuentaId,
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
      cuentaId: data.cuentaId.present ? data.cuentaId.value : this.cuentaId,
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
          ..write('fechaFin: $fechaFin, ')
          ..write('cuentaId: $cuentaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tipo, descripcion, montoCentavos,
      categoriaId, frecuencia, fechaInicio, fechaFin, cuentaId);
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
          other.fechaFin == this.fechaFin &&
          other.cuentaId == this.cuentaId);
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
  final Value<String?> cuentaId;
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
    this.cuentaId = const Value.absent(),
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
    this.cuentaId = const Value.absent(),
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
    Expression<String>? cuentaId,
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
      if (cuentaId != null) 'cuenta_id': cuentaId,
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
      Value<String?>? cuentaId,
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
      cuentaId: cuentaId ?? this.cuentaId,
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
    if (cuentaId.present) {
      map['cuenta_id'] = Variable<String>(cuentaId.value);
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
          ..write('cuentaId: $cuentaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InversionesTable extends Inversiones
    with TableInfo<$InversionesTable, InversionFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InversionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saldoInicialCentavosMeta =
      const VerificationMeta('saldoInicialCentavos');
  @override
  late final GeneratedColumn<int> saldoInicialCentavos = GeneratedColumn<int>(
      'saldo_inicial_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tasaAnualMeta =
      const VerificationMeta('tasaAnual');
  @override
  late final GeneratedColumn<double> tasaAnual = GeneratedColumn<double>(
      'tasa_anual', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _aporteMensualCentavosMeta =
      const VerificationMeta('aporteMensualCentavos');
  @override
  late final GeneratedColumn<int> aporteMensualCentavos = GeneratedColumn<int>(
      'aporte_mensual_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _institucionMeta =
      const VerificationMeta('institucion');
  @override
  late final GeneratedColumn<String> institucion = GeneratedColumn<String>(
      'institucion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        saldoInicialCentavos,
        tasaAnual,
        aporteMensualCentavos,
        institucion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inversiones';
  @override
  VerificationContext validateIntegrity(Insertable<InversionFila> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('saldo_inicial_centavos')) {
      context.handle(
          _saldoInicialCentavosMeta,
          saldoInicialCentavos.isAcceptableOrUnknown(
              data['saldo_inicial_centavos']!, _saldoInicialCentavosMeta));
    } else if (isInserting) {
      context.missing(_saldoInicialCentavosMeta);
    }
    if (data.containsKey('tasa_anual')) {
      context.handle(_tasaAnualMeta,
          tasaAnual.isAcceptableOrUnknown(data['tasa_anual']!, _tasaAnualMeta));
    } else if (isInserting) {
      context.missing(_tasaAnualMeta);
    }
    if (data.containsKey('aporte_mensual_centavos')) {
      context.handle(
          _aporteMensualCentavosMeta,
          aporteMensualCentavos.isAcceptableOrUnknown(
              data['aporte_mensual_centavos']!, _aporteMensualCentavosMeta));
    } else if (isInserting) {
      context.missing(_aporteMensualCentavosMeta);
    }
    if (data.containsKey('institucion')) {
      context.handle(
          _institucionMeta,
          institucion.isAcceptableOrUnknown(
              data['institucion']!, _institucionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InversionFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InversionFila(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      saldoInicialCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}saldo_inicial_centavos'])!,
      tasaAnual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_anual'])!,
      aporteMensualCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}aporte_mensual_centavos'])!,
      institucion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institucion'])!,
    );
  }

  @override
  $InversionesTable createAlias(String alias) {
    return $InversionesTable(attachedDatabase, alias);
  }
}

class InversionFila extends DataClass implements Insertable<InversionFila> {
  final String id;
  final String nombre;
  final int saldoInicialCentavos;
  final double tasaAnual;
  final int aporteMensualCentavos;
  final String institucion;
  const InversionFila(
      {required this.id,
      required this.nombre,
      required this.saldoInicialCentavos,
      required this.tasaAnual,
      required this.aporteMensualCentavos,
      required this.institucion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos);
    map['tasa_anual'] = Variable<double>(tasaAnual);
    map['aporte_mensual_centavos'] = Variable<int>(aporteMensualCentavos);
    map['institucion'] = Variable<String>(institucion);
    return map;
  }

  InversionesCompanion toCompanion(bool nullToAbsent) {
    return InversionesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      saldoInicialCentavos: Value(saldoInicialCentavos),
      tasaAnual: Value(tasaAnual),
      aporteMensualCentavos: Value(aporteMensualCentavos),
      institucion: Value(institucion),
    );
  }

  factory InversionFila.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InversionFila(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      saldoInicialCentavos:
          serializer.fromJson<int>(json['saldoInicialCentavos']),
      tasaAnual: serializer.fromJson<double>(json['tasaAnual']),
      aporteMensualCentavos:
          serializer.fromJson<int>(json['aporteMensualCentavos']),
      institucion: serializer.fromJson<String>(json['institucion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'saldoInicialCentavos': serializer.toJson<int>(saldoInicialCentavos),
      'tasaAnual': serializer.toJson<double>(tasaAnual),
      'aporteMensualCentavos': serializer.toJson<int>(aporteMensualCentavos),
      'institucion': serializer.toJson<String>(institucion),
    };
  }

  InversionFila copyWith(
          {String? id,
          String? nombre,
          int? saldoInicialCentavos,
          double? tasaAnual,
          int? aporteMensualCentavos,
          String? institucion}) =>
      InversionFila(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
        tasaAnual: tasaAnual ?? this.tasaAnual,
        aporteMensualCentavos:
            aporteMensualCentavos ?? this.aporteMensualCentavos,
        institucion: institucion ?? this.institucion,
      );
  InversionFila copyWithCompanion(InversionesCompanion data) {
    return InversionFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      saldoInicialCentavos: data.saldoInicialCentavos.present
          ? data.saldoInicialCentavos.value
          : this.saldoInicialCentavos,
      tasaAnual: data.tasaAnual.present ? data.tasaAnual.value : this.tasaAnual,
      aporteMensualCentavos: data.aporteMensualCentavos.present
          ? data.aporteMensualCentavos.value
          : this.aporteMensualCentavos,
      institucion:
          data.institucion.present ? data.institucion.value : this.institucion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InversionFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('tasaAnual: $tasaAnual, ')
          ..write('aporteMensualCentavos: $aporteMensualCentavos, ')
          ..write('institucion: $institucion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, saldoInicialCentavos, tasaAnual,
      aporteMensualCentavos, institucion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InversionFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.saldoInicialCentavos == this.saldoInicialCentavos &&
          other.tasaAnual == this.tasaAnual &&
          other.aporteMensualCentavos == this.aporteMensualCentavos &&
          other.institucion == this.institucion);
}

class InversionesCompanion extends UpdateCompanion<InversionFila> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int> saldoInicialCentavos;
  final Value<double> tasaAnual;
  final Value<int> aporteMensualCentavos;
  final Value<String> institucion;
  final Value<int> rowid;
  const InversionesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.saldoInicialCentavos = const Value.absent(),
    this.tasaAnual = const Value.absent(),
    this.aporteMensualCentavos = const Value.absent(),
    this.institucion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InversionesCompanion.insert({
    required String id,
    required String nombre,
    required int saldoInicialCentavos,
    required double tasaAnual,
    required int aporteMensualCentavos,
    this.institucion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre),
        saldoInicialCentavos = Value(saldoInicialCentavos),
        tasaAnual = Value(tasaAnual),
        aporteMensualCentavos = Value(aporteMensualCentavos);
  static Insertable<InversionFila> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<int>? saldoInicialCentavos,
    Expression<double>? tasaAnual,
    Expression<int>? aporteMensualCentavos,
    Expression<String>? institucion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (saldoInicialCentavos != null)
        'saldo_inicial_centavos': saldoInicialCentavos,
      if (tasaAnual != null) 'tasa_anual': tasaAnual,
      if (aporteMensualCentavos != null)
        'aporte_mensual_centavos': aporteMensualCentavos,
      if (institucion != null) 'institucion': institucion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InversionesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<int>? saldoInicialCentavos,
      Value<double>? tasaAnual,
      Value<int>? aporteMensualCentavos,
      Value<String>? institucion,
      Value<int>? rowid}) {
    return InversionesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
      tasaAnual: tasaAnual ?? this.tasaAnual,
      aporteMensualCentavos:
          aporteMensualCentavos ?? this.aporteMensualCentavos,
      institucion: institucion ?? this.institucion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (saldoInicialCentavos.present) {
      map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos.value);
    }
    if (tasaAnual.present) {
      map['tasa_anual'] = Variable<double>(tasaAnual.value);
    }
    if (aporteMensualCentavos.present) {
      map['aporte_mensual_centavos'] =
          Variable<int>(aporteMensualCentavos.value);
    }
    if (institucion.present) {
      map['institucion'] = Variable<String>(institucion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InversionesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('tasaAnual: $tasaAnual, ')
          ..write('aporteMensualCentavos: $aporteMensualCentavos, ')
          ..write('institucion: $institucion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TarjetasTable extends Tarjetas
    with TableInfo<$TarjetasTable, TarjetaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TarjetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saldoCentavosMeta =
      const VerificationMeta('saldoCentavos');
  @override
  late final GeneratedColumn<int> saldoCentavos = GeneratedColumn<int>(
      'saldo_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tasaAnualMeta =
      const VerificationMeta('tasaAnual');
  @override
  late final GeneratedColumn<double> tasaAnual = GeneratedColumn<double>(
      'tasa_anual', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pagoMinimoPorcentajeMeta =
      const VerificationMeta('pagoMinimoPorcentaje');
  @override
  late final GeneratedColumn<double> pagoMinimoPorcentaje =
      GeneratedColumn<double>('pago_minimo_porcentaje', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pagoMinimoFijoCentavosMeta =
      const VerificationMeta('pagoMinimoFijoCentavos');
  @override
  late final GeneratedColumn<int> pagoMinimoFijoCentavos = GeneratedColumn<int>(
      'pago_minimo_fijo_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _institucionMeta =
      const VerificationMeta('institucion');
  @override
  late final GeneratedColumn<String> institucion = GeneratedColumn<String>(
      'institucion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        saldoCentavos,
        tasaAnual,
        pagoMinimoPorcentaje,
        pagoMinimoFijoCentavos,
        institucion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tarjetas';
  @override
  VerificationContext validateIntegrity(Insertable<TarjetaFila> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('saldo_centavos')) {
      context.handle(
          _saldoCentavosMeta,
          saldoCentavos.isAcceptableOrUnknown(
              data['saldo_centavos']!, _saldoCentavosMeta));
    } else if (isInserting) {
      context.missing(_saldoCentavosMeta);
    }
    if (data.containsKey('tasa_anual')) {
      context.handle(_tasaAnualMeta,
          tasaAnual.isAcceptableOrUnknown(data['tasa_anual']!, _tasaAnualMeta));
    } else if (isInserting) {
      context.missing(_tasaAnualMeta);
    }
    if (data.containsKey('pago_minimo_porcentaje')) {
      context.handle(
          _pagoMinimoPorcentajeMeta,
          pagoMinimoPorcentaje.isAcceptableOrUnknown(
              data['pago_minimo_porcentaje']!, _pagoMinimoPorcentajeMeta));
    } else if (isInserting) {
      context.missing(_pagoMinimoPorcentajeMeta);
    }
    if (data.containsKey('pago_minimo_fijo_centavos')) {
      context.handle(
          _pagoMinimoFijoCentavosMeta,
          pagoMinimoFijoCentavos.isAcceptableOrUnknown(
              data['pago_minimo_fijo_centavos']!, _pagoMinimoFijoCentavosMeta));
    } else if (isInserting) {
      context.missing(_pagoMinimoFijoCentavosMeta);
    }
    if (data.containsKey('institucion')) {
      context.handle(
          _institucionMeta,
          institucion.isAcceptableOrUnknown(
              data['institucion']!, _institucionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TarjetaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TarjetaFila(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      saldoCentavos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saldo_centavos'])!,
      tasaAnual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_anual'])!,
      pagoMinimoPorcentaje: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}pago_minimo_porcentaje'])!,
      pagoMinimoFijoCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}pago_minimo_fijo_centavos'])!,
      institucion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institucion'])!,
    );
  }

  @override
  $TarjetasTable createAlias(String alias) {
    return $TarjetasTable(attachedDatabase, alias);
  }
}

class TarjetaFila extends DataClass implements Insertable<TarjetaFila> {
  final String id;
  final String nombre;
  final int saldoCentavos;
  final double tasaAnual;
  final double pagoMinimoPorcentaje;
  final int pagoMinimoFijoCentavos;
  final String institucion;
  const TarjetaFila(
      {required this.id,
      required this.nombre,
      required this.saldoCentavos,
      required this.tasaAnual,
      required this.pagoMinimoPorcentaje,
      required this.pagoMinimoFijoCentavos,
      required this.institucion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['saldo_centavos'] = Variable<int>(saldoCentavos);
    map['tasa_anual'] = Variable<double>(tasaAnual);
    map['pago_minimo_porcentaje'] = Variable<double>(pagoMinimoPorcentaje);
    map['pago_minimo_fijo_centavos'] = Variable<int>(pagoMinimoFijoCentavos);
    map['institucion'] = Variable<String>(institucion);
    return map;
  }

  TarjetasCompanion toCompanion(bool nullToAbsent) {
    return TarjetasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      saldoCentavos: Value(saldoCentavos),
      tasaAnual: Value(tasaAnual),
      pagoMinimoPorcentaje: Value(pagoMinimoPorcentaje),
      pagoMinimoFijoCentavos: Value(pagoMinimoFijoCentavos),
      institucion: Value(institucion),
    );
  }

  factory TarjetaFila.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TarjetaFila(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      saldoCentavos: serializer.fromJson<int>(json['saldoCentavos']),
      tasaAnual: serializer.fromJson<double>(json['tasaAnual']),
      pagoMinimoPorcentaje:
          serializer.fromJson<double>(json['pagoMinimoPorcentaje']),
      pagoMinimoFijoCentavos:
          serializer.fromJson<int>(json['pagoMinimoFijoCentavos']),
      institucion: serializer.fromJson<String>(json['institucion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'saldoCentavos': serializer.toJson<int>(saldoCentavos),
      'tasaAnual': serializer.toJson<double>(tasaAnual),
      'pagoMinimoPorcentaje': serializer.toJson<double>(pagoMinimoPorcentaje),
      'pagoMinimoFijoCentavos': serializer.toJson<int>(pagoMinimoFijoCentavos),
      'institucion': serializer.toJson<String>(institucion),
    };
  }

  TarjetaFila copyWith(
          {String? id,
          String? nombre,
          int? saldoCentavos,
          double? tasaAnual,
          double? pagoMinimoPorcentaje,
          int? pagoMinimoFijoCentavos,
          String? institucion}) =>
      TarjetaFila(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        saldoCentavos: saldoCentavos ?? this.saldoCentavos,
        tasaAnual: tasaAnual ?? this.tasaAnual,
        pagoMinimoPorcentaje: pagoMinimoPorcentaje ?? this.pagoMinimoPorcentaje,
        pagoMinimoFijoCentavos:
            pagoMinimoFijoCentavos ?? this.pagoMinimoFijoCentavos,
        institucion: institucion ?? this.institucion,
      );
  TarjetaFila copyWithCompanion(TarjetasCompanion data) {
    return TarjetaFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      saldoCentavos: data.saldoCentavos.present
          ? data.saldoCentavos.value
          : this.saldoCentavos,
      tasaAnual: data.tasaAnual.present ? data.tasaAnual.value : this.tasaAnual,
      pagoMinimoPorcentaje: data.pagoMinimoPorcentaje.present
          ? data.pagoMinimoPorcentaje.value
          : this.pagoMinimoPorcentaje,
      pagoMinimoFijoCentavos: data.pagoMinimoFijoCentavos.present
          ? data.pagoMinimoFijoCentavos.value
          : this.pagoMinimoFijoCentavos,
      institucion:
          data.institucion.present ? data.institucion.value : this.institucion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TarjetaFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('saldoCentavos: $saldoCentavos, ')
          ..write('tasaAnual: $tasaAnual, ')
          ..write('pagoMinimoPorcentaje: $pagoMinimoPorcentaje, ')
          ..write('pagoMinimoFijoCentavos: $pagoMinimoFijoCentavos, ')
          ..write('institucion: $institucion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, saldoCentavos, tasaAnual,
      pagoMinimoPorcentaje, pagoMinimoFijoCentavos, institucion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TarjetaFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.saldoCentavos == this.saldoCentavos &&
          other.tasaAnual == this.tasaAnual &&
          other.pagoMinimoPorcentaje == this.pagoMinimoPorcentaje &&
          other.pagoMinimoFijoCentavos == this.pagoMinimoFijoCentavos &&
          other.institucion == this.institucion);
}

class TarjetasCompanion extends UpdateCompanion<TarjetaFila> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int> saldoCentavos;
  final Value<double> tasaAnual;
  final Value<double> pagoMinimoPorcentaje;
  final Value<int> pagoMinimoFijoCentavos;
  final Value<String> institucion;
  final Value<int> rowid;
  const TarjetasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.saldoCentavos = const Value.absent(),
    this.tasaAnual = const Value.absent(),
    this.pagoMinimoPorcentaje = const Value.absent(),
    this.pagoMinimoFijoCentavos = const Value.absent(),
    this.institucion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TarjetasCompanion.insert({
    required String id,
    required String nombre,
    required int saldoCentavos,
    required double tasaAnual,
    required double pagoMinimoPorcentaje,
    required int pagoMinimoFijoCentavos,
    this.institucion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre),
        saldoCentavos = Value(saldoCentavos),
        tasaAnual = Value(tasaAnual),
        pagoMinimoPorcentaje = Value(pagoMinimoPorcentaje),
        pagoMinimoFijoCentavos = Value(pagoMinimoFijoCentavos);
  static Insertable<TarjetaFila> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<int>? saldoCentavos,
    Expression<double>? tasaAnual,
    Expression<double>? pagoMinimoPorcentaje,
    Expression<int>? pagoMinimoFijoCentavos,
    Expression<String>? institucion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (saldoCentavos != null) 'saldo_centavos': saldoCentavos,
      if (tasaAnual != null) 'tasa_anual': tasaAnual,
      if (pagoMinimoPorcentaje != null)
        'pago_minimo_porcentaje': pagoMinimoPorcentaje,
      if (pagoMinimoFijoCentavos != null)
        'pago_minimo_fijo_centavos': pagoMinimoFijoCentavos,
      if (institucion != null) 'institucion': institucion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TarjetasCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<int>? saldoCentavos,
      Value<double>? tasaAnual,
      Value<double>? pagoMinimoPorcentaje,
      Value<int>? pagoMinimoFijoCentavos,
      Value<String>? institucion,
      Value<int>? rowid}) {
    return TarjetasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      saldoCentavos: saldoCentavos ?? this.saldoCentavos,
      tasaAnual: tasaAnual ?? this.tasaAnual,
      pagoMinimoPorcentaje: pagoMinimoPorcentaje ?? this.pagoMinimoPorcentaje,
      pagoMinimoFijoCentavos:
          pagoMinimoFijoCentavos ?? this.pagoMinimoFijoCentavos,
      institucion: institucion ?? this.institucion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (saldoCentavos.present) {
      map['saldo_centavos'] = Variable<int>(saldoCentavos.value);
    }
    if (tasaAnual.present) {
      map['tasa_anual'] = Variable<double>(tasaAnual.value);
    }
    if (pagoMinimoPorcentaje.present) {
      map['pago_minimo_porcentaje'] =
          Variable<double>(pagoMinimoPorcentaje.value);
    }
    if (pagoMinimoFijoCentavos.present) {
      map['pago_minimo_fijo_centavos'] =
          Variable<int>(pagoMinimoFijoCentavos.value);
    }
    if (institucion.present) {
      map['institucion'] = Variable<String>(institucion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TarjetasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('saldoCentavos: $saldoCentavos, ')
          ..write('tasaAnual: $tasaAnual, ')
          ..write('pagoMinimoPorcentaje: $pagoMinimoPorcentaje, ')
          ..write('pagoMinimoFijoCentavos: $pagoMinimoFijoCentavos, ')
          ..write('institucion: $institucion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CuentasTable extends Cuentas with TableInfo<$CuentasTable, CuentaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _institucionMeta =
      const VerificationMeta('institucion');
  @override
  late final GeneratedColumn<String> institucion = GeneratedColumn<String>(
      'institucion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<int> tipo = GeneratedColumn<int>(
      'tipo', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _saldoCentavosMeta =
      const VerificationMeta('saldoCentavos');
  @override
  late final GeneratedColumn<int> saldoCentavos = GeneratedColumn<int>(
      'saldo_centavos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tasaAnualMeta =
      const VerificationMeta('tasaAnual');
  @override
  late final GeneratedColumn<double> tasaAnual = GeneratedColumn<double>(
      'tasa_anual', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, institucion, nombre, tipo, saldoCentavos, tasaAnual];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuentas';
  @override
  VerificationContext validateIntegrity(Insertable<CuentaFila> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('institucion')) {
      context.handle(
          _institucionMeta,
          institucion.isAcceptableOrUnknown(
              data['institucion']!, _institucionMeta));
    } else if (isInserting) {
      context.missing(_institucionMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('saldo_centavos')) {
      context.handle(
          _saldoCentavosMeta,
          saldoCentavos.isAcceptableOrUnknown(
              data['saldo_centavos']!, _saldoCentavosMeta));
    } else if (isInserting) {
      context.missing(_saldoCentavosMeta);
    }
    if (data.containsKey('tasa_anual')) {
      context.handle(_tasaAnualMeta,
          tasaAnual.isAcceptableOrUnknown(data['tasa_anual']!, _tasaAnualMeta));
    } else if (isInserting) {
      context.missing(_tasaAnualMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaFila(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      institucion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institucion'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo'])!,
      saldoCentavos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saldo_centavos'])!,
      tasaAnual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_anual'])!,
    );
  }

  @override
  $CuentasTable createAlias(String alias) {
    return $CuentasTable(attachedDatabase, alias);
  }
}

class CuentaFila extends DataClass implements Insertable<CuentaFila> {
  final String id;
  final String institucion;
  final String nombre;
  final int tipo;
  final int saldoCentavos;
  final double tasaAnual;
  const CuentaFila(
      {required this.id,
      required this.institucion,
      required this.nombre,
      required this.tipo,
      required this.saldoCentavos,
      required this.tasaAnual});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['institucion'] = Variable<String>(institucion);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<int>(tipo);
    map['saldo_centavos'] = Variable<int>(saldoCentavos);
    map['tasa_anual'] = Variable<double>(tasaAnual);
    return map;
  }

  CuentasCompanion toCompanion(bool nullToAbsent) {
    return CuentasCompanion(
      id: Value(id),
      institucion: Value(institucion),
      nombre: Value(nombre),
      tipo: Value(tipo),
      saldoCentavos: Value(saldoCentavos),
      tasaAnual: Value(tasaAnual),
    );
  }

  factory CuentaFila.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaFila(
      id: serializer.fromJson<String>(json['id']),
      institucion: serializer.fromJson<String>(json['institucion']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<int>(json['tipo']),
      saldoCentavos: serializer.fromJson<int>(json['saldoCentavos']),
      tasaAnual: serializer.fromJson<double>(json['tasaAnual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'institucion': serializer.toJson<String>(institucion),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<int>(tipo),
      'saldoCentavos': serializer.toJson<int>(saldoCentavos),
      'tasaAnual': serializer.toJson<double>(tasaAnual),
    };
  }

  CuentaFila copyWith(
          {String? id,
          String? institucion,
          String? nombre,
          int? tipo,
          int? saldoCentavos,
          double? tasaAnual}) =>
      CuentaFila(
        id: id ?? this.id,
        institucion: institucion ?? this.institucion,
        nombre: nombre ?? this.nombre,
        tipo: tipo ?? this.tipo,
        saldoCentavos: saldoCentavos ?? this.saldoCentavos,
        tasaAnual: tasaAnual ?? this.tasaAnual,
      );
  CuentaFila copyWithCompanion(CuentasCompanion data) {
    return CuentaFila(
      id: data.id.present ? data.id.value : this.id,
      institucion:
          data.institucion.present ? data.institucion.value : this.institucion,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      saldoCentavos: data.saldoCentavos.present
          ? data.saldoCentavos.value
          : this.saldoCentavos,
      tasaAnual: data.tasaAnual.present ? data.tasaAnual.value : this.tasaAnual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaFila(')
          ..write('id: $id, ')
          ..write('institucion: $institucion, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('saldoCentavos: $saldoCentavos, ')
          ..write('tasaAnual: $tasaAnual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, institucion, nombre, tipo, saldoCentavos, tasaAnual);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaFila &&
          other.id == this.id &&
          other.institucion == this.institucion &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.saldoCentavos == this.saldoCentavos &&
          other.tasaAnual == this.tasaAnual);
}

class CuentasCompanion extends UpdateCompanion<CuentaFila> {
  final Value<String> id;
  final Value<String> institucion;
  final Value<String> nombre;
  final Value<int> tipo;
  final Value<int> saldoCentavos;
  final Value<double> tasaAnual;
  final Value<int> rowid;
  const CuentasCompanion({
    this.id = const Value.absent(),
    this.institucion = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.saldoCentavos = const Value.absent(),
    this.tasaAnual = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CuentasCompanion.insert({
    required String id,
    required String institucion,
    required String nombre,
    required int tipo,
    required int saldoCentavos,
    required double tasaAnual,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        institucion = Value(institucion),
        nombre = Value(nombre),
        tipo = Value(tipo),
        saldoCentavos = Value(saldoCentavos),
        tasaAnual = Value(tasaAnual);
  static Insertable<CuentaFila> custom({
    Expression<String>? id,
    Expression<String>? institucion,
    Expression<String>? nombre,
    Expression<int>? tipo,
    Expression<int>? saldoCentavos,
    Expression<double>? tasaAnual,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (institucion != null) 'institucion': institucion,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (saldoCentavos != null) 'saldo_centavos': saldoCentavos,
      if (tasaAnual != null) 'tasa_anual': tasaAnual,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CuentasCompanion copyWith(
      {Value<String>? id,
      Value<String>? institucion,
      Value<String>? nombre,
      Value<int>? tipo,
      Value<int>? saldoCentavos,
      Value<double>? tasaAnual,
      Value<int>? rowid}) {
    return CuentasCompanion(
      id: id ?? this.id,
      institucion: institucion ?? this.institucion,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      saldoCentavos: saldoCentavos ?? this.saldoCentavos,
      tasaAnual: tasaAnual ?? this.tasaAnual,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (institucion.present) {
      map['institucion'] = Variable<String>(institucion.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(tipo.value);
    }
    if (saldoCentavos.present) {
      map['saldo_centavos'] = Variable<int>(saldoCentavos.value);
    }
    if (tasaAnual.present) {
      map['tasa_anual'] = Variable<double>(tasaAnual.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentasCompanion(')
          ..write('id: $id, ')
          ..write('institucion: $institucion, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('saldoCentavos: $saldoCentavos, ')
          ..write('tasaAnual: $tasaAnual, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $InversionesTable inversiones = $InversionesTable(this);
  late final $TarjetasTable tarjetas = $TarjetasTable(this);
  late final $CuentasTable cuentas = $CuentasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [movimientos, inversiones, tarjetas, cuentas];
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
  Value<String?> cuentaId,
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
  Value<String?> cuentaId,
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

  ColumnFilters<String> get cuentaId => $composableBuilder(
      column: $table.cuentaId, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get cuentaId => $composableBuilder(
      column: $table.cuentaId, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get cuentaId =>
      $composableBuilder(column: $table.cuentaId, builder: (column) => column);
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
            Value<String?> cuentaId = const Value.absent(),
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
            cuentaId: cuentaId,
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
            Value<String?> cuentaId = const Value.absent(),
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
            cuentaId: cuentaId,
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
typedef $$InversionesTableCreateCompanionBuilder = InversionesCompanion
    Function({
  required String id,
  required String nombre,
  required int saldoInicialCentavos,
  required double tasaAnual,
  required int aporteMensualCentavos,
  Value<String> institucion,
  Value<int> rowid,
});
typedef $$InversionesTableUpdateCompanionBuilder = InversionesCompanion
    Function({
  Value<String> id,
  Value<String> nombre,
  Value<int> saldoInicialCentavos,
  Value<double> tasaAnual,
  Value<int> aporteMensualCentavos,
  Value<String> institucion,
  Value<int> rowid,
});

class $$InversionesTableFilterComposer
    extends Composer<_$BaseDatos, $InversionesTable> {
  $$InversionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoInicialCentavos => $composableBuilder(
      column: $table.saldoInicialCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aporteMensualCentavos => $composableBuilder(
      column: $table.aporteMensualCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnFilters(column));
}

class $$InversionesTableOrderingComposer
    extends Composer<_$BaseDatos, $InversionesTable> {
  $$InversionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoInicialCentavos => $composableBuilder(
      column: $table.saldoInicialCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aporteMensualCentavos => $composableBuilder(
      column: $table.aporteMensualCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnOrderings(column));
}

class $$InversionesTableAnnotationComposer
    extends Composer<_$BaseDatos, $InversionesTable> {
  $$InversionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get saldoInicialCentavos => $composableBuilder(
      column: $table.saldoInicialCentavos, builder: (column) => column);

  GeneratedColumn<double> get tasaAnual =>
      $composableBuilder(column: $table.tasaAnual, builder: (column) => column);

  GeneratedColumn<int> get aporteMensualCentavos => $composableBuilder(
      column: $table.aporteMensualCentavos, builder: (column) => column);

  GeneratedColumn<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => column);
}

class $$InversionesTableTableManager extends RootTableManager<
    _$BaseDatos,
    $InversionesTable,
    InversionFila,
    $$InversionesTableFilterComposer,
    $$InversionesTableOrderingComposer,
    $$InversionesTableAnnotationComposer,
    $$InversionesTableCreateCompanionBuilder,
    $$InversionesTableUpdateCompanionBuilder,
    (
      InversionFila,
      BaseReferences<_$BaseDatos, $InversionesTable, InversionFila>
    ),
    InversionFila,
    PrefetchHooks Function()> {
  $$InversionesTableTableManager(_$BaseDatos db, $InversionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InversionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InversionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InversionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> saldoInicialCentavos = const Value.absent(),
            Value<double> tasaAnual = const Value.absent(),
            Value<int> aporteMensualCentavos = const Value.absent(),
            Value<String> institucion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InversionesCompanion(
            id: id,
            nombre: nombre,
            saldoInicialCentavos: saldoInicialCentavos,
            tasaAnual: tasaAnual,
            aporteMensualCentavos: aporteMensualCentavos,
            institucion: institucion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            required int saldoInicialCentavos,
            required double tasaAnual,
            required int aporteMensualCentavos,
            Value<String> institucion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InversionesCompanion.insert(
            id: id,
            nombre: nombre,
            saldoInicialCentavos: saldoInicialCentavos,
            tasaAnual: tasaAnual,
            aporteMensualCentavos: aporteMensualCentavos,
            institucion: institucion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$InversionesTable, InversionFila>(table),
                    BaseReferences<_$BaseDatos, $InversionesTable,
                        InversionFila>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InversionesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDatos,
    $InversionesTable,
    InversionFila,
    $$InversionesTableFilterComposer,
    $$InversionesTableOrderingComposer,
    $$InversionesTableAnnotationComposer,
    $$InversionesTableCreateCompanionBuilder,
    $$InversionesTableUpdateCompanionBuilder,
    (
      InversionFila,
      BaseReferences<_$BaseDatos, $InversionesTable, InversionFila>
    ),
    InversionFila,
    PrefetchHooks Function()>;
typedef $$TarjetasTableCreateCompanionBuilder = TarjetasCompanion Function({
  required String id,
  required String nombre,
  required int saldoCentavos,
  required double tasaAnual,
  required double pagoMinimoPorcentaje,
  required int pagoMinimoFijoCentavos,
  Value<String> institucion,
  Value<int> rowid,
});
typedef $$TarjetasTableUpdateCompanionBuilder = TarjetasCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<int> saldoCentavos,
  Value<double> tasaAnual,
  Value<double> pagoMinimoPorcentaje,
  Value<int> pagoMinimoFijoCentavos,
  Value<String> institucion,
  Value<int> rowid,
});

class $$TarjetasTableFilterComposer
    extends Composer<_$BaseDatos, $TarjetasTable> {
  $$TarjetasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pagoMinimoPorcentaje => $composableBuilder(
      column: $table.pagoMinimoPorcentaje,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pagoMinimoFijoCentavos => $composableBuilder(
      column: $table.pagoMinimoFijoCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnFilters(column));
}

class $$TarjetasTableOrderingComposer
    extends Composer<_$BaseDatos, $TarjetasTable> {
  $$TarjetasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pagoMinimoPorcentaje => $composableBuilder(
      column: $table.pagoMinimoPorcentaje,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pagoMinimoFijoCentavos => $composableBuilder(
      column: $table.pagoMinimoFijoCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnOrderings(column));
}

class $$TarjetasTableAnnotationComposer
    extends Composer<_$BaseDatos, $TarjetasTable> {
  $$TarjetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos, builder: (column) => column);

  GeneratedColumn<double> get tasaAnual =>
      $composableBuilder(column: $table.tasaAnual, builder: (column) => column);

  GeneratedColumn<double> get pagoMinimoPorcentaje => $composableBuilder(
      column: $table.pagoMinimoPorcentaje, builder: (column) => column);

  GeneratedColumn<int> get pagoMinimoFijoCentavos => $composableBuilder(
      column: $table.pagoMinimoFijoCentavos, builder: (column) => column);

  GeneratedColumn<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => column);
}

class $$TarjetasTableTableManager extends RootTableManager<
    _$BaseDatos,
    $TarjetasTable,
    TarjetaFila,
    $$TarjetasTableFilterComposer,
    $$TarjetasTableOrderingComposer,
    $$TarjetasTableAnnotationComposer,
    $$TarjetasTableCreateCompanionBuilder,
    $$TarjetasTableUpdateCompanionBuilder,
    (TarjetaFila, BaseReferences<_$BaseDatos, $TarjetasTable, TarjetaFila>),
    TarjetaFila,
    PrefetchHooks Function()> {
  $$TarjetasTableTableManager(_$BaseDatos db, $TarjetasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TarjetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TarjetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TarjetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> saldoCentavos = const Value.absent(),
            Value<double> tasaAnual = const Value.absent(),
            Value<double> pagoMinimoPorcentaje = const Value.absent(),
            Value<int> pagoMinimoFijoCentavos = const Value.absent(),
            Value<String> institucion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TarjetasCompanion(
            id: id,
            nombre: nombre,
            saldoCentavos: saldoCentavos,
            tasaAnual: tasaAnual,
            pagoMinimoPorcentaje: pagoMinimoPorcentaje,
            pagoMinimoFijoCentavos: pagoMinimoFijoCentavos,
            institucion: institucion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            required int saldoCentavos,
            required double tasaAnual,
            required double pagoMinimoPorcentaje,
            required int pagoMinimoFijoCentavos,
            Value<String> institucion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TarjetasCompanion.insert(
            id: id,
            nombre: nombre,
            saldoCentavos: saldoCentavos,
            tasaAnual: tasaAnual,
            pagoMinimoPorcentaje: pagoMinimoPorcentaje,
            pagoMinimoFijoCentavos: pagoMinimoFijoCentavos,
            institucion: institucion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TarjetasTable, TarjetaFila>(table),
                    BaseReferences<_$BaseDatos, $TarjetasTable, TarjetaFila>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TarjetasTableProcessedTableManager = ProcessedTableManager<
    _$BaseDatos,
    $TarjetasTable,
    TarjetaFila,
    $$TarjetasTableFilterComposer,
    $$TarjetasTableOrderingComposer,
    $$TarjetasTableAnnotationComposer,
    $$TarjetasTableCreateCompanionBuilder,
    $$TarjetasTableUpdateCompanionBuilder,
    (TarjetaFila, BaseReferences<_$BaseDatos, $TarjetasTable, TarjetaFila>),
    TarjetaFila,
    PrefetchHooks Function()>;
typedef $$CuentasTableCreateCompanionBuilder = CuentasCompanion Function({
  required String id,
  required String institucion,
  required String nombre,
  required int tipo,
  required int saldoCentavos,
  required double tasaAnual,
  Value<int> rowid,
});
typedef $$CuentasTableUpdateCompanionBuilder = CuentasCompanion Function({
  Value<String> id,
  Value<String> institucion,
  Value<String> nombre,
  Value<int> tipo,
  Value<int> saldoCentavos,
  Value<double> tasaAnual,
  Value<int> rowid,
});

class $$CuentasTableFilterComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnFilters(column));
}

class $$CuentasTableOrderingComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaAnual => $composableBuilder(
      column: $table.tasaAnual, builder: (column) => ColumnOrderings(column));
}

class $$CuentasTableAnnotationComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get institucion => $composableBuilder(
      column: $table.institucion, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get saldoCentavos => $composableBuilder(
      column: $table.saldoCentavos, builder: (column) => column);

  GeneratedColumn<double> get tasaAnual =>
      $composableBuilder(column: $table.tasaAnual, builder: (column) => column);
}

class $$CuentasTableTableManager extends RootTableManager<
    _$BaseDatos,
    $CuentasTable,
    CuentaFila,
    $$CuentasTableFilterComposer,
    $$CuentasTableOrderingComposer,
    $$CuentasTableAnnotationComposer,
    $$CuentasTableCreateCompanionBuilder,
    $$CuentasTableUpdateCompanionBuilder,
    (CuentaFila, BaseReferences<_$BaseDatos, $CuentasTable, CuentaFila>),
    CuentaFila,
    PrefetchHooks Function()> {
  $$CuentasTableTableManager(_$BaseDatos db, $CuentasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> institucion = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> tipo = const Value.absent(),
            Value<int> saldoCentavos = const Value.absent(),
            Value<double> tasaAnual = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CuentasCompanion(
            id: id,
            institucion: institucion,
            nombre: nombre,
            tipo: tipo,
            saldoCentavos: saldoCentavos,
            tasaAnual: tasaAnual,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String institucion,
            required String nombre,
            required int tipo,
            required int saldoCentavos,
            required double tasaAnual,
            Value<int> rowid = const Value.absent(),
          }) =>
              CuentasCompanion.insert(
            id: id,
            institucion: institucion,
            nombre: nombre,
            tipo: tipo,
            saldoCentavos: saldoCentavos,
            tasaAnual: tasaAnual,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CuentasTable, CuentaFila>(table),
                    BaseReferences<_$BaseDatos, $CuentasTable, CuentaFila>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CuentasTableProcessedTableManager = ProcessedTableManager<
    _$BaseDatos,
    $CuentasTable,
    CuentaFila,
    $$CuentasTableFilterComposer,
    $$CuentasTableOrderingComposer,
    $$CuentasTableAnnotationComposer,
    $$CuentasTableCreateCompanionBuilder,
    $$CuentasTableUpdateCompanionBuilder,
    (CuentaFila, BaseReferences<_$BaseDatos, $CuentasTable, CuentaFila>),
    CuentaFila,
    PrefetchHooks Function()>;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$InversionesTableTableManager get inversiones =>
      $$InversionesTableTableManager(_db, _db.inversiones);
  $$TarjetasTableTableManager get tarjetas =>
      $$TarjetasTableTableManager(_db, _db.tarjetas);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db, _db.cuentas);
}
