import 'package:drift/drift.dart';

import '../core/finanzas/modelos.dart';
import 'base_datos.dart';

/// Guarda y lee movimientos de la base local.
class MovimientosRepositorio {
  MovimientosRepositorio(this._db);

  final BaseDatos _db;

  /// Todos los movimientos, los más recientes primero; se actualiza solo.
  Stream<List<Movimiento>> observarTodos() {
    final consulta = _db.select(_db.movimientos)
      ..orderBy([(m) => OrderingTerm.desc(m.fechaInicio)]);
    return consulta.watch().map((filas) => filas.map(_aModelo).toList());
  }

  /// Crea el movimiento o lo reemplaza si ya existe uno con el mismo id.
  Future<void> guardar(Movimiento m) {
    return _db.into(_db.movimientos).insertOnConflictUpdate(
          MovimientosCompanion.insert(
            id: m.id,
            tipo: m.tipo.index,
            descripcion: m.descripcion,
            montoCentavos: m.monto,
            categoriaId: m.categoriaId,
            frecuencia: m.frecuencia.index,
            fechaInicio: m.fechaInicio,
            fechaFin: Value(m.fechaFin),
          ),
        );
  }

  Future<void> borrar(String id) {
    return (_db.delete(_db.movimientos)..where((m) => m.id.equals(id))).go();
  }

  Movimiento _aModelo(MovimientoFila f) {
    return Movimiento(
      id: f.id,
      tipo: TipoMovimiento.values[f.tipo],
      descripcion: f.descripcion,
      monto: f.montoCentavos,
      categoriaId: f.categoriaId,
      frecuencia: Frecuencia.values[f.frecuencia],
      fechaInicio: f.fechaInicio,
      fechaFin: f.fechaFin,
    );
  }
}
