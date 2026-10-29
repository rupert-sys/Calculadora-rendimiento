import 'dinero.dart';
import 'modelos.dart';

/// Totales de un mes calendario.
class ResumenMensual {
  const ResumenMensual({
    required this.ingresos,
    required this.egresos,
    required this.porCategoria,
  });

  final Centavos ingresos;
  final Centavos egresos;

  /// Monto del mes por id de categoría (en positivo).
  final Map<String, Centavos> porCategoria;

  Centavos get neto => ingresos - egresos;

  /// Fracción de los ingresos que queda sin gastar; 0 si no hay ingresos.
  double get tasaAhorro => ingresos == 0 ? 0 : neto / ingresos;
}

ResumenMensual flujoMensual(List<Movimiento> movimientos, int anio, int mes) {
  var ingresos = 0;
  var egresos = 0;
  final porCategoria = <String, Centavos>{};

  for (final m in movimientos) {
    final monto = m.montoEnMes(anio, mes);
    if (monto == 0) continue;
    if (m.tipo == TipoMovimiento.ingreso) {
      ingresos += monto;
    } else {
      egresos += monto;
    }
    porCategoria.update(m.categoriaId, (v) => v + monto, ifAbsent: () => monto);
  }

  return ResumenMensual(
    ingresos: ingresos,
    egresos: egresos,
    porCategoria: porCategoria,
  );
}
