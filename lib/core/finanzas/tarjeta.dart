import 'dart:math' as math;

import 'dinero.dart';
import 'modelos.dart';

/// Resultado de pagar una tarjeta hasta dejarla en cero.
class ResultadoTarjeta {
  const ResultadoTarjeta({
    required this.meses,
    required this.interesesTotales,
    required this.pagadoTotal,
    required this.saldos,
  });

  /// Meses hasta saldar. `null` si el pago no alcanza a cubrir los intereses
  /// o la deuda supera el límite de meses simulados.
  final int? meses;
  final Centavos interesesTotales;
  final Centavos pagadoTotal;

  /// Saldo al final de cada mes simulado.
  final List<Centavos> saldos;

  bool get seSalda => meses != null;
}

/// Pago mínimo para un [saldo] según las reglas de la [tarjeta].
Centavos pagoMinimo(TarjetaCredito tarjeta, Centavos saldo) {
  final porcentaje = (saldo * tarjeta.pagoMinimoPorcentaje).round();
  final minimo = math.max(porcentaje, tarjeta.pagoMinimoFijo);
  return minimo > saldo ? saldo : minimo;
}

/// Simula pagar la tarjeta sin nuevas compras.
///
/// Con [pagoMensual] paga ese monto fijo cada mes; sin él paga el mínimo.
/// Cada mes se cargan intereses (tasa anual / 12) y después se paga.
ResultadoTarjeta simularTarjeta(
  TarjetaCredito tarjeta, {
  Centavos? pagoMensual,
  int maxMeses = 600,
}) {
  final tasaMensual = tarjeta.tasaAnual / 12;
  var saldo = tarjeta.saldo;
  var intereses = 0;
  var pagado = 0;
  final saldos = <Centavos>[];

  for (var mes = 1; mes <= maxMeses && saldo > 0; mes++) {
    final interes = (saldo * tasaMensual).round();
    saldo += interes;
    intereses += interes;

    // El mínimo siempre cubre al menos el interés del mes más un centavo,
    // para que el redondeo no deje un saldo chico atascado.
    var pago = pagoMensual ?? math.max(pagoMinimo(tarjeta, saldo), interes + 1);
    if (pago > saldo) pago = saldo;
    if (pago <= interes && pago < saldo) {
      // El pago no cubre los intereses: la deuda nunca baja.
      saldos.add(saldo - pago);
      return ResultadoTarjeta(
        meses: null,
        interesesTotales: intereses,
        pagadoTotal: pagado + pago,
        saldos: saldos,
      );
    }
    saldo -= pago;
    pagado += pago;
    saldos.add(saldo);
  }

  return ResultadoTarjeta(
    meses: saldo == 0 ? saldos.length : null,
    interesesTotales: intereses,
    pagadoTotal: pagado,
    saldos: saldos,
  );
}
