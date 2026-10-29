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

@DriftDatabase(tables: [Movimientos])
class BaseDatos extends _$BaseDatos {
  BaseDatos([QueryExecutor? executor]) : super(executor ?? _abrir());

  @override
  int get schemaVersion => 1;

  /// SQLite local en Android, iOS, escritorio y web.
  static QueryExecutor _abrir() {
    return driftDatabase(name: 'calculadora_rendimiento');
  }
}
