/// Los montos se guardan como enteros en centavos para evitar errores de
/// redondeo de `double` al sumar muchos movimientos.
typedef Centavos = int;

/// Convierte un monto en unidades (ej. 12.34) a centavos, redondeando.
Centavos aCentavos(num monto) => (monto * 100).round();

/// Convierte centavos a unidades para mostrar o graficar.
double aUnidades(Centavos centavos) => centavos / 100;
