import 'dart:math' as math;

import 'dinero.dart';
import 'modelos.dart';

int periodosPorAnio(Capitalizacion c) => switch (c) {
      Capitalizacion.diaria => 365,
      Capitalizacion.semanal => 52,
      Capitalizacion.mensual => 12,
      Capitalizacion.anual => 1,
    };

/// Lo que de verdad crece en un año una tasa nominal [tasaAnual] que se
/// reinvierte con la periodicidad [c]: 12 % mensual = 12.68 % efectivo.
double tasaEfectivaAnual(double tasaAnual, Capitalizacion c) {
  final n = periodosPorAnio(c);
  return math.pow(1 + tasaAnual / n, n) - 1;
}

/// Tasa de un mes que da el mismo crecimiento anual que [c].
double tasaMensualEquivalente(double tasaAnual, Capitalizacion c) {
  if (c == Capitalizacion.mensual) return tasaAnual / 12;
  return math.pow(1 + tasaEfectivaAnual(tasaAnual, c), 1 / 12) - 1;
}

/// Ganancia en pesos de un saldo en un día, una semana, un mes y un año.
class Rendimientos {
  const Rendimientos({
    this.dia = 0,
    this.semana = 0,
    this.mes = 0,
    this.anio = 0,
  });

  final Centavos dia;
  final Centavos semana;
  final Centavos mes;
  final Centavos anio;

  Rendimientos operator +(Rendimientos o) => Rendimientos(
        dia: dia + o.dia,
        semana: semana + o.semana,
        mes: mes + o.mes,
        anio: anio + o.anio,
      );
}

/// Cuánto gana [saldo] a la [tasaAnual] con capitalización [c], sin aportes.
Rendimientos rendimientosDe(
    Centavos saldo, double tasaAnual, Capitalizacion c) {
  final efectiva = tasaEfectivaAnual(tasaAnual, c);
  Centavos en(double fraccionDeAnio) =>
      (saldo * (math.pow(1 + efectiva, fraccionDeAnio) - 1)).round();
  return Rendimientos(
    dia: en(1 / 365),
    semana: en(7 / 365),
    mes: en(1 / 12),
    anio: en(1),
  );
}

/// Saldo de la inversión al final de cada mes, del mes 1 al [meses].
///
/// Cada mes se suma el interés equivalente a su capitalización y después
/// el aporte.
List<Centavos> proyectarInversion(Inversion inversion, int meses) {
  final tasaMensual =
      tasaMensualEquivalente(inversion.tasaAnual, inversion.capitalizacion);
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
