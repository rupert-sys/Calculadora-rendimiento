import 'package:intl/intl.dart';

/// Los montos se guardan como enteros en centavos para evitar errores de
/// redondeo de `double` al sumar muchos movimientos.
typedef Centavos = int;

/// Convierte un monto en unidades (ej. 12.34) a centavos, redondeando.
Centavos aCentavos(num monto) => (monto * 100).round();

/// Convierte centavos a unidades para mostrar o graficar.
double aUnidades(Centavos centavos) => centavos / 100;

/// La app trabaja en pesos mexicanos.
const codigoMoneda = 'MXN';

final _formatoMXN = NumberFormat.currency(
  locale: 'es_MX',
  symbol: r'$',
  decimalDigits: 2,
);

/// Formatea centavos como pesos mexicanos: 123456 → "$1,234.56".
String formatearPesos(Centavos centavos) =>
    _formatoMXN.format(aUnidades(centavos));
