import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/movimientos_repositorio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BaseDatos db;
  late MovimientosRepositorio repo;

  setUp(() {
    db = BaseDatos(NativeDatabase.memory());
    repo = MovimientosRepositorio(db);
  });

  tearDown(() => db.close());

  Movimiento renta({int monto = 800000, DateTime? fin}) => Movimiento(
        id: 'renta',
        tipo: TipoMovimiento.egreso,
        descripcion: 'Renta',
        monto: monto,
        categoriaId: 'vivienda',
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2026, 1, 1),
        fechaFin: fin,
      );

  test('guarda y lee un movimiento con todos sus campos', () async {
    await repo.guardar(renta(fin: DateTime(2026, 12, 31)));

    final lista = await repo.observarTodos().first;
    expect(lista, hasLength(1));
    final m = lista.single;
    expect(m.tipo, TipoMovimiento.egreso);
    expect(m.descripcion, 'Renta');
    expect(m.monto, 800000);
    expect(m.categoriaId, 'vivienda');
    expect(m.frecuencia, Frecuencia.mensual);
    expect(m.fechaInicio, DateTime(2026, 1, 1));
    expect(m.fechaFin, DateTime(2026, 12, 31));
  });

  test('guardar con el mismo id edita en lugar de duplicar', () async {
    await repo.guardar(renta());
    await repo.guardar(renta(monto: 900000));

    final lista = await repo.observarTodos().first;
    expect(lista.single.monto, 900000);
  });

  test('borrar quita el movimiento', () async {
    await repo.guardar(renta());
    await repo.borrar('renta');

    expect(await repo.observarTodos().first, isEmpty);
  });
}
