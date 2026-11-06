import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

Movimiento _mov(Frecuencia f, DateTime inicio, {DateTime? fin}) => Movimiento(
      id: 'm',
      tipo: TipoMovimiento.egreso,
      descripcion: 'Prueba',
      monto: 100,
      categoriaId: 'comida',
      frecuencia: f,
      fechaInicio: inicio,
      fechaFin: fin,
    );

void main() {
  group('semanal', () {
    // El 1 de enero de 2026 es jueves.
    final m = _mov(Frecuencia.semanal, DateTime(2026, 1, 1));

    test('cuenta los jueves de cada mes', () {
      expect(m.montoEnMes(2026, 1), 500); // 1, 8, 15, 22, 29
      expect(m.montoEnMes(2026, 2), 400); // 5, 12, 19, 26
      expect(m.montoEnMes(2026, 4), 500); // 2, 9, 16, 23, 30
    });

    test('empieza a contar desde su fecha de inicio', () {
      expect(
          _mov(Frecuencia.semanal, DateTime(2026, 1, 20)).montoEnMes(2026, 1),
          200); // 20, 27
      expect(m.montoEnMes(2025, 12), 0);
    });

    test('deja de contar en su fecha de fin', () {
      final conFin = _mov(Frecuencia.semanal, DateTime(2026, 1, 1),
          fin: DateTime(2026, 2, 10));
      expect(conFin.montoEnMes(2026, 2),
          100); // solo el 5; el 12 ya pasó la fecha de fin
      expect(conFin.montoEnMes(2026, 3), 0);
    });

    test('cruza el cambio de horario sin perder días', () {
      expect(m.montoEnMes(2026, 10), 500); // 1, 8, 15, 22, 29
    });
  });

  group('diario', () {
    test('cuenta los días del mes', () {
      final m = _mov(Frecuencia.diario, DateTime(2026, 1, 1));
      expect(m.montoEnMes(2026, 1), 3100);
      expect(m.montoEnMes(2026, 2), 2800);
      expect(m.montoEnMes(2028, 2), 2900);
    });

    test('respeta inicio y fin dentro del mes', () {
      final m = _mov(Frecuencia.diario, DateTime(2026, 1, 20),
          fin: DateTime(2026, 3, 10));
      expect(m.montoEnMes(2026, 1), 1200);
      expect(m.montoEnMes(2026, 3), 1000);
      expect(m.montoEnMes(2026, 4), 0);
    });
  });

  test('el orden en pantalla incluye todas las frecuencias', () {
    expect(frecuenciasEnOrden.toSet(), Frecuencia.values.toSet());
  });

  test('los índices guardados de las frecuencias viejas no cambian', () {
    expect(Frecuencia.unica.index, 0);
    expect(Frecuencia.quincenal.index, 1);
    expect(Frecuencia.mensual.index, 2);
    expect(Frecuencia.anual.index, 3);
  });
}
