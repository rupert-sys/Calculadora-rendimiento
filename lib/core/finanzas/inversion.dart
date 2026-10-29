import 'dart:math' as math;

import 'dinero.dart';
import 'modelos.dart';

/// Saldo de la inversión al final de cada mes, del mes 1 al [meses].
///
/// Cada mes se capitaliza el interés (tasa anual / 12) sobre el saldo y
/// después se suma el aporte.
List<Centavos> proyectarInversion(Inversion inversion, int meses) {
  final tasaMensual = inversion.tasaAnual / 12;
  var saldo = inversion.saldoInicial;
  final saldos = <Centavos>[];
  for (var i = 0; i < meses; i++) {
    saldo += (saldo * tasaMensual).round();
    saldo += inversion.aporteMensual;
    saldos.add(saldo);
  }
  return saldos;
}

/// Saldo final tras [meses]; con 0 meses es el saldo inicial.
Centavos valorFuturo(Inversion inversion, int meses) {
  if (meses == 0) return inversion.saldoInicial;
  return proyectarInversion(inversion, meses).last;
}

/// Rendimiento real descontando la inflación (ecuación de Fisher).
double tasaReal(double tasaNominal, double inflacion) {
  return (1 + tasaNominal) / (1 + inflacion) - 1;
}

/// Valor de [monto] dentro de [meses], expresado en dinero de hoy.
Centavos aValorPresente(Centavos monto, double inflacionAnual, int meses) {
  return (monto / math.pow(1 + inflacionAnual, meses / 12)).round();
}
