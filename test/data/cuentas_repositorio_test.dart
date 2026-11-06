import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/cuentas_repositorio.dart';
import 'package:calculadora_rendimiento/data/inversiones_repositorio.dart';
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

  test('borrar la cuenta destino vuelve a reinvertir los rendimientos',
      () async {
    await CuentasRepositorio(db).guardar(const Cuenta(
      id: 'c1',
      institucion: 'BBVA',
      nombre: 'Nómina',
      tipo: TipoCuenta.debito,
      saldo: 0,
    ));
    final inversiones = InversionesRepositorio(db);
    await inversiones.guardar(const Inversion(
      id: 'i1',
      nombre: 'Nu',
      saldoInicial: 100,
      tasaAnual: 0.1,
      cuentaDestinoId: 'c1',
    ));
    expect(
        (await inversiones.observarTodas().first).single.cuentaDestinoId, 'c1');
    await CuentasRepositorio(db).borrar('c1');
    expect((await inversiones.observarTodas().first).single.cuentaDestinoId,
        isNull);
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
    expect(t.diaCorte, isNull);
    expect(t.pagoSinIntereses, isNull);
    expect(await CuentasRepositorio(vieja).observarTodas().first, isEmpty);
  });

  test('migra una base de la versión 3 con cuentas', () async {
    final vieja = BaseDatos(NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE movimientos (id TEXT NOT NULL, '
          'tipo INTEGER NOT NULL, descripcion TEXT NOT NULL, '
          'monto_centavos INTEGER NOT NULL, categoria_id TEXT NOT NULL, '
          'frecuencia INTEGER NOT NULL, fecha_inicio INTEGER NOT NULL, '
          'fecha_fin INTEGER NULL, cuenta_id TEXT NULL, PRIMARY KEY (id))');
      raw.execute('CREATE TABLE inversiones (id TEXT NOT NULL, '
          'nombre TEXT NOT NULL, saldo_inicial_centavos INTEGER NOT NULL, '
          'tasa_anual REAL NOT NULL, aporte_mensual_centavos INTEGER NOT NULL, '
          "institucion TEXT NOT NULL DEFAULT '', PRIMARY KEY (id))");
      raw.execute('CREATE TABLE tarjetas (id TEXT NOT NULL, '
          'nombre TEXT NOT NULL, saldo_centavos INTEGER NOT NULL, '
          'tasa_anual REAL NOT NULL, pago_minimo_porcentaje REAL NOT NULL, '
          'pago_minimo_fijo_centavos INTEGER NOT NULL, '
          "institucion TEXT NOT NULL DEFAULT '', PRIMARY KEY (id))");
      raw.execute('CREATE TABLE cuentas (id TEXT NOT NULL, '
          'institucion TEXT NOT NULL, nombre TEXT NOT NULL, '
          'tipo INTEGER NOT NULL, saldo_centavos INTEGER NOT NULL, '
          'tasa_anual REAL NOT NULL, PRIMARY KEY (id))');
      raw.execute("INSERT INTO cuentas VALUES ('c1', 'Nu', 'Cajita', 1, "
          '100000, 0.12)');
      raw.execute("INSERT INTO inversiones VALUES ('i1', 'Cetes', 100000, "
          "0.1, 0, 'GBM')");
      raw.execute('PRAGMA user_version = 3');
    }));
    addTearDown(vieja.close);

    final c = (await CuentasRepositorio(vieja).observarTodas().first).single;
    expect(c.nombre, 'Cajita');
    expect(c.capitalizacion, Capitalizacion.mensual);
    final i =
        (await InversionesRepositorio(vieja).observarTodas().first).single;
    expect(i.institucion, 'GBM');
    expect(i.capitalizacion, Capitalizacion.mensual);
  });

  test('guarda capitalización y fechas de tarjeta', () async {
    await InversionesRepositorio(db).guardar(const Inversion(
      id: 'i',
      nombre: 'Nu',
      saldoInicial: 100,
      tasaAnual: 0.1,
      capitalizacion: Capitalizacion.diaria,
    ));
    expect(
        (await InversionesRepositorio(db).observarTodas().first)
            .single
            .capitalizacion,
        Capitalizacion.diaria);
    await TarjetasRepositorio(db).guardar(const TarjetaCredito(
      id: 't',
      nombre: 'Oro',
      saldo: 1000,
      tasaAnual: 0.4,
      diaCorte: 15,
      diaPago: 5,
      pagoSinIntereses: 600,
    ));
    final t = (await TarjetasRepositorio(db).observarTodas().first).single;
    expect([t.diaCorte, t.diaPago, t.pagoSinIntereses], [15, 5, 600]);
  });
}
