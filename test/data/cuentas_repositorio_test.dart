import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/cuentas_repositorio.dart';
import 'package:calculadora_rendimiento/data/movimientos_repositorio.dart';
import 'package:calculadora_rendimiento/data/tarjetas_repositorio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BaseDatos db;

  setUp(() => db = BaseDatos(NativeDatabase.memory()));
  tearDown(() => db.close());

  Movimiento movimiento(String cuentaId) => Movimiento(
        id: 'luz',
        tipo: TipoMovimiento.egreso,
        descripcion: 'Luz',
        monto: 50000,
        categoriaId: 'servicios',
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2026, 1, 1),
        cuentaId: cuentaId,
      );

  test('guarda y edita cuentas', () async {
    final repo = CuentasRepositorio(db);
    await repo.guardar(const Cuenta(
      id: 'c1',
      institucion: 'Nu',
      nombre: 'Cajita',
      tipo: TipoCuenta.ahorro,
      saldo: 1000000,
      tasaAnual: 0.12,
    ));
    var c = (await repo.observarTodas().first).single;
    expect(c.institucion, 'Nu');
    expect(c.tipo, TipoCuenta.ahorro);
    expect(c.tasaAnual, 0.12);

    await repo.guardar(const Cuenta(
      id: 'c1',
      institucion: 'Nu',
      nombre: 'Cajita',
      tipo: TipoCuenta.debito,
      saldo: 0,
    ));
    c = (await repo.observarTodas().first).single;
    expect(c.tipo, TipoCuenta.debito);
    expect(c.saldo, 0);
  });

  test('borrar una cuenta suelta sus movimientos sin borrarlos', () async {
    final cuentas = CuentasRepositorio(db);
    final movs = MovimientosRepositorio(db);
    await cuentas.guardar(const Cuenta(
      id: 'c1',
      institucion: 'BBVA',
      nombre: 'Nómina',
      tipo: TipoCuenta.debito,
      saldo: 0,
    ));
    await movs.guardar(movimiento('c1'));
    expect((await movs.observarTodos().first).single.cuentaId, 'c1');

    await cuentas.borrar('c1');
    final m = (await movs.observarTodos().first).single;
    expect(m.descripcion, 'Luz');
    expect(m.cuentaId, isNull);
  });

  test('borrar una tarjeta también suelta sus movimientos', () async {
    final tarjetas = TarjetasRepositorio(db);
    final movs = MovimientosRepositorio(db);
    await tarjetas.guardar(const TarjetaCredito(
      id: 't1',
      nombre: 'Oro',
      saldo: 0,
      tasaAnual: 0.4,
      institucion: 'BBVA',
    ));
    expect((await tarjetas.observarTodas().first).single.institucion, 'BBVA');
    await movs.guardar(movimiento('t1'));
    await tarjetas.borrar('t1');
    expect((await movs.observarTodos().first).single.cuentaId, isNull);
  });

  test('migra una base de la versión 2 sin perder datos', () async {
    final vieja = BaseDatos(NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE movimientos (id TEXT NOT NULL, '
          'tipo INTEGER NOT NULL, descripcion TEXT NOT NULL, '
          'monto_centavos INTEGER NOT NULL, categoria_id TEXT NOT NULL, '
          'frecuencia INTEGER NOT NULL, fecha_inicio INTEGER NOT NULL, '
          'fecha_fin INTEGER NULL, PRIMARY KEY (id))');
      raw.execute('CREATE TABLE inversiones (id TEXT NOT NULL, '
          'nombre TEXT NOT NULL, saldo_inicial_centavos INTEGER NOT NULL, '
          'tasa_anual REAL NOT NULL, aporte_mensual_centavos INTEGER NOT NULL, '
          'PRIMARY KEY (id))');
      raw.execute('CREATE TABLE tarjetas (id TEXT NOT NULL, '
          'nombre TEXT NOT NULL, saldo_centavos INTEGER NOT NULL, '
          'tasa_anual REAL NOT NULL, pago_minimo_porcentaje REAL NOT NULL, '
          'pago_minimo_fijo_centavos INTEGER NOT NULL, PRIMARY KEY (id))');
      raw.execute("INSERT INTO movimientos VALUES ('m1', 1, 'Renta', 800000, "
          "'vivienda', 2, 1767225600, NULL)");
      raw.execute(
          "INSERT INTO tarjetas VALUES ('t1', 'Oro', 100000, 0.4, 0.05, 0)");
      raw.execute('PRAGMA user_version = 2');
    }));
    addTearDown(vieja.close);

    final m =
        (await MovimientosRepositorio(vieja).observarTodos().first).single;
    expect(m.descripcion, 'Renta');
    expect(m.cuentaId, isNull);
    final t = (await TarjetasRepositorio(vieja).observarTodas().first).single;
    expect(t.institucion, '');
    expect(await CuentasRepositorio(vieja).observarTodas().first, isEmpty);
  });
}
