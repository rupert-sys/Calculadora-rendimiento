import 'dinero.dart';

enum TipoMovimiento { ingreso, egreso }

// Se guarda por índice en la base de datos: los valores nuevos van al final.
enum Frecuencia { unica, quincenal, mensual, anual, semanal, diario }

/// Orden en que se muestran las frecuencias, de la más corta a la más larga.
const frecuenciasEnOrden = [
  Frecuencia.unica,
  Frecuencia.diario,
  Frecuencia.semanal,
  Frecuencia.quincenal,
  Frecuencia.mensual,
  Frecuencia.anual,
];

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
      case Frecuencia.semanal:
        // Cada 7 días desde la fecha de inicio: 4 o 5 veces al mes.
        return monto * _ocurrencias(inicio, inicioMes, finMes, 7);
      case Frecuencia.diario:
        return monto * _ocurrencias(inicio, inicioMes, finMes, 1);
    }
  }

  /// Cuántas veces cae un pago cada [paso] días, contado desde [inicio],
  /// entre [desde] y [hasta] (inclusive) y sin pasar de la fecha de fin.
  int _ocurrencias(DateTime inicio, DateTime desde, DateTime hasta, int paso) {
    final fin = fechaFin;
    if (fin != null) {
      final finDia = DateTime(fin.year, fin.month, fin.day);
      if (finDia.isBefore(hasta)) hasta = finDia;
    }
    if (inicio.isAfter(desde)) desde = inicio;
    final primero = (_dias(inicio, desde) + paso - 1) ~/ paso * paso;
    final ultimo = _dias(inicio, hasta);
    if (primero > ultimo) return 0;
    return (ultimo - primero) ~/ paso + 1;
  }
}

// En UTC para que el horario de verano no cambie la cuenta de días.
int _dias(DateTime a, DateTime b) => DateTime.utc(b.year, b.month, b.day)
    .difference(DateTime.utc(a.year, a.month, a.day))
    .inDays;

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
    this.ajusteIngresos = 0,
    this.ajusteEgresos = 0,
    this.pagoExtraTarjetas = 0,
  }) : assert(anios >= 1 && anios <= 30);

  final String nombre;
  final int anios;

  /// Inflación anual como fracción: 0.04 = 4 %.
  final double inflacionAnual;

  /// "Qué pasa si": cambio en los ingresos, como fracción (0.1 = 10 % más).
  final double ajusteIngresos;

  /// "Qué pasa si": cambio en los egresos, como fracción (-0.1 = 10 % menos).
  final double ajusteEgresos;

  /// Pago adicional al mínimo que se abona cada mes a las tarjetas.
  final Centavos pagoExtraTarjetas;

  Escenario copyWith({
    String? nombre,
    int? anios,
    double? inflacionAnual,
    double? ajusteIngresos,
    double? ajusteEgresos,
    Centavos? pagoExtraTarjetas,
  }) {
    return Escenario(
      nombre: nombre ?? this.nombre,
      anios: anios ?? this.anios,
      inflacionAnual: inflacionAnual ?? this.inflacionAnual,
      ajusteIngresos: ajusteIngresos ?? this.ajusteIngresos,
      ajusteEgresos: ajusteEgresos ?? this.ajusteEgresos,
      pagoExtraTarjetas: pagoExtraTarjetas ?? this.pagoExtraTarjetas,
    );
  }
}
