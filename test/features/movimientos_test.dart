import 'package:calculadora_rendimiento/app/app_shell.dart';
import 'package:calculadora_rendimiento/data/base_datos.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('agregar un egreso lo muestra en la lista y en el resumen',
      (tester) async {
    final db = BaseDatos(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [baseDatosProvider.overrideWithValue(db)],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Aún no hay movimientos'), findsOneWidget);

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Descripción'), 'Renta');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Monto (MXN)'), '8,000');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();

    expect(find.text('Renta'), findsOneWidget);
    expect(find.text(r'-$8,000.00'), findsOneWidget);

    await tester.tap(find.text('Resumen').last);
    await tester.pumpAndSettle();
    expect(find.text('Vivienda'), findsOneWidget);

    await _cerrar(tester, db);
  });

  testWidgets('el formulario pide descripción y monto', (tester) async {
    final db = BaseDatos(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [baseDatosProvider.overrideWithValue(db)],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(find.text('Escribe una descripción'), findsOneWidget);
    expect(find.text('Escribe un monto mayor a 0'), findsOneWidget);

    await _cerrar(tester, db);
  });
}

/// Desmonta la app para que drift cierre sus consultas antes de terminar.
Future<void> _cerrar(WidgetTester tester, BaseDatos db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
  await db.close();
}
