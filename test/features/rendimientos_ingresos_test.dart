import 'package:calculadora_rendimiento/app/app_shell.dart';
import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/cuentas_repositorio.dart';
import 'package:calculadora_rendimiento/data/inversiones_repositorio.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el rendimiento depositado aparece como ingreso automático',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = BaseDatos(NativeDatabase.memory());
    await tester.runAsync(() async {
      await CuentasRepositorio(db).guardar(const Cuenta(
        id: 'c1',
        institucion: 'BBVA',
        nombre: 'Nómina',
        tipo: TipoCuenta.debito,
        saldo: 0,
      ));
      await InversionesRepositorio(db).guardar(const Inversion(
        id: 'i1',
        nombre: 'Cetes',
        saldoInicial: 12000000,
        tasaAnual: 0.10,
        capitalizacion: Capitalizacion.mensual,
        cuentaDestinoId: 'c1',
      ));
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [baseDatosProvider.overrideWithValue(db)],
      child: const MaterialApp(home: AppShell()),
    ));
    await tester.pumpAndSettle();

    // 120,000 al 10 % mensual = 1,000 al mes en ingresos.
    expect(find.text(r'$1,000.00'), findsWidgets);

    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    expect(find.text('Rendimiento de Cetes'), findsOneWidget);
    expect(find.textContaining('Automático · Mensual · a BBVA · Nómina'),
        findsOneWidget);

    await tester.tap(find.text('Rendimiento de Cetes'));
    await tester.pumpAndSettle();
    expect(find.text('Editar inversión'), findsOneWidget);
    expect(find.textContaining('a BBVA · Nómina como ingreso'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await db.close();
  });
}
