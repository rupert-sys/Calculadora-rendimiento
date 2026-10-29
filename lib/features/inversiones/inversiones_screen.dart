import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import 'inversion_form_screen.dart';

class InversionesScreen extends ConsumerWidget {
  const InversionesScreen({super.key});

  Future<void> _abrir(BuildContext context, [Inversion? i]) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => InversionFormScreen(inversion: i)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inversiones = ref.watch(inversionesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inversiones')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'agregar-inversiones',
        onPressed: () => _abrir(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: inversiones.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudieron cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Agrega una inversión (pagaré, Cetes, fondo, ahorro) para ver cuánto crece.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final total = lista.fold<int>(0, (s, i) => s + i.saldoInicial);
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              ListTile(
                title: const Text('Total invertido hoy'),
                trailing: Text(
                  formatearPesos(total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              for (final i in lista)
                ListTile(
                  onTap: () => _abrir(context, i),
                  leading: const Icon(Icons.savings_outlined),
                  title: Text(i.nombre),
                  subtitle: Text(
                    '${textoTasa(i.tasaAnual)} anual'
                    '${i.aporteMensual > 0 ? ' · +${formatearPesos(i.aporteMensual)} al mes' : ''}'
                    '\nEn 5 años: ${formatearPesos(valorFuturo(i, 60))}',
                  ),
                  isThreeLine: true,
                  trailing: Text(formatearPesos(i.saldoInicial)),
                ),
            ],
          );
        },
      ),
    );
  }
}
