import 'package:drift/drift.dart';

import '../core/finanzas/modelos.dart';
import 'base_datos.dart';

class TarjetasRepositorio {
  TarjetasRepositorio(this._db);

  final BaseDatos _db;

  Stream<List<TarjetaCredito>> observarTodas() {
    final consulta = _db.select(_db.tarjetas)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aModelo).toList());
  }

  Future<void> guardar(TarjetaCredito t) {
    return _db.into(_db.tarjetas).insertOnConflictUpdate(
          TarjetasCompanion.insert(
            id: t.id,
            nombre: t.nombre,
            saldoCentavos: t.saldo,
            tasaAnual: t.tasaAnual,
            pagoMinimoPorcentaje: t.pagoMinimoPorcentaje,
            pagoMinimoFijoCentavos: t.pagoMinimoFijo,
          ),
        );
  }

  Future<void> borrar(String id) {
    return (_db.delete(_db.tarjetas)..where((t) => t.id.equals(id))).go();
  }

  TarjetaCredito _aModelo(TarjetaFila f) => TarjetaCredito(
        id: f.id,
        nombre: f.nombre,
        saldo: f.saldoCentavos,
        tasaAnual: f.tasaAnual,
        pagoMinimoPorcentaje: f.pagoMinimoPorcentaje,
        pagoMinimoFijo: f.pagoMinimoFijoCentavos,
      );
}
