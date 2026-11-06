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

/// Cuánto gana la inversión hoy. Si deposita sus rendimientos no hay
/// interés sobre interés: cada pago es saldo × tasa / pagos al año.
Rendimientos rendimientosDeInversion(Inversion i) {
  if (!i.depositaRendimientos) {
    return rendimientosDe(i.saldoInicial, i.tasaAnual, i.capitalizacion);
  }
  Centavos en(double fraccionDeAnio) =>
      (i.saldoInicial * i.tasaAnual * fraccionDeAnio).round();
  return Rendimientos(
    dia: en(1 / 365),
    semana: en(7 / 365),
    mes: en(1 / 12),
    anio: en(1),
  );
}

/// Los rendimientos que se depositan en una cuenta, como ingresos
/// recurrentes con la periodicidad de pago de cada inversión.
List<Movimiento> rendimientosComoIngresos(List<Inversion> inversiones) => [
      for (final i in inversiones)
        if (i.depositaRendimientos && i.saldoInicial > 0 && i.tasaAnual > 0)
          Movimiento(
            id: 'rendimiento-${i.id}',
            tipo: TipoMovimiento.ingreso,
            descripcion: 'Rendimiento de ${i.nombre}',
            monto: (i.saldoInicial *
                    i.tasaAnual /
                    periodosPorAnio(i.capitalizacion))
                .round(),
            categoriaId: 'inversiones',
            frecuencia: switch (i.capitalizacion) {
              Capitalizacion.diaria => Frecuencia.diario,
              Capitalizacion.semanal => Frecuencia.semanal,
              Capitalizacion.mensual => Frecuencia.mensual,
              Capitalizacion.anual => Frecuencia.anual,
            },
            fechaInicio: DateTime(2000, 1, 1),
            cuentaId: i.cuentaDestinoId,
          ),
    ];

/// `true` si el movimiento lo genera una inversión y no se captura a mano.
bool esRendimientoAutomatico(Movimiento m) => m.id.startsWith('rendimiento-');

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
/// el aporte. Si los rendimientos se depositan en una cuenta, el saldo solo
/// crece con los aportes.
List<Centavos> proyectarInversion(Inversion inversion, int meses) {
  final tasaMensual = inversion.depositaRendimientos
      ? 0.0
      : tasaMensualEquivalente(inversion.tasaAnual, inversion.capitalizacion);
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
