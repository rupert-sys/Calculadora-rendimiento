import 'package:calculadora_rendimiento/app/app_shell.dart';
import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/cuentas_repositorio.dart';
import 'package:calculadora_rendimiento/data/movimientos_repositorio.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:calculadora_rendimiento/data/tarjetas_repositorio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(BaseDatos db) => ProviderScope(
      overrides: [baseDatosProvider.overrideWithValue(db)],
      child: const MaterialApp(home: AppShell()),
    );

void main() {
  testWidgets('agregar una cuenta la muestra bajo su banco', (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    await tester.pumpWidget(_app(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuentas').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Agrega tus cuentas'), findsOneWidget);

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuenta de débito o ahorro'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ahorro'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Institución'), 'Nu');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre de la cuenta'), 'Cajita');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Saldo actual (MXN)'), '20,000');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Rendimiento anual'), '12');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();

    expect(find.text('Nu'), findsOneWidget);
    expect(find.text('Cajita'), findsOneWidget);
    expect(find.text('Ahorro · 12 % anual'), findsOneWidget);
    expect(find.text(r'$20,000.00'), findsWidgets);

    await _cerrar(tester, db);
  });

  testWidgets('el banco pide nombre y una tarjeta resta del patrimonio',
      (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    await tester.runAsync(() async {
      await CuentasRepositorio(db).guardar(const Cuenta(
        id: 'c1',
        institucion: 'BBVA',
        nombre: 'Nómina',
        tipo: TipoCuenta.debito,
        saldo: 1000000,
      ));
      await TarjetasRepositorio(db).guardar(const TarjetaCredito(
        id: 't1',
        nombre: 'Oro',
        saldo: 300000,
        tasaAnual: 0.4,
        institucion: 'BBVA',
      ));
    });
    await tester.pumpWidget(_app(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuentas').last);
    await tester.pumpAndSettle();

    expect(find.text('BBVA'), findsOneWidget);
    expect(find.text(r'-$3,000.00'), findsOneWidget);
    // 10,000 - 3,000 en el banco y en el total.
    expect(find.text(r'$7,000.00'), findsNWidgets(2));

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuenta de débito o ahorro'));
    await tester.pumpAndSettle();
    // El banco que ya existe aparece como atajo.
    await tester.tap(find.widgetWithText(ActionChip, 'BBVA'));
    await tester.pump();
    expect(find.widgetWithText(TextFormField, 'BBVA'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Institución'), '');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    expect(find.text('Escribe el nombre del banco'), findsOneWidget);

    await _cerrar(tester, db);
  });

  testWidgets('un movimiento ligado aparece en su cuenta', (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    await tester.runAsync(() async {
      await CuentasRepositorio(db).guardar(const Cuenta(
        id: 'c1',
        institucion: 'BBVA',
        nombre: 'Nómina',
        tipo: TipoCuenta.debito,
        saldo: 0,
      ));
      await MovimientosRepositorio(db).guardar(Movimiento(
        id: 'm1',
        tipo: TipoMovimiento.ingreso,
        descripcion: 'Sueldo',
        monto: 3000000,
        categoriaId: 'sueldo',
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2020, 1, 1),
        cuentaId: 'c1',
      ));
    });
    await tester.pumpWidget(_app(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('BBVA · Nómina'), findsOneWidget);

    await tester.tap(find.text('Cuentas').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nómina'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Sueldo'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Movimientos ligados'), findsOneWidget);
    expect(find.text(r'Este mes: +$30,000.00'), findsOneWidget);

    await _cerrar(tester, db);
  });
}

Future<void> _cerrar(WidgetTester tester, BaseDatos db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
  await db.close();
}
