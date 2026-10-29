import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/inversiones_repositorio.dart';
import 'package:calculadora_rendimiento/data/tarjetas_repositorio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BaseDatos db;

  setUp(() => db = BaseDatos(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('guarda, edita y borra inversiones', () async {
    final repo = InversionesRepositorio(db);
    const cetes = Inversion(
      id: 'cetes',
      nombre: 'Cetes',
      saldoInicial: 5000000,
      tasaAnual: 0.105,
      aporteMensual: 100000,
    );
    await repo.guardar(cetes);
    var lista = await repo.observarTodas().first;
    expect(lista.single.nombre, 'Cetes');
    expect(lista.single.tasaAnual, 0.105);
    expect(lista.single.aporteMensual, 100000);

    await repo.guardar(
      const Inversion(
          id: 'cetes',
          nombre: 'Cetes 28',
          saldoInicial: 6000000,
          tasaAnual: 0.1),
    );
    lista = await repo.observarTodas().first;
    expect(lista.single.nombre, 'Cetes 28');
    expect(lista.single.aporteMensual, 0);

    await repo.borrar('cetes');
    expect(await repo.observarTodas().first, isEmpty);
  });

  test('guarda, edita y borra tarjetas', () async {
    final repo = TarjetasRepositorio(db);
    const visa = TarjetaCredito(
      id: 'visa',
      nombre: 'Visa',
      saldo: 1500000,
      tasaAnual: 0.45,
      pagoMinimoPorcentaje: 0.04,
      pagoMinimoFijo: 30000,
    );
    await repo.guardar(visa);
    final t = (await repo.observarTodas().first).single;
    expect(t.saldo, 1500000);
    expect(t.tasaAnual, 0.45);
    expect(t.pagoMinimoPorcentaje, 0.04);
    expect(t.pagoMinimoFijo, 30000);

    await repo.borrar('visa');
    expect(await repo.observarTodas().first, isEmpty);
  });
}
