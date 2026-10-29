import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final movimientos = [
    Movimiento(
      id: 'sueldo',
      tipo: TipoMovimiento.ingreso,
      descripcion: 'Sueldo',
      monto: 200000,
      categoriaId: 'trabajo',
      frecuencia: Frecuencia.mensual,
      fechaInicio: DateTime(2026, 1, 1),
    ),
    Movimiento(
      id: 'freelance',
      tipo: TipoMovimiento.ingreso,
      descripcion: 'Proyecto',
      monto: 10000,
      categoriaId: 'trabajo',
      frecuencia: Frecuencia.quincenal,
      fechaInicio: DateTime(2026, 1, 1),
    ),
    Movimiento(
      id: 'renta',
      tipo: TipoMovimiento.egreso,
      descripcion: 'Renta',
      monto: 80000,
      categoriaId: 'vivienda',
      frecuencia: Frecuencia.mensual,
      fechaInicio: DateTime(2026, 1, 1),
      fechaFin: DateTime(2026, 6, 30),
    ),
    Movimiento(
      id: 'seguro',
      tipo: TipoMovimiento.egreso,
      descripcion: 'Seguro del auto',
      monto: 120000,
      categoriaId: 'auto',
      frecuencia: Frecuencia.anual,
      fechaInicio: DateTime(2026, 3, 10),
    ),
    Movimiento(
      id: 'tv',
      tipo: TipoMovimiento.egreso,
      descripcion: 'Televisor',
      monto: 50000,
      categoriaId: 'hogar',
      frecuencia: Frecuencia.unica,
      fechaInicio: DateTime(2026, 2, 15),
    ),
  ];

  test('suma ingresos recurrentes y quincenales', () {
    final r = flujoMensual(movimientos, 2026, 1);
    expect(r.ingresos, 220000);
    expect(r.egresos, 80000);
    expect(r.neto, 140000);
    expect(r.porCategoria['trabajo'], 220000);
  });

  test('movimientos únicos y anuales caen solo en su mes', () {
    expect(flujoMensual(movimientos, 2026, 2).egresos, 130000);
    expect(flujoMensual(movimientos, 2026, 3).egresos, 200000);
    expect(flujoMensual(movimientos, 2027, 3).porCategoria['auto'], 120000);
    expect(flujoMensual(movimientos, 2027, 2).porCategoria['hogar'], isNull);
  });

  test('un movimiento deja de contar después de su fecha de fin', () {
    expect(flujoMensual(movimientos, 2026, 6).porCategoria['vivienda'], 80000);
    expect(flujoMensual(movimientos, 2026, 7).porCategoria['vivienda'], isNull);
  });

  test('nada cuenta antes de su fecha de inicio', () {
    final r = flujoMensual(movimientos, 2025, 12);
    expect(r.ingresos, 0);
    expect(r.egresos, 0);
    expect(r.tasaAhorro, 0);
  });

  test('tasa de ahorro', () {
    expect(flujoMensual(movimientos, 2026, 1).tasaAhorro,
        closeTo(140000 / 220000, 1e-12));
  });
}
