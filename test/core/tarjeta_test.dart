import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sin intereses, 1000 pagando 100 al mes se salda en 10 meses', () {
    const t =
        TarjetaCredito(id: 't', nombre: 'Visa', saldo: 100000, tasaAnual: 0);
    final r = simularTarjeta(t, pagoMensual: 10000);
    expect(r.meses, 10);
    expect(r.interesesTotales, 0);
    expect(r.pagadoTotal, 100000);
    expect(r.saldos.last, 0);
  });

  test('1000 al 12 % anual pagando 100 al mes se salda en 11 meses', () {
    const t =
        TarjetaCredito(id: 't', nombre: 'Visa', saldo: 100000, tasaAnual: 0.12);
    final r = simularTarjeta(t, pagoMensual: 10000);
    // n = -ln(1 - 0.01 × 1000 / 100) / ln(1.01) = 10.6 → 11 pagos
    expect(r.meses, 11);
    expect(r.pagadoTotal, r.saldoInicialMasIntereses(t));
  });

  test('si el pago no cubre los intereses la deuda nunca se salda', () {
    const t =
        TarjetaCredito(id: 't', nombre: 'Visa', saldo: 100000, tasaAnual: 0.24);
    final r = simularTarjeta(t, pagoMensual: 2000);
    expect(r.seSalda, isFalse);
  });

  test('pagar el mínimo cuesta más intereses que un pago fijo mayor', () {
    const t = TarjetaCredito(
      id: 't',
      nombre: 'Visa',
      saldo: 1000000,
      tasaAnual: 0.45,
      pagoMinimoFijo: 20000,
    );
    final minimo = simularTarjeta(t);
    final fijo = simularTarjeta(t, pagoMensual: 100000);
    expect(minimo.seSalda, isTrue);
    expect(fijo.seSalda, isTrue);
    expect(minimo.meses!, greaterThan(fijo.meses!));
    expect(minimo.interesesTotales, greaterThan(fijo.interesesTotales));
  });

  test(
      'el pago mínimo es el mayor entre porcentaje y fijo, sin pasar del saldo',
      () {
    const t = TarjetaCredito(
      id: 't',
      nombre: 'Visa',
      saldo: 0,
      tasaAnual: 0.3,
      pagoMinimoPorcentaje: 0.05,
      pagoMinimoFijo: 5000,
    );
    expect(pagoMinimo(t, 1000000), 50000);
    expect(pagoMinimo(t, 20000), 5000);
    expect(pagoMinimo(t, 3000), 3000);
  });

  test('pagando solo el mínimo porcentual la deuda termina de saldarse', () {
    const t =
        TarjetaCredito(id: 't', nombre: 'Visa', saldo: 100000, tasaAnual: 0.36);
    final r = simularTarjeta(t);
    expect(r.seSalda, isTrue);
    expect(r.saldos.last, 0);
  });
}

extension on ResultadoTarjeta {
  int saldoInicialMasIntereses(TarjetaCredito t) => t.saldo + interesesTotales;
}
