import 'package:calculadora_rendimiento/core/finanzas/finanzas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const nomina = Cuenta(
    id: 'nomina',
    institucion: 'BBVA',
    nombre: 'Nómina',
    tipo: TipoCuenta.debito,
    saldo: 1500000,
  );
  const ahorro = Cuenta(
    id: 'ahorro',
    institucion: 'Nu',
    nombre: 'Cajita',
    tipo: TipoCuenta.ahorro,
    saldo: 2000000,
    tasaAnual: 0.12,
  );
  const fondo = Inversion(
    id: 'fondo',
    nombre: 'Fondo',
    saldoInicial: 5000000,
    tasaAnual: 0.1,
    institucion: ' bbva ',
  );
  const oro = TarjetaCredito(
    id: 'oro',
    nombre: 'Oro',
    saldo: 800000,
    tasaAnual: 0.45,
    institucion: 'BBVA',
  );
  const sinBanco = TarjetaCredito(
    id: 'tienda',
    nombre: 'Tienda',
    saldo: 100000,
    tasaAnual: 0.6,
  );

  test('agrupa los productos por institución sin importar mayúsculas', () {
    final grupos = agruparPorInstitucion(
      cuentas: [nomina, ahorro],
      inversiones: [fondo],
      tarjetas: [oro, sinBanco],
    );
    expect(grupos.map((g) => g.institucion), ['BBVA', 'Nu', '']);

    final bbva = grupos.first;
    expect(bbva.cuentas, [nomina]);
    expect(bbva.inversiones, [fondo]);
    expect(bbva.tarjetas, [oro]);
    expect(bbva.activos, 6500000);
    expect(bbva.deudas, 800000);
    expect(bbva.neto, 5700000);

    expect(grupos.last.tarjetas, [sinBanco]);
    expect(grupos.last.neto, -100000);
  });

  test('sugiere solo las instituciones con nombre', () {
    final grupos =
        agruparPorInstitucion(cuentas: [nomina], tarjetas: [sinBanco]);
    expect(institucionesUsadas(grupos), ['BBVA']);
  });

  test('el débito es efectivo y el ahorro crece como inversión', () {
    expect(efectivoDeCuentas([nomina, ahorro]), 1500000);
    final inv = ahorrosComoInversiones([nomina, ahorro]).single;
    expect(inv.id, 'ahorro');
    expect(inv.saldoInicial, 2000000);
    expect(inv.tasaAnual, 0.12);
    expect(inv.aporteMensual, 0);
  });
}
