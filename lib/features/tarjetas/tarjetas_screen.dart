import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../core/finanzas/tarjeta.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import 'tarjeta_form_screen.dart';

class TarjetasScreen extends ConsumerWidget {
  const TarjetasScreen({super.key});

  Future<void> _abrir(BuildContext context, [TarjetaCredito? t]) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TarjetaFormScreen(tarjeta: t)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarjetas = ref.watch(tarjetasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarjetas de crédito')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'agregar-tarjetas',
        onPressed: () => _abrir(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: tarjetas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudieron cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Agrega tu tarjeta para ver cuánto pagas de intereses si solo cubres el mínimo.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final deuda = lista.fold<int>(0, (s, t) => s + t.saldo);
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              ListTile(
                title: const Text('Deuda total'),
                trailing: Text(
                  formatearPesos(deuda),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              for (final t in lista)
                ListTile(
                  onTap: () => _abrir(context, t),
                  leading: const Icon(Icons.credit_card),
                  title: Text(t.nombre),
                  subtitle: Text(
                    '${textoTasa(t.tasaAnual)} anual · '
                    'mínimo ${formatearPesos(pagoMinimo(t, t.saldo))}',
                  ),
                  trailing: Text(formatearPesos(t.saldo)),
                ),
            ],
          );
        },
      ),
    );
  }
}
