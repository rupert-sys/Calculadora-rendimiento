import 'package:calculadora_rendimiento/features/comun/campos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('textoMeses', () {
    expect(textoMeses(0), '0 meses');
    expect(textoMeses(1), '1 mes');
    expect(textoMeses(11), '11 meses');
    expect(textoMeses(12), '1 año');
    expect(textoMeses(27), '2 años 3 meses');
  });

  test('textoTasa', () {
    expect(textoTasa(0.10), '10 %');
    expect(textoTasa(0.085), '8.5 %');
    expect(textoTasa(0.1234), '12.34 %');
    expect(textoTasa(0), '0 %');
  });

  test('leerMonto acepta separador de miles', () {
    expect(leerMonto('1,234.50'), 1234.5);
    expect(leerMonto('abc'), isNull);
  });
}
