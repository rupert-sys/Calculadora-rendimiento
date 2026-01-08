import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final montoCtrl = TextEditingController();
  final porcentajeCtrl = TextEditingController();
  double resultado = 0;

  void calcular() {
    final monto = double.tryParse(montoCtrl.text) ?? 0;
    final porcentaje = double.tryParse(porcentajeCtrl.text) ?? 0;

    setState(() {
      resultado = monto * (porcentaje / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Rendimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: montoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto'),
            ),
            TextField(
              controller: porcentajeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rendimiento %'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcular,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            Text(
              'Ganancia: \$${resultado.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
