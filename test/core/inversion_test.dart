import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('interés compuesto mensual: 1000 al 12 % anual por 12 meses', () {
    const inv = Inversion(
        id: 'a', nombre: 'Plazo fijo', saldoInicial: 100000, tasaAnual: 0.12);
    // 1000 × 1.01^12 = 1126.83
    expect(valorFuturo(inv, 12), closeTo(112683, 2));
  });

  test('sin tasa, el saldo crece solo con los aportes', () {
    const inv = Inversion(
      id: 'a',
      nombre: 'Alcancía',
      saldoInicial: 100000,
      tasaAnual: 0,
      aporteMensual: 10000,
    );
    expect(proyectarInversion(inv, 12), hasLength(12));
    expect(valorFuturo(inv, 12), 220000);
  });

  test('con 0 meses el valor futuro es el saldo inicial', () {
    const inv =
        Inversion(id: 'a', nombre: 'x', saldoInicial: 5000, tasaAnual: 0.1);
    expect(valorFuturo(inv, 0), 5000);
  });

  test('tasa real descuenta la inflación', () {
    expect(tasaReal(0.10, 0.05), closeTo(0.047619, 1e-6));
    expect(tasaReal(0.04, 0.04), closeTo(0, 1e-12));
  });

  test('valor presente con 10 % de inflación a un año', () {
    expect(aValorPresente(110000, 0.10, 12), 100000);
  });
}
