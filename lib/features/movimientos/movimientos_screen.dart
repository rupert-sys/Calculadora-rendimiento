import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: movimientos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudieron cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
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
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => _FilaMovimiento(
              movimiento: lista[i],
              onTap: () => _abrirFormulario(context, lista[i]),
            ),
          );
        },
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
          ' · desde ${textoFecha(m.fechaInicio)}',
        ),
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
