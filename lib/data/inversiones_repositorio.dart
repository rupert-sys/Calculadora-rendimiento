import 'package:drift/drift.dart';

import '../core/finanzas/modelos.dart';
import 'base_datos.dart';

class InversionesRepositorio {
  InversionesRepositorio(this._db);

  final BaseDatos _db;

  Stream<List<Inversion>> observarTodas() {
    final consulta = _db.select(_db.inversiones)
      ..orderBy([(i) => OrderingTerm.asc(i.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aModelo).toList());
  }

  Future<void> guardar(Inversion i) {
    return _db.into(_db.inversiones).insertOnConflictUpdate(
          InversionesCompanion.insert(
            id: i.id,
            nombre: i.nombre,
            saldoInicialCentavos: i.saldoInicial,
            tasaAnual: i.tasaAnual,
            aporteMensualCentavos: i.aporteMensual,
          ),
        );
  }

  Future<void> borrar(String id) {
    return (_db.delete(_db.inversiones)..where((i) => i.id.equals(id))).go();
  }

  Inversion _aModelo(InversionFila f) => Inversion(
        id: f.id,
        nombre: f.nombre,
        saldoInicial: f.saldoInicialCentavos,
        tasaAnual: f.tasaAnual,
        aporteMensual: f.aporteMensualCentavos,
      );
}
