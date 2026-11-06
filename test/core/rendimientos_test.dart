import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('capitalización', () {
    test('la tasa efectiva crece entre más seguido se paga', () {
      expect(
          tasaEfectivaAnual(0.12, Capitalizacion.anual), closeTo(0.12, 1e-12));
      expect(tasaEfectivaAnual(0.12, Capitalizacion.mensual),
          closeTo(0.126825, 1e-6));
      expect(tasaEfectivaAnual(0.12, Capitalizacion.diaria),
          closeTo(0.127475, 1e-6));
    });

    test('mensual sigue siendo tasa anual entre 12', () {
      expect(tasaMensualEquivalente(0.12, Capitalizacion.mensual), 0.01);
    });

    test('la proyección usa la capitalización de la inversión', () {
      Inversion inv(Capitalizacion c) => Inversion(
            id: 'a',
            nombre: 'x',
            saldoInicial: 10000000,
            tasaAnual: 0.12,
            capitalizacion: c,
          );
      expect(valorFuturo(inv(Capitalizacion.anual), 12), closeTo(11200000, 2));
      expect(
          valorFuturo(inv(Capitalizacion.diaria), 12), closeTo(11274750, 50));
      expect(valorFuturo(inv(Capitalizacion.diaria), 12),
          greaterThan(valorFuturo(inv(Capitalizacion.mensual), 12)));
    });
  });

  group('rendimientos por periodo', () {
    test('con pago diario, un día da saldo × tasa / 365', () {
      // 100,000 al 36.5 % diario: 100 pesos al día.
      final r = rendimientosDe(10000000, 0.365, Capitalizacion.diaria);
      expect(r.dia, 10000);
      expect(r.semana, greaterThan(7 * 10000));
      expect(r.anio, closeTo(10000000 * 0.4402, 1000));
    });

    test('con pago anual, el año da saldo × tasa', () {
      final r = rendimientosDe(10000000, 0.10, Capitalizacion.anual);
      expect(r.anio, 1000000);
      expect(r.mes, lessThan(1000000 ~/ 12));
    });

    test('sin tasa no hay rendimiento y se pueden sumar', () {
      final cero = rendimientosDe(5000000, 0, Capitalizacion.mensual);
      expect(cero.anio, 0);
      final suma =
          cero + const Rendimientos(dia: 1, semana: 2, mes: 3, anio: 4);
      expect([suma.dia, suma.semana, suma.mes, suma.anio], [1, 2, 3, 4]);
    });
  });

  group('tarjeta', () {
    test('próximo día del mes, ajustado a meses cortos', () {
      expect(
          proximoDiaDelMes(31, DateTime(2026, 4, 10)), DateTime(2026, 4, 30));
      expect(proximoDiaDelMes(5, DateTime(2026, 4, 10)), DateTime(2026, 5, 5));
      expect(proximoDiaDelMes(10, DateTime(2026, 4, 10, 18)),
          DateTime(2026, 4, 10));
      expect(proximoDiaDelMes(31, DateTime(2026, 2, 1)), DateTime(2026, 2, 28));
      expect(proximoDiaDelMes(3, DateTime(2026, 12, 20)), DateTime(2027, 1, 3));
    });

    test('pago para no generar intereses', () {
      const base =
          TarjetaCredito(id: 't', nombre: 'x', saldo: 1000000, tasaAnual: 0.4);
      expect(pagoParaNoGenerarIntereses(base), 1000000);
      const conMsi = TarjetaCredito(
        id: 't',
        nombre: 'x',
        saldo: 1000000,
        tasaAnual: 0.4,
        pagoSinIntereses: 400000,
      );
      expect(pagoParaNoGenerarIntereses(conMsi), 400000);
      const mayor = TarjetaCredito(
        id: 't',
        nombre: 'x',
        saldo: 1000000,
        tasaAnual: 0.4,
        pagoSinIntereses: 2000000,
      );
      expect(pagoParaNoGenerarIntereses(mayor), 1000000);
    });
  });
}
