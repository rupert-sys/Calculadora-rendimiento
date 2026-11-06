import 'dinero.dart';
import 'modelos.dart';

/// Los productos que alguien tiene en una misma institución.
class GrupoInstitucion {
  const GrupoInstitucion({
    required this.institucion,
    this.cuentas = const [],
    this.inversiones = const [],
    this.tarjetas = const [],
  });

  /// Nombre de la institución; vacío para los productos sin institución.
  final String institucion;
  final List<Cuenta> cuentas;
  final List<Inversion> inversiones;
  final List<TarjetaCredito> tarjetas;

  Centavos get activos =>
      cuentas.fold<int>(0, (s, c) => s + c.saldo) +
      inversiones.fold<int>(0, (s, i) => s + i.saldoInicial);

  Centavos get deudas => tarjetas.fold<int>(0, (s, t) => s + t.saldo);

  Centavos get neto => activos - deudas;
}

/// Agrupa los productos por institución, en orden alfabético y con los que
/// no tienen institución al final. Los nombres se comparan sin importar
/// mayúsculas ni espacios de más.
List<GrupoInstitucion> agruparPorInstitucion({
  List<Cuenta> cuentas = const [],
  List<Inversion> inversiones = const [],
  List<TarjetaCredito> tarjetas = const [],
}) {
  final nombres = <String, String>{};
  String clave(String nombre) {
    final limpio = nombre.trim();
    final k = limpio.toLowerCase();
    nombres.putIfAbsent(k, () => limpio);
    return k;
  }

  final c = <String, List<Cuenta>>{};
  final i = <String, List<Inversion>>{};
  final t = <String, List<TarjetaCredito>>{};
  for (final x in cuentas) {
    (c[clave(x.institucion)] ??= []).add(x);
  }
  for (final x in inversiones) {
    (i[clave(x.institucion)] ??= []).add(x);
  }
  for (final x in tarjetas) {
    (t[clave(x.institucion)] ??= []).add(x);
  }

  final claves = nombres.keys.toList()
    ..sort((a, b) {
      if (a.isEmpty != b.isEmpty) return a.isEmpty ? 1 : -1;
      return a.compareTo(b);
    });
  return [
    for (final k in claves)
      GrupoInstitucion(
        institucion: nombres[k]!,
        cuentas: c[k] ?? const [],
        inversiones: i[k] ?? const [],
        tarjetas: t[k] ?? const [],
      ),
  ];
}

/// Nombres de institución ya usados, sin repetir, en orden alfabético.
List<String> institucionesUsadas(List<GrupoInstitucion> grupos) => [
      for (final g in grupos)
        if (g.institucion.isNotEmpty) g.institucion,
    ];

/// Saldo de las cuentas de débito: es el efectivo con que arranca el
/// simulador.
Centavos efectivoDeCuentas(List<Cuenta> cuentas) => cuentas
    .where((c) => c.tipo == TipoCuenta.debito)
    .fold<int>(0, (s, c) => s + c.saldo);

/// Las cuentas de ahorro crecen con su tasa, igual que una inversión sin
/// aportes.
List<Inversion> ahorrosComoInversiones(List<Cuenta> cuentas) => [
      for (final c in cuentas)
        if (c.tipo == TipoCuenta.ahorro)
          Inversion(
            id: c.id,
            nombre: c.nombre,
            saldoInicial: c.saldo,
            tasaAnual: c.tasaAnual,
            institucion: c.institucion,
          ),
    ];
