import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/flujo.dart';
import '../../data/proveedores.dart';
import '../movimientos/textos.dart';

class ResumenScreen extends ConsumerWidget {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mes = ref.watch(mesSeleccionadoProvider);
    final resumen = ref.watch(resumenMensualProvider);

    void moverMes(int delta) {
      ref.read(mesSeleccionadoProvider.notifier).state =
          DateTime(mes.year, mes.month + delta);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Mes anterior',
                onPressed: () => moverMes(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${nombresMes.elementAt(mes.month - 1)} ${mes.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                tooltip: 'Mes siguiente',
                onPressed: () => moverMes(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          resumen.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('No se pudo calcular: $e'),
            data: (r) => _Contenido(resumen: r),
          ),
        ],
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.resumen});

  final ResumenMensual resumen;

  @override
  Widget build(BuildContext context) {
    final r = resumen;
    final categorias = r.porCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Cifra(titulo: 'Ingresos', valor: formatearPesos(r.ingresos)),
            _Cifra(titulo: 'Egresos', valor: formatearPesos(r.egresos)),
            _Cifra(titulo: 'Neto', valor: formatearPesos(r.neto)),
            _Cifra(
              titulo: 'Ahorro',
              valor: '${(r.tasaAhorro * 100).toStringAsFixed(0)} %',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Por categoría', style: Theme.of(context).textTheme.titleMedium),
        if (categorias.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Sin movimientos este mes.'),
          ),
        for (final c in categorias)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(nombreCategoria(c.key)),
            trailing: Text(formatearPesos(c.value)),
          ),
      ],
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: texto.labelMedium),
              const SizedBox(height: 4),
              Text(valor, style: texto.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
