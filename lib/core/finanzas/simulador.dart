import 'dart:math' as math;

import 'dinero.dart';
import 'flujo.dart';
import 'inversion.dart';
import 'modelos.dart';
import 'tarjeta.dart';

/// Estado de las finanzas al cierre de un mes simulado.
class PuntoSimulacion {
  const PuntoSimulacion({
    required this.mes,
    required this.fecha,
    required this.efectivo,
    required this.inversiones,
    required this.deuda,
    required this.flujoNeto,
    required this.inflacionAnual,
  });

  /// 1 = primer mes simulado.
  final int mes;

  /// Primer día del mes calendario.
  final DateTime fecha;

  /// Dinero acumulado fuera de inversiones (puede ser negativo).
  final Centavos efectivo;
  final Centavos inversiones;
  final Centavos deuda;

  /// Ingresos menos egresos del mes, antes de aportes y pagos de tarjeta.
  final Centavos flujoNeto;
  final double inflacionAnual;

  Centavos get patrimonio => efectivo + inversiones - deuda;

  /// Patrimonio expresado en pesos de hoy.
  Centavos get patrimonioReal =>
      aValorPresente(patrimonio, inflacionAnual, mes);
}

/// Resultado de una simulación completa.
class ResultadoSimulacion {
  const ResultadoSimulacion(this.escenario, this.puntos,
      {this.deudaInicial = 0});

  final Escenario escenario;
  final List<PuntoSimulacion> puntos;
  final Centavos deudaInicial;

  PuntoSimulacion get ultimo => puntos.last;

  /// Primer mes con la deuda en cero; `null` si no había deuda o no se salda
  /// dentro del plazo simulado.
  int? get mesSinDeuda {
    if (deudaInicial == 0) return null;
    for (final p in puntos) {
      if (p.deuda == 0) return p.mes;
    }
    return null;
  }
}

/// Proyecta mes a mes ingresos, egresos, inversiones y tarjetas.
///
/// Cada mes:
/// 1. Suma el flujo de los movimientos (con los ajustes del escenario).
/// 2. Las inversiones capitalizan su interés y reciben su aporte, que sale
///    del efectivo.
/// 3. Las tarjetas cargan su interés y se paga el mínimo más el pago extra
///    del escenario (repartido en orden, primero la de tasa más alta).
///
/// Los montos de los movimientos no crecen con la inflación; el patrimonio
/// real ([PuntoSimulacion.patrimonioReal]) muestra cuánto vale en pesos de hoy.
ResultadoSimulacion simular({
  required Escenario escenario,
  required DateTime inicio,
  List<Movimiento> movimientos = const [],
  List<Inversion> inversiones = const [],
  List<TarjetaCredito> tarjetas = const [],
  Centavos efectivoInicial = 0,
}) {
  final saldosInv = [for (final i in inversiones) i.saldoInicial];
  final ordenTarjetas = [...tarjetas]
    ..sort((a, b) => b.tasaAnual.compareTo(a.tasaAnual));
  final saldosTar = [for (final t in ordenTarjetas) t.saldo];
  var efectivo = efectivoInicial;
  final puntos = <PuntoSimulacion>[];

  for (var mes = 1; mes <= escenario.anios * 12; mes++) {
    final fecha = DateTime(inicio.year, inicio.month + mes - 1);
    final r = flujoMensual(movimientos, fecha.year, fecha.month);
    final ingresos = (r.ingresos * (1 + escenario.ajusteIngresos)).round();
    final egresos = (r.egresos * (1 + escenario.ajusteEgresos)).round();
    final flujo = ingresos - egresos;
    efectivo += flujo;

    for (var i = 0; i < inversiones.length; i++) {
      final inv = inversiones.elementAt(i);
      final saldo = saldosInv.elementAt(i);
      saldosInv[i] =
          saldo + (saldo * inv.tasaAnual / 12).round() + inv.aporteMensual;
      efectivo -= inv.aporteMensual;
    }

    var extra = escenario.pagoExtraTarjetas;
    for (var i = 0; i < ordenTarjetas.length; i++) {
      final t = ordenTarjetas.elementAt(i);
      var saldo = saldosTar.elementAt(i);
      if (saldo == 0) continue;
      saldo += (saldo * t.tasaAnual / 12).round();
      final minimo = pagoMinimo(t, saldo);
      final pago = math.min(minimo + extra, saldo);
      extra = math.max(0, extra - math.max(0, pago - minimo));
      saldo -= pago;
      efectivo -= pago;
      saldosTar[i] = saldo;
    }

    puntos.add(
      PuntoSimulacion(
        mes: mes,
        fecha: fecha,
        efectivo: efectivo,
        inversiones: saldosInv.fold(0, (a, b) => a + b),
        deuda: saldosTar.fold(0, (a, b) => a + b),
        flujoNeto: flujo,
        inflacionAnual: escenario.inflacionAnual,
      ),
    );
  }

  return ResultadoSimulacion(
    escenario,
    puntos,
    deudaInicial: tarjetas.fold(0, (a, t) => a + t.saldo),
  );
}
