import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../movimientos/movimiento_form_screen.dart';
import '../movimientos/textos.dart';

/// Ingresos y egresos ligados a una cuenta, inversión o tarjeta, con lo que
/// suman en el mes actual.
class MovimientosLigados extends ConsumerWidget {
  const MovimientosLigados({super.key, required this.productoId});

  final String productoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(movimientosProvider).valueOrNull ?? const [];
    final ligados = todos.where((m) => m.cuentaId == productoId).toList();
    final estilos = Theme.of(context).textTheme;

    final hoy = DateTime.now();
    var neto = 0;
    for (final m in ligados) {
      final monto = m.montoEnMes(hoy.year, hoy.month);
      neto += m.tipo == TipoMovimiento.ingreso ? monto : -monto;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Movimientos ligados', style: estilos.titleMedium),
        const SizedBox(height: 4),
        if (ligados.isEmpty)
          Text(
            'Ninguno. Al capturar un movimiento elige esta cuenta en '
            '"Cuenta o tarjeta".',
            style: estilos.bodySmall,
          )
        else ...[
          Text(
            'Este mes: ${neto >= 0 ? '+' : '-'}${formatearPesos(neto.abs())}',
            style: estilos.bodyMedium,
          ),
          for (final m in ligados)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(m.descripcion),
              subtitle: Text(textoFrecuencia(m.frecuencia)),
              trailing: Text(
                '${m.tipo == TipoMovimiento.ingreso ? '+' : '-'}'
                '${formatearPesos(m.monto)}',
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MovimientoFormScreen(movimiento: m),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
