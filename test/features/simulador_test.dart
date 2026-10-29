import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:calculadora_rendimiento/data/proveedores.dart';
import 'package:calculadora_rendimiento/features/simulador/simulador_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(
  ({
    List<Movimiento> movimientos,
    List<Inversion> inversiones,
    List<TarjetaCredito> tarjetas,
  }) datos,
) {
  return ProviderScope(
    overrides: [
      datosSimulacionProvider.overrideWithValue(AsyncValue.data(datos))
    ],
    child: const MaterialApp(home: SimuladorScreen()),
  );
}

void main() {
  testWidgets('sin datos pide registrar movimientos', (tester) async {
    await tester
        .pumpWidget(_app((movimientos: [], inversiones: [], tarjetas: [])));
    expect(find.textContaining('Registra tus ingresos'), findsOneWidget);
  });

  testWidgets('muestra la proyección y compara un escenario', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final sueldo = Movimiento(
      id: 's',
      tipo: TipoMovimiento.ingreso,
      descripcion: 'Sueldo',
      monto: 3000000,
      categoriaId: 'sueldo',
      frecuencia: Frecuencia.mensual,
      fechaInicio: DateTime(2020, 1, 1),
    );
    await tester.pumpWidget(
        _app((movimientos: [sueldo], inversiones: [], tarjetas: [])));

    expect(find.text('Patrimonio en 10 años'), findsOneWidget);
    // 30,000 al mes por 120 meses
    expect(find.text(r'$3,600,000.00'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.textContaining('Diferencia'), findsNothing);

    // Sube los ingresos con el control de "qué pasa si".
    await tester.drag(find.byType(Slider).at(2), const Offset(150, 0));
    await tester.pumpAndSettle();

    expect(find.text('Qué pasa si'), findsWidgets);
    expect(find.textContaining('Diferencia'), findsOneWidget);
  });
}
