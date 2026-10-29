import 'package:calculadora_rendimiento/app/app_shell.dart';
import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:calculadora_rendimiento/features/tarjetas/tarjeta_form_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('agregar una inversión la muestra en la lista', (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [baseDatosProvider.overrideWithValue(db)],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inversiones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'), 'Cetes');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Saldo actual (MXN)'), '10,000');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Rendimiento anual'), '12');
    await tester.pump();
    // 10,000 al 12 % por 12 meses = 11,268.25
    expect(find.text(r'$11,268.25'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Guardar'),
      find.byType(ListView).last,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Cetes'), findsOneWidget);
    expect(find.text('Total invertido hoy'), findsOneWidget);
    expect(find.text(r'$10,000.00'), findsWidgets);

    await _cerrar(tester, db);
  });

  testWidgets('el comparador avisa cuando el pago no cubre los intereses',
      (tester) async {
    final db = BaseDatos(NativeDatabase.memory());
    const tarjeta = TarjetaCredito(
      id: 'visa',
      nombre: 'Visa',
      saldo: 1000000,
      tasaAnual: 0.48,
      pagoMinimoFijo: 20000,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [baseDatosProvider.overrideWithValue(db)],
        child: const MaterialApp(home: TarjetaFormScreen(tarjeta: tarjeta)),
      ),
    );

    expect(find.text('Pagar solo el mínimo'), findsOneWidget);
    expect(find.text('Pagar todo hoy'), findsOneWidget);

    // 4 % mensual de 10,000 = 400 de interés; 300 no alcanza.
    await tester.enterText(
      find.widgetWithText(TextField, 'Compara con un pago mensual fijo (MXN)'),
      '300',
    );
    await tester.pump();
    expect(find.textContaining('la deuda no baja'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Compara con un pago mensual fijo (MXN)'),
      '2000',
    );
    await tester.pump();
    expect(find.textContaining('la deuda no baja'), findsNothing);
    expect(find.textContaining('Terminas en'), findsNWidgets(2));

    await _cerrar(tester, db);
  });
}

Future<void> _cerrar(WidgetTester tester, BaseDatos db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
  await db.close();
}
