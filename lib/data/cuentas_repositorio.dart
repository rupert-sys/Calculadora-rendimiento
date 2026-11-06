import 'package:drift/drift.dart';

import '../core/finanzas/modelos.dart';
import 'base_datos.dart';

class CuentasRepositorio {
  CuentasRepositorio(this._db);

  final BaseDatos _db;

  Stream<List<Cuenta>> observarTodas() {
    final consulta = _db.select(_db.cuentas)
      ..orderBy([
        (c) => OrderingTerm.asc(c.institucion),
        (c) => OrderingTerm.asc(c.nombre),
      ]);
    return consulta.watch().map((filas) => filas.map(_aModelo).toList());
  }

  Future<void> guardar(Cuenta c) {
    return _db.into(_db.cuentas).insertOnConflictUpdate(
          CuentasCompanion.insert(
            id: c.id,
            institucion: c.institucion,
            nombre: c.nombre,
            tipo: c.tipo.index,
            saldoCentavos: c.saldo,
            tasaAnual: c.tasaAnual,
            capitalizacion: Value(c.capitalizacion.index),
          ),
        );
  }

  /// Borra la cuenta y suelta los movimientos que estaban ligados a ella.
  Future<void> borrar(String id) {
    return _db.transaction(() async {
      await (_db.delete(_db.cuentas)..where((c) => c.id.equals(id))).go();
      await _db.desligarMovimientos(id);
    });
  }

  Cuenta _aModelo(CuentaFila f) => Cuenta(
        id: f.id,
        institucion: f.institucion,
        nombre: f.nombre,
        tipo: TipoCuenta.values[f.tipo],
        saldo: f.saldoCentavos,
        tasaAnual: f.tasaAnual,
        capitalizacion: Capitalizacion.values[f.capitalizacion],
      );
}
