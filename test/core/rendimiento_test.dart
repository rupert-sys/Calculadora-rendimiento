import 'package:calculadora_rendimiento/core/finanzas/rendimiento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calcula la ganancia de un rendimiento porcentual', () {
    expect(calcularGanancia(1000, 5), closeTo(50, 1e-9));
  });

  test('un rendimiento de 0 % no genera ganancia', () {
    expect(calcularGanancia(1000, 0), 0);
  });
}
