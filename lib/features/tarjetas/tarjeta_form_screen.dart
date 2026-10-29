import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../core/finanzas/tarjeta.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';

/// Crea o edita una tarjeta y compara cuánto cuesta pagarla de distintas formas.
class TarjetaFormScreen extends ConsumerStatefulWidget {
  const TarjetaFormScreen({super.key, this.tarjeta});

  final TarjetaCredito? tarjeta;

  @override
  ConsumerState<TarjetaFormScreen> createState() => _TarjetaFormScreenState();
}

class _TarjetaFormScreenState extends ConsumerState<TarjetaFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _saldo;
  late final TextEditingController _tasa;
  late final TextEditingController _minimoPct;
  late final TextEditingController _minimoFijo;
  final _pagoFijo = TextEditingController();

  @override
  void initState() {
    super.initState();
    final t = widget.tarjeta;
    _nombre = TextEditingController(text: t?.nombre ?? '');
    _saldo = TextEditingController(
      text: t == null ? '' : aUnidades(t.saldo).toStringAsFixed(2),
    );
    _tasa = TextEditingController(
      text: t == null ? '' : (t.tasaAnual * 100).toStringAsFixed(2),
    );
    _minimoPct = TextEditingController(
      text: ((t?.pagoMinimoPorcentaje ?? 0.05) * 100).toStringAsFixed(2),
    );
    _minimoFijo = TextEditingController(
      text: aUnidades(t?.pagoMinimoFijo ?? 0).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    for (final c in [
      _nombre,
      _saldo,
      _tasa,
      _minimoPct,
      _minimoFijo,
      _pagoFijo
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  TarjetaCredito? _leer() {
    final saldo = leerMonto(_saldo.text);
    final tasa = leerMonto(_tasa.text);
    final pct = leerMonto(_minimoPct.text);
    final fijo = leerMonto(_minimoFijo.text);
    if (saldo == null || tasa == null || pct == null || fijo == null) {
      return null;
    }
    return TarjetaCredito(
      id: widget.tarjeta?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: _nombre.text.trim(),
      saldo: aCentavos(saldo),
      tasaAnual: tasa / 100,
      pagoMinimoPorcentaje: pct / 100,
      pagoMinimoFijo: aCentavos(fijo),
    );
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    await ref.read(tarjetasRepositorioProvider).guardar(_leer()!);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _borrar() async {
    final t = widget.tarjeta!;
    final ok = await confirmar(
      context,
      '¿Borrar tarjeta?',
      'Se borrará "${t.nombre}".',
    );
    if (!ok) return;
    await ref.read(tarjetasRepositorioProvider).borrar(t.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final actual = _leer();
    final pagoFijo = leerMonto(_pagoFijo.text);
    void refrescar(String _) => setState(() {});

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.tarjeta == null ? 'Nueva tarjeta' : 'Editar tarjeta'),
        actions: [
          if (widget.tarjeta != null)
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
              decoration:
                  const InputDecoration(labelText: 'Nombre de la tarjeta'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _saldo,
              etiqueta: 'Saldo a pagar (MXN)',
              prefijo: r'$ ',
              onChanged: refrescar,
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _tasa,
              etiqueta: 'Tasa de interés anual',
              sufijo: '%',
              onChanged: refrescar,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CampoNumero(
                    controller: _minimoPct,
                    etiqueta: 'Pago mínimo',
                    sufijo: '% del saldo',
                    onChanged: refrescar,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CampoNumero(
                    controller: _minimoFijo,
                    etiqueta: 'o al menos',
                    prefijo: r'$ ',
                    onChanged: refrescar,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (actual != null && actual.saldo > 0) ...[
              Text('¿Cuánto cuesta pagarla?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _pagoFijo,
                decoration: const InputDecoration(
                  labelText: 'Compara con un pago mensual fijo (MXN)',
                  prefixText: r'$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: refrescar,
              ),
              const SizedBox(height: 8),
              _Comparador(
                tarjeta: actual,
                pagoFijo: pagoFijo == null || pagoFijo <= 0
                    ? null
                    : aCentavos(pagoFijo),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}

class _Comparador extends StatelessWidget {
  const _Comparador({required this.tarjeta, this.pagoFijo});

  final TarjetaCredito tarjeta;
  final Centavos? pagoFijo;

  @override
  Widget build(BuildContext context) {
    final minimo = simularTarjeta(tarjeta);
    final fijo = pagoFijo == null
        ? null
        : simularTarjeta(tarjeta, pagoMensual: pagoFijo);

    return Card(
      child: Column(
        children: [
          _Opcion(
            titulo: 'Pagar solo el mínimo',
            detalle:
                'Primer pago de ${formatearPesos(pagoMinimo(tarjeta, tarjeta.saldo))}',
            resultado: minimo,
          ),
          if (fijo != null) ...[
            const Divider(height: 1),
            _Opcion(
              titulo: 'Pagar ${formatearPesos(pagoFijo!)} al mes',
              resultado: fijo,
            ),
          ],
          const Divider(height: 1),
          ListTile(
            title: const Text('Pagar todo hoy'),
            subtitle: const Text('Sin intereses'),
            trailing: Text(formatearPesos(tarjeta.saldo)),
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({required this.titulo, required this.resultado, this.detalle});

  final String titulo;
  final String? detalle;
  final ResultadoTarjeta resultado;

  @override
  Widget build(BuildContext context) {
    final r = resultado;
    final colorError = Theme.of(context).colorScheme.error;
    final lineas = [
      if (detalle != null) detalle!,
      if (r.seSalda)
        'Terminas en ${textoMeses(r.meses!)} · intereses ${formatearPesos(r.interesesTotales)}'
      else
        'Con este pago la deuda no baja: no cubre los intereses del mes.',
    ];

    return ListTile(
      title: Text(titulo),
      subtitle: Text(
        lineas.join('\n'),
        style: r.seSalda ? null : TextStyle(color: colorError),
      ),
      isThreeLine: lineas.length > 1,
      trailing: r.seSalda ? Text(formatearPesos(r.pagadoTotal)) : null,
    );
  }
}
