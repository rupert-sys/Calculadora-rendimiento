import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import 'movimientos_screen.dart';
import 'textos.dart';

/// Crea un movimiento nuevo o edita [movimiento] si se pasa uno.
class MovimientoFormScreen extends ConsumerStatefulWidget {
  const MovimientoFormScreen({super.key, this.movimiento});

  final Movimiento? movimiento;

  @override
  ConsumerState<MovimientoFormScreen> createState() =>
      _MovimientoFormScreenState();
}

class _MovimientoFormScreenState extends ConsumerState<MovimientoFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _descripcion;
  late final TextEditingController _monto;
  late TipoMovimiento _tipo;
  late String _categoriaId;
  late Frecuencia _frecuencia;
  late DateTime _inicio;
  DateTime? _fin;

  bool get _editando => widget.movimiento != null;

  bool get _finAntesDeInicio =>
      _frecuencia != Frecuencia.unica &&
      _fin != null &&
      _fin!.isBefore(_inicio);

  @override
  void initState() {
    super.initState();
    final m = widget.movimiento;
    _descripcion = TextEditingController(text: m?.descripcion ?? '');
    _monto = TextEditingController(
      text: m == null ? '' : aUnidades(m.monto).toStringAsFixed(2),
    );
    _tipo = m?.tipo ?? TipoMovimiento.egreso;
    _categoriaId = m?.categoriaId ?? categoriasDe(_tipo).first.id;
    _frecuencia = m?.frecuencia ?? Frecuencia.mensual;
    final hoy = DateTime.now();
    _inicio = m?.fechaInicio ?? DateTime(hoy.year, hoy.month, hoy.day);
    _fin = m?.fechaFin;
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _monto.dispose();
    super.dispose();
  }

  void _cambiarTipo(TipoMovimiento tipo) {
    setState(() {
      _tipo = tipo;
      if (!categoriasDe(tipo).any((c) => c.id == _categoriaId)) {
        _categoriaId = categoriasDe(tipo).first.id;
      }
    });
  }

  Future<DateTime?> _elegirFecha(DateTime inicial) {
    return showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate() || _finAntesDeInicio) return;
    final m = Movimiento(
      id: widget.movimiento?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      tipo: _tipo,
      descripcion: _descripcion.text.trim(),
      monto: aCentavos(leerMonto(_monto.text)!),
      categoriaId: _categoriaId,
      frecuencia: _frecuencia,
      fechaInicio: _inicio,
      fechaFin: _frecuencia == Frecuencia.unica ? null : _fin,
    );
    await ref.read(movimientosRepositorioProvider).guardar(m);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _borrar() async {
    final m = widget.movimiento!;
    if (!await confirmarBorrado(context, m)) return;
    await ref.read(movimientosRepositorioProvider).borrar(m.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar movimiento' : 'Nuevo movimiento'),
        actions: [
          if (_editando)
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
            SegmentedButton<TipoMovimiento>(
              segments: const [
                ButtonSegment(
                    value: TipoMovimiento.ingreso, label: Text('Ingreso')),
                ButtonSegment(
                    value: TipoMovimiento.egreso, label: Text('Egreso')),
              ],
              selected: {_tipo},
              onSelectionChanged: (s) => _cambiarTipo(s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcion,
              decoration: const InputDecoration(labelText: 'Descripción'),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Escribe una descripción'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _monto,
              decoration: const InputDecoration(
                  labelText: 'Monto (MXN)', prefixText: r'$ '),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
              ],
              validator: (v) {
                final monto = leerMonto(v ?? '');
                if (monto == null || monto <= 0) {
                  return 'Escribe un monto mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(_tipo),
              initialValue: _categoriaId,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: [
                for (final c in categoriasDe(_tipo))
                  DropdownMenuItem(value: c.id, child: Text(c.nombre)),
              ],
              onChanged: (v) => setState(() => _categoriaId = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Frecuencia>(
              initialValue: _frecuencia,
              decoration: const InputDecoration(labelText: 'Frecuencia'),
              items: [
                for (final f in Frecuencia.values)
                  DropdownMenuItem(value: f, child: Text(textoFrecuencia(f))),
              ],
              onChanged: (v) => setState(() => _frecuencia = v!),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(_frecuencia == Frecuencia.unica ? 'Fecha' : 'Desde'),
              subtitle: Text(textoFecha(_inicio)),
              onTap: () async {
                final f = await _elegirFecha(_inicio);
                if (f != null) setState(() => _inicio = f);
              },
            ),
            if (_frecuencia != Frecuencia.unica)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_busy),
                title: const Text('Hasta'),
                subtitle:
                    Text(_fin == null ? 'Sin fecha de fin' : textoFecha(_fin!)),
                trailing: _fin == null
                    ? null
                    : IconButton(
                        tooltip: 'Quitar fecha de fin',
                        onPressed: () => setState(() => _fin = null),
                        icon: const Icon(Icons.close),
                      ),
                onTap: () async {
                  final f = await _elegirFecha(_fin ?? _inicio);
                  if (f != null) setState(() => _fin = f);
                },
              ),
            if (_finAntesDeInicio)
              Text(
                'La fecha de fin es anterior al inicio.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
