import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/finanzas/flujo.dart';
import '../core/finanzas/modelos.dart';
import 'base_datos.dart';
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

final resumenMensualProvider = Provider<AsyncValue<ResumenMensual>>((ref) {
  final mes = ref.watch(mesSeleccionadoProvider);
  return ref
      .watch(movimientosProvider)
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
