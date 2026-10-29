import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'base_datos.g.dart';

/// Ingresos y egresos. Los enums se guardan por su índice.
@DataClassName('MovimientoFila')
class Movimientos extends Table {
  TextColumn get id => text()();
  IntColumn get tipo => integer()();
  TextColumn get descripcion => text()();
  IntColumn get montoCentavos => integer()();
  TextColumn get categoriaId => text()();
  IntColumn get frecuencia => integer()();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFin => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Inversiones. Las tasas se guardan como fracción: 0.08 = 8 %.
@DataClassName('InversionFila')
class Inversiones extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  IntColumn get saldoInicialCentavos => integer()();
  RealColumn get tasaAnual => real()();
  IntColumn get aporteMensualCentavos => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TarjetaFila')
class Tarjetas extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  IntColumn get saldoCentavos => integer()();
  RealColumn get tasaAnual => real()();
  RealColumn get pagoMinimoPorcentaje => real()();
  IntColumn get pagoMinimoFijoCentavos => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Movimientos, Inversiones, Tarjetas])
class BaseDatos extends _$BaseDatos {
  BaseDatos([QueryExecutor? executor]) : super(executor ?? _abrir());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, desde, hasta) async {
          if (desde < 2) {
            await m.createTable(inversiones);
            await m.createTable(tarjetas);
          }
        },
      );

  /// SQLite local en Android, iOS, escritorio y web.
  static QueryExecutor _abrir() {
    return driftDatabase(name: 'calculadora_rendimiento');
  }
}
