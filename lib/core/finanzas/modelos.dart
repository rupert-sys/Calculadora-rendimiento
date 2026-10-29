import 'dinero.dart';

enum TipoMovimiento { ingreso, egreso }

enum Frecuencia { unica, quincenal, mensual, anual }

class Categoria {
  const Categoria({required this.id, required this.nombre, required this.tipo});

  final String id;
  final String nombre;
  final TipoMovimiento tipo;
}

/// Un ingreso o egreso, único o recurrente.
class Movimiento {
  const Movimiento({
    required this.id,
    required this.tipo,
    required this.descripcion,
    required this.monto,
    required this.categoriaId,
    required this.frecuencia,
    required this.fechaInicio,
    this.fechaFin,
  }) : assert(monto >= 0, 'El monto va en positivo; el tipo da el signo');

  final String id;
  final TipoMovimiento tipo;
  final String descripcion;
  final Centavos monto;
  final String categoriaId;
  final Frecuencia frecuencia;
  final DateTime fechaInicio;

  /// Último día en que el movimiento aplica. `null` = sin fin.
  final DateTime? fechaFin;

  /// Cuánto suma este movimiento en el mes indicado (en positivo).
  Centavos montoEnMes(int anio, int mes) {
    final inicioMes = DateTime(anio, mes);
    final finMes = DateTime(anio, mes + 1, 0);
    final inicio =
        DateTime(fechaInicio.year, fechaInicio.month, fechaInicio.day);
    if (inicio.isAfter(finMes)) return 0;
    final fin = fechaFin;
    if (fin != null &&
        DateTime(fin.year, fin.month, fin.day).isBefore(inicioMes)) {
      return 0;
    }

    switch (frecuencia) {
      case Frecuencia.unica:
        return inicio.year == anio && inicio.month == mes ? monto : 0;
      case Frecuencia.quincenal:
        // Una quincena = dos pagos por mes.
        return monto * 2;
      case Frecuencia.mensual:
        return monto;
      case Frecuencia.anual:
        return inicio.month == mes ? monto : 0;
    }
  }
}

/// Instrumento de inversión con interés compuesto mensual.
class Inversion {
  const Inversion({
    required this.id,
    required this.nombre,
    required this.saldoInicial,
    required this.tasaAnual,
    this.aporteMensual = 0,
  });

  final String id;
  final String nombre;
  final Centavos saldoInicial;

  /// Tasa nominal anual como fracción: 0.08 = 8 %.
  final double tasaAnual;
  final Centavos aporteMensual;
}

/// Tarjeta de crédito. El pago mínimo es el mayor entre un porcentaje del
/// saldo y un monto fijo, sin pasar del saldo.
class TarjetaCredito {
  const TarjetaCredito({
    required this.id,
    required this.nombre,
    required this.saldo,
    required this.tasaAnual,
    this.pagoMinimoPorcentaje = 0.05,
    this.pagoMinimoFijo = 0,
  });

  final String id;
  final String nombre;
  final Centavos saldo;

  /// Tasa nominal anual como fracción: 0.45 = 45 %.
  final double tasaAnual;
  final double pagoMinimoPorcentaje;
  final Centavos pagoMinimoFijo;
}

/// Inflación anual que usa el simulador si no se indica otra.
const inflacionPorDefecto = 0.04;

/// Supuestos generales para proyectar en el tiempo.
class Escenario {
  const Escenario({
    required this.nombre,
    required this.anios,
    this.inflacionAnual = inflacionPorDefecto,
  }) : assert(anios >= 1 && anios <= 30);

  final String nombre;
  final int anios;

  /// Inflación anual como fracción: 0.04 = 4 %.
  final double inflacionAnual;
}
