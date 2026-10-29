import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('las categorías predeterminadas tienen ids únicos', () {
    final ids = categoriasPredeterminadas.map((c) => c.id).toSet();
    expect(ids, hasLength(categoriasPredeterminadas.length));
  });

  test('hay 9 categorías de gastos y 4 de ingresos', () {
    final gastos =
        categoriasPredeterminadas.where((c) => c.tipo == TipoMovimiento.egreso);
    final ingresos = categoriasPredeterminadas
        .where((c) => c.tipo == TipoMovimiento.ingreso);
    expect(gastos, hasLength(9));
    expect(ingresos, hasLength(4));
  });

  test('el escenario usa 4 % de inflación por defecto', () {
    const e = Escenario(nombre: 'Base', anios: 10);
    expect(e.inflacionAnual, 0.04);
  });
}
