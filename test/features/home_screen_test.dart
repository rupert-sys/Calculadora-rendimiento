import 'package:calculadora_rendimiento/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra la ganancia al presionar Calcular', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), '1000');
    await tester.enterText(find.byType(TextField).at(1), '5');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Ganancia: \$50.00 MXN'), findsOneWidget);
  });
}
