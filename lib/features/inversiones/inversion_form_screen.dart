import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';

/// Crea o edita una inversión y muestra cuánto valdrá en el tiempo.
class InversionFormScreen extends ConsumerStatefulWidget {
  const InversionFormScreen({super.key, this.inversion});

  final Inversion? inversion;

  @override
  ConsumerState<InversionFormScreen> createState() =>
      _InversionFormScreenState();
}

class _InversionFormScreenState extends ConsumerState<InversionFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _saldo;
  late final TextEditingController _tasa;
  late final TextEditingController _aporte;

  @override
  void initState() {
    super.initState();
    final i = widget.inversion;
    _nombre = TextEditingController(text: i?.nombre ?? '');
    _saldo = TextEditingController(
      text: i == null ? '' : aUnidades(i.saldoInicial).toStringAsFixed(2),
    );
    _tasa = TextEditingController(
      text: i == null ? '' : (i.tasaAnual * 100).toStringAsFixed(2),
    );
    _aporte = TextEditingController(
      text: i == null ? '0' : aUnidades(i.aporteMensual).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _saldo.dispose();
    _tasa.dispose();
    _aporte.dispose();
    super.dispose();
  }

  /// La inversión con lo capturado; `null` si algún número no es válido.
  Inversion? _leer() {
    final saldo = leerMonto(_saldo.text);
    final tasa = leerMonto(_tasa.text);
    final aporte = leerMonto(_aporte.text);
    if (saldo == null || tasa == null || aporte == null) return null;
    return Inversion(
      id: widget.inversion?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: _nombre.text.trim(),
      saldoInicial: aCentavos(saldo),
      tasaAnual: tasa / 100,
      aporteMensual: aCentavos(aporte),
    );
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    await ref.read(inversionesRepositorioProvider).guardar(_leer()!);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _borrar() async {
    final i = widget.inversion!;
    final ok = await confirmar(
      context,
      '¿Borrar inversión?',
      'Se borrará "${i.nombre}".',
    );
    if (!ok) return;
    await ref.read(inversionesRepositorioProvider).borrar(i.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final actual = _leer();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.inversion == null ? 'Nueva inversión' : 'Editar inversión'),
        actions: [
          if (widget.inversion != null)
            IconButton(
              tooltip: 'Borrar',
              onPressed: _borrar,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _saldo,
              etiqueta: 'Saldo actual (MXN)',
              prefijo: r'$ ',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _tasa,
              etiqueta: 'Rendimiento anual',
              sufijo: '%',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _aporte,
              etiqueta: 'Aporte mensual (MXN)',
              prefijo: r'$ ',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            if (actual != null) _Proyeccion(inversion: actual),
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}

/// Valor a 1, 5 y 10 años, también en pesos de hoy con la inflación por defecto.
class _Proyeccion extends StatelessWidget {
  const _Proyeccion({required this.inversion});

  final Inversion inversion;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final real = tasaReal(inversion.tasaAnual, inflacionPorDefecto);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Proyección', style: texto.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Rendimiento real: ${textoTasa(real)} anual, descontando '
              '${textoTasa(inflacionPorDefecto)} de inflación.',
              style: texto.bodySmall,
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {0: IntrinsicColumnWidth()},
              children: [
                TableRow(
                  children: [
                    const SizedBox(),
                    _celda('Valor', texto.labelMedium, derecha: true),
                    _celda('En pesos de hoy', texto.labelMedium, derecha: true),
                  ],
                ),
                for (final anios in const [1, 5, 10])
                  TableRow(
                    children: [
                      _celda('$anios ${anios == 1 ? 'año' : 'años'}',
                          texto.bodyMedium),
                      _celda(
                        formatearPesos(valorFuturo(inversion, anios * 12)),
                        texto.bodyMedium,
                        derecha: true,
                      ),
                      _celda(
                        formatearPesos(
                          aValorPresente(
                            valorFuturo(inversion, anios * 12),
                            inflacionPorDefecto,
                            anios * 12,
                          ),
                        ),
                        texto.bodyMedium,
                        derecha: true,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _celda(String t, TextStyle? estilo, {bool derecha = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Text(t,
            style: estilo,
            textAlign: derecha ? TextAlign.right : TextAlign.left),
      );
}
