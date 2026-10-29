import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convierte entre unidades y centavos', () {
    expect(aCentavos(12.34), 1234);
    expect(aCentavos(0.1 + 0.2), 30);
    expect(aUnidades(1234), 12.34);
  });

  test('formatea en pesos mexicanos con separador de miles', () {
    expect(formatearPesos(123456), r'$1,234.56');
    expect(formatearPesos(-5000), r'-$50.00');
    expect(codigoMoneda, 'MXN');
  });
}
