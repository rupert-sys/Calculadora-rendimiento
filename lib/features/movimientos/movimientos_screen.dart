import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../inversiones/inversion_form_screen.dart';
import 'movimiento_form_screen.dart';
import 'textos.dart';

class MovimientosScreen extends ConsumerWidget {
  const MovimientosScreen({super.key});

  Future<void> _abrirFormulario(BuildContext context, [Movimiento? m]) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovimientoFormScreen(movimiento: m)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movimientos = ref.watch(movimientosProvider);
    final inversiones = ref.watch(inversionesProvider).valueOrNull ?? const [];
    final automaticos = rendimientosComoIngresos(inversiones);

    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'agregar-movimientos',
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: movimientos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudieron cargar: $e')),
        data: (lista) {
          if (lista.isEmpty && automaticos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aún no hay movimientos. Agrega tu sueldo y tus gastos fijos para empezar.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              for (final m in automaticos) ...[
                _FilaRendimiento(
                  movimiento: m,
                  inversion: inversiones
                      .firstWhere((i) => m.id == 'rendimiento-${i.id}'),
                ),
                const Divider(height: 1),
              ],
              for (final m in lista) ...[
                _FilaMovimiento(
                  movimiento: m,
                  onTap: () => _abrirFormulario(context, m),
                ),
                const Divider(height: 1),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Ingreso que genera una inversión al depositar su rendimiento. Se edita
/// desde la inversión, no se borra aquí.
class _FilaRendimiento extends ConsumerWidget {
  const _FilaRendimiento({required this.movimiento, required this.inversion});

  final Movimiento movimiento;
  final Inversion inversion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = movimiento;
    final cuenta = ref.watch(productosProvider)[m.cuentaId];
    final color = Colors.green.shade700;
    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InversionFormScreen(inversion: inversion),
        ),
      ),
      leading: Icon(Icons.autorenew, color: color),
      title: Text(m.descripcion),
      subtitle: Text(
        'Automático · ${textoFrecuencia(m.frecuencia)}'
        '${cuenta == null ? '' : ' · a $cuenta'}',
      ),
      trailing: Text(
        '+${formatearPesos(m.monto)}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _FilaMovimiento extends ConsumerWidget {
  const _FilaMovimiento({required this.movimiento, required this.onTap});

  final Movimiento movimiento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = movimiento;
    final esIngreso = m.tipo == TipoMovimiento.ingreso;
    final colores = Theme.of(context).colorScheme;
    final color = esIngreso ? Colors.green.shade700 : colores.error;
    final cuenta = ref.watch(productosProvider)[m.cuentaId];

    return Dismissible(
      key: ValueKey(m.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: colores.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(Icons.delete, color: colores.onErrorContainer),
      ),
      confirmDismiss: (_) => confirmarBorrado(context, m),
      onDismissed: (_) => ref.read(movimientosRepositorioProvider).borrar(m.id),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
        title: Text(m.descripcion),
        subtitle: Text(
          '${nombreCategoria(m.categoriaId)} · ${textoFrecuencia(m.frecuencia)}'
          ' · desde ${textoFecha(m.fechaInicio)}'
          '${cuenta == null ? '' : '\n$cuenta'}',
        ),
        isThreeLine: cuenta != null,
        trailing: Text(
          '${esIngreso ? '+' : '-'}${formatearPesos(m.monto)}',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

Future<bool> confirmarBorrado(BuildContext context, Movimiento m) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Borrar movimiento?'),
      content: Text('Se borrará "${m.descripcion}".'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Borrar'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
