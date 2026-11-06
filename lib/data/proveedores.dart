import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/finanzas/cuentas.dart';
import '../core/finanzas/flujo.dart';
import '../core/finanzas/inversion.dart';
import '../core/finanzas/modelos.dart';
import 'base_datos.dart';
import 'cuentas_repositorio.dart';
import 'inversiones_repositorio.dart';
import 'movimientos_repositorio.dart';
import 'tarjetas_repositorio.dart';

final baseDatosProvider = Provider<BaseDatos>((ref) {
  final db = BaseDatos();
  ref.onDispose(db.close);
  return db;
});

final movimientosRepositorioProvider = Provider<MovimientosRepositorio>(
  (ref) => MovimientosRepositorio(ref.watch(baseDatosProvider)),
);

final movimientosProvider = StreamProvider<List<Movimiento>>(
  (ref) => ref.watch(movimientosRepositorioProvider).observarTodos(),
);

/// Primer día del mes que se está viendo en el resumen.
final mesSeleccionadoProvider = StateProvider<DateTime>((ref) {
  final hoy = DateTime.now();
  return DateTime(hoy.year, hoy.month);
});

/// Movimientos capturados más los rendimientos que las inversiones depositan
/// en una cuenta como ingreso.
final movimientosConRendimientosProvider =
    Provider<AsyncValue<List<Movimiento>>>((ref) {
  final inversiones = ref.watch(inversionesProvider).valueOrNull ?? const [];
  return ref
      .watch(movimientosProvider)
      .whenData((movs) => [...movs, ...rendimientosComoIngresos(inversiones)]);
});

final resumenMensualProvider = Provider<AsyncValue<ResumenMensual>>((ref) {
  final mes = ref.watch(mesSeleccionadoProvider);
  return ref
      .watch(movimientosConRendimientosProvider)
      .whenData((movs) => flujoMensual(movs, mes.year, mes.month));
});

final inversionesRepositorioProvider = Provider<InversionesRepositorio>(
  (ref) => InversionesRepositorio(ref.watch(baseDatosProvider)),
);

final inversionesProvider = StreamProvider<List<Inversion>>(
  (ref) => ref.watch(inversionesRepositorioProvider).observarTodas(),
);

final tarjetasRepositorioProvider = Provider<TarjetasRepositorio>(
  (ref) => TarjetasRepositorio(ref.watch(baseDatosProvider)),
);

final tarjetasProvider = StreamProvider<List<TarjetaCredito>>(
  (ref) => ref.watch(tarjetasRepositorioProvider).observarTodas(),
);

final cuentasRepositorioProvider = Provider<CuentasRepositorio>(
  (ref) => CuentasRepositorio(ref.watch(baseDatosProvider)),
);

final cuentasProvider = StreamProvider<List<Cuenta>>(
  (ref) => ref.watch(cuentasRepositorioProvider).observarTodas(),
);

/// Cuentas, inversiones, tarjetas y movimientos juntos, cuando ya cargaron
/// todos.
final datosFinancierosProvider = Provider<
    AsyncValue<
        ({
          List<Movimiento> movimientos,
          List<Cuenta> cuentas,
          List<Inversion> inversiones,
          List<TarjetaCredito> tarjetas,
        })>>((ref) {
  final movs = ref.watch(movimientosProvider);
  final cuen = ref.watch(cuentasProvider);
  final invs = ref.watch(inversionesProvider);
  final tars = ref.watch(tarjetasProvider);
  for (final v in [movs, cuen, invs, tars]) {
    if (v.hasError) return AsyncValue.error(v.error!, v.stackTrace!);
  }
  if (!movs.hasValue || !cuen.hasValue || !invs.hasValue || !tars.hasValue) {
    return const AsyncValue.loading();
  }
  return AsyncValue.data((
    movimientos: movs.requireValue,
    cuentas: cuen.requireValue,
    inversiones: invs.requireValue,
    tarjetas: tars.requireValue,
  ));
});

/// Productos agrupados por institución, para la pantalla de cuentas.
final gruposInstitucionProvider =
    Provider<AsyncValue<List<GrupoInstitucion>>>((ref) {
  return ref
      .watch(datosFinancierosProvider)
      .whenData((d) => agruparPorInstitucion(
            cuentas: d.cuentas,
            inversiones: d.inversiones,
            tarjetas: d.tarjetas,
          ));
});

/// Nombres de institución ya capturados, para sugerirlos en los formularios.
final institucionesProvider = Provider<List<String>>((ref) {
  return institucionesUsadas(
      ref.watch(gruposInstitucionProvider).valueOrNull ?? const []);
});

/// Etiqueta de cada cuenta, inversión y tarjeta por su id, en el orden de
/// la pantalla de cuentas. Para ligar movimientos a un producto.
final productosProvider = Provider<Map<String, String>>((ref) {
  final grupos = ref.watch(gruposInstitucionProvider).valueOrNull ?? const [];
  String etiqueta(String institucion, String nombre) =>
      institucion.isEmpty ? nombre : '$institucion · $nombre';
  return {
    for (final g in grupos) ...{
      for (final c in g.cuentas) c.id: etiqueta(g.institucion, c.nombre),
      for (final i in g.inversiones) i.id: etiqueta(g.institucion, i.nombre),
      for (final t in g.tarjetas) t.id: etiqueta(g.institucion, t.nombre),
    },
  };
});
