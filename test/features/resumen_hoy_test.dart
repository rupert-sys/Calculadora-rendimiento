import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/cuentas_repositorio.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:calculadora_rendimiento/data/tarjetas_repositorio.dart';
import 'package:calculadora_rendimiento/features/resumen/resumen_screen.dart';
import 'package:calculadora_rendimiento/features/tarjetas/tarjeta_form_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el resumen muestra tarjetas y rendimientos', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = BaseDatos(NativeDatabase.memory());
    await tester.runAsync(() async {
      await TarjetasRepositorio(db).guardar(const TarjetaCredito(
        id: 't1',
        nombre: 'Oro',
        saldo: 1000000,
        tasaAnual: 0.4,
        institucion: 'BBVA',
        diaCorte: 15,
        diaPago: 5,
        pagoSinIntereses: 400000,
      ));
      await CuentasRepositorio(db).guardar(const Cuenta(
        id: 'c1',
        institucion: 'Nu',
        nombre: 'Cajita',
        tipo: TipoCuenta.ahorro,
        saldo: 10000000,
        tasaAnual: 0.365,
        capitalizacion: Capitalizacion.diaria,
      ));
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [baseDatosProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ResumenScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('BBVA · Oro'), findsOneWidget);
    expect(find.text('Para no generar intereses'), findsOneWidget);
    expect(find.text(r'$4,000.00'), findsOneWidget);
    expect(find.textContaining(' de '), findsWidgets);

    expect(find.text('Rendimientos'), findsOneWidget);
    expect(find.text('Cajita'), findsOneWidget);
    // 100,000 al 36.5 % con pago diario: 100 pesos al día.
    expect(find.text(r'$100.00'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await db.close();
  });

  testWidgets('la tarjeta no acepta pago sin intereses mayor al saldo',
      (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    await tester.pumpWidget(ProviderScope(
      overrides: [baseDatosProvider.overrideWithValue(db)],
      child: const MaterialApp(home: TarjetaFormScreen()),
    ));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre de la tarjeta'), 'Oro');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Saldo total (MXN)'), '1000');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Tasa de interés anual'), '40');
    await tester.enterText(
        find.widgetWithText(
            TextFormField, 'Pago para no generar intereses (MXN)'),
        '2000');
    await tester.dragUntilVisible(
      find.text('Guardar'),
      find.byType(ListView).last,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    await tester.dragUntilVisible(
      find.text('No puede ser mayor al saldo total'),
      find.byType(ListView).last,
      const Offset(0, 200),
    );
    expect(find.text('No puede ser mayor al saldo total'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await db.close();
  });
}
