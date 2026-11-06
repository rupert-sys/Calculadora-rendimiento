import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/proveedores.dart';

/// Nombre del banco o institución, con atajos a los que ya existen para no
/// escribir el mismo banco de dos formas.
class CampoInstitucion extends ConsumerWidget {
  const CampoInstitucion({
    super.key,
    required this.controller,
    this.obligatorio = false,
  });

  final TextEditingController controller;
  final bool obligatorio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existentes = ref.watch(institucionesProvider);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, valor, _) {
        final escrito = valor.text.trim().toLowerCase();
        final sugerencias = [
          for (final n in existentes)
            if (n.toLowerCase() != escrito && n.toLowerCase().contains(escrito))
              n,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Institución',
                hintText: 'Banco, casa de bolsa o fintech',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => obligatorio && (v == null || v.trim().isEmpty)
                  ? 'Escribe el nombre del banco'
                  : null,
            ),
            if (sugerencias.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final n in sugerencias)
                      ActionChip(
                        label: Text(n),
                        onPressed: () => controller.text = n,
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
