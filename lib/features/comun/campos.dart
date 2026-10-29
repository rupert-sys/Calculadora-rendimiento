import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lee "1,234.50" o "1234.5"; `null` si no es un número.
double? leerMonto(String texto) =>
    double.tryParse(texto.replaceAll(',', '').trim());

/// Campo de texto numérico para montos en MXN o porcentajes.
class CampoNumero extends StatelessWidget {
  const CampoNumero({
    super.key,
    required this.controller,
    required this.etiqueta,
    this.prefijo,
    this.sufijo,
    this.permitirCero = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String etiqueta;
  final String? prefijo;
  final String? sufijo;
  final bool permitirCero;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixText: prefijo,
        suffixText: sufijo,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      onChanged: onChanged,
      validator: (v) {
        final n = leerMonto(v ?? '');
        if (n == null) return 'Escribe un número';
        if (!permitirCero && n <= 0) return 'Debe ser mayor a 0';
        return null;
      },
    );
  }
}

/// "2 años 3 meses", "11 meses", "1 año".
String textoMeses(int meses) {
  final anios = meses ~/ 12;
  final resto = meses % 12;
  final partes = [
    if (anios > 0) '$anios ${anios == 1 ? 'año' : 'años'}',
    if (resto > 0 || anios == 0) '$resto ${resto == 1 ? 'mes' : 'meses'}',
  ];
  return partes.join(' ');
}

/// 0.085 → "8.5 %".
String textoTasa(double fraccion) {
  final texto = (fraccion * 100)
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
  return '$texto %';
}

Future<bool> confirmar(
    BuildContext context, String titulo, String mensaje) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
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
