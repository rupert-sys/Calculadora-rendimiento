import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final inicio = DateTime(2027, 1);
  final sueldo = Movimiento(
    id: 'sueldo',
    tipo: TipoMovimiento.ingreso,
    descripcion: 'Sueldo',
    monto: 3000000,
    categoriaId: 'sueldo',
    frecuencia: Frecuencia.mensual,
    fechaInicio: DateTime(2026, 1, 1),
  );
  final renta = Movimiento(
    id: 'renta',
    tipo: TipoMovimiento.egreso,
    descripcion: 'Renta',
    monto: 1000000,
    categoriaId: 'vivienda',
    frecuencia: Frecuencia.mensual,
    fechaInicio: DateTime(2026, 1, 1),
  );

  test('acumula el flujo neto mes a mes', () {
    final r = simular(
      escenario: const Escenario(nombre: 'Base', anios: 1, inflacionAnual: 0),
      inicio: inicio,
      movimientos: [sueldo, renta],
    );
    expect(r.puntos, hasLength(12));
    expect(r.puntos.first.fecha, DateTime(2027, 1));
    expect(r.puntos.last.fecha, DateTime(2027, 12));
    expect(r.ultimo.efectivo, 12 * 2000000);
    expect(r.ultimo.patrimonio, 12 * 2000000);
    expect(r.ultimo.patrimonioReal, 12 * 2000000);
  });

  test('los aportes salen del efectivo y crecen en la inversión', () {
    const inv = Inversion(
      id: 'i',
      nombre: 'Cetes',
      saldoInicial: 10000000,
      tasaAnual: 0.12,
      aporteMensual: 500000,
    );
    final r = simular(
      escenario: const Escenario(nombre: 'Base', anios: 1, inflacionAnual: 0),
      inicio: inicio,
      movimientos: [sueldo, renta],
      inversiones: [inv],
    );
    expect(r.ultimo.inversiones, valorFuturo(inv, 12));
    expect(r.ultimo.efectivo, 12 * (2000000 - 500000));
  });

  test('un pago extra salda la tarjeta antes y deja más patrimonio', () {
    const tarjeta = TarjetaCredito(
        id: 't', nombre: 'Visa', saldo: 3000000, tasaAnual: 0.45);
    Escenario esc(int extra) => Escenario(
        nombre: 'x', anios: 10, inflacionAnual: 0, pagoExtraTarjetas: extra);

    final base =
        simular(escenario: esc(0), inicio: inicio, tarjetas: [tarjeta]);
    final extra =
        simular(escenario: esc(200000), inicio: inicio, tarjetas: [tarjeta]);

    expect(extra.mesSinDeuda, isNotNull);
    expect(base.mesSinDeuda == null || base.mesSinDeuda! > extra.mesSinDeuda!,
        isTrue);
    expect(extra.ultimo.patrimonio, greaterThan(base.ultimo.patrimonio));
  });

  test('qué pasa si gasto 10 % menos', () {
    const base = Escenario(nombre: 'Base', anios: 1, inflacionAnual: 0);
    final r = simular(
      escenario: base.copyWith(ajusteEgresos: -0.10),
      inicio: inicio,
      movimientos: [sueldo, renta],
    );
    // 30,000 − 9,000 = 21,000 al mes
    expect(r.ultimo.efectivo, 12 * 2100000);
  });

  test('el patrimonio real descuenta la inflación', () {
    final r = simular(
      escenario:
          const Escenario(nombre: 'Base', anios: 1, inflacionAnual: 0.10),
      inicio: inicio,
      movimientos: [sueldo],
    );
    expect(r.ultimo.patrimonioReal, closeTo(36000000 / 1.10, 1));
  });

  test('sin tarjetas no hay mes sin deuda que reportar', () {
    final r = simular(
      escenario: const Escenario(nombre: 'Base', anios: 1),
      inicio: inicio,
    );
    expect(r.mesSinDeuda, isNull);
    expect(r.ultimo.deuda, 0);
  });
}
