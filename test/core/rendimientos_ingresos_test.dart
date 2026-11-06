import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Inversion inv(Capitalizacion c, {String? destino = 'nomina'}) => Inversion(
        id: 'nu',
        nombre: 'Nu',
        saldoInicial: 10000000, // 100,000 pesos
        tasaAnual: 0.365,
        capitalizacion: c,
        cuentaDestinoId: destino,
      );

  test('el rendimiento diario depositado es un ingreso de cada día', () {
    final m = rendimientosComoIngresos([inv(Capitalizacion.diaria)]).single;
    expect(m.tipo, TipoMovimiento.ingreso);
    expect(m.frecuencia, Frecuencia.diario);
    expect(m.monto, 10000); // 100 pesos al día
    expect(m.cuentaId, 'nomina');
    expect(esRendimientoAutomatico(m), isTrue);
    // Noviembre tiene 30 días.
    expect(flujoMensual([m], 2026, 11).ingresos, 300000);
  });

  test('cada periodicidad paga saldo × tasa / pagos al año', () {
    int monto(Capitalizacion c) =>
        rendimientosComoIngresos([inv(c)]).single.monto;
    expect(monto(Capitalizacion.semanal), (10000000 * 0.365 / 52).round());
    expect(monto(Capitalizacion.mensual), (10000000 * 0.365 / 12).round());
    expect(monto(Capitalizacion.anual), 3650000);
  });

  test('si se reinvierte no genera ingreso y sí crece', () {
    final reinvierte = inv(Capitalizacion.mensual, destino: null);
    expect(rendimientosComoIngresos([reinvierte]), isEmpty);
    expect(valorFuturo(reinvierte, 12), greaterThan(10000000));
  });

  test('si se deposita, el saldo solo crece con los aportes', () {
    final deposita = inv(Capitalizacion.mensual);
    expect(valorFuturo(deposita, 12), 10000000);
    final r = rendimientosDeInversion(deposita);
    expect(r.anio, 3650000);
    expect(r.dia, 10000);
  });

  test('en el simulador el rendimiento depositado llega al efectivo', () {
    final r = simular(
      escenario: const Escenario(nombre: 'x', anios: 1, inflacionAnual: 0),
      inicio: DateTime(2026, 1),
      inversiones: [inv(Capitalizacion.mensual)],
    );
    expect(r.ultimo.inversiones, 10000000);
    expect(r.ultimo.efectivo, closeTo(3650000, 12));
  });
}
