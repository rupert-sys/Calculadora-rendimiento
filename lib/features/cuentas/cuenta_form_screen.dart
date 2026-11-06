import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../data/proveedores.dart';
import '../comun/campo_institucion.dart';
import '../comun/campos.dart';
import '../comun/movimientos_ligados.dart';

/// Crea o edita una cuenta de débito o de ahorro.
class CuentaFormScreen extends ConsumerStatefulWidget {
  const CuentaFormScreen({super.key, this.cuenta});

  final Cuenta? cuenta;

  @override
  ConsumerState<CuentaFormScreen> createState() => _CuentaFormScreenState();
}

class _CuentaFormScreenState extends ConsumerState<CuentaFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _institucion;
  late final TextEditingController _nombre;
  late final TextEditingController _saldo;
  late final TextEditingController _tasa;
  late TipoCuenta _tipo;

  @override
  void initState() {
    super.initState();
    final c = widget.cuenta;
    _institucion = TextEditingController(text: c?.institucion ?? '');
    _nombre = TextEditingController(text: c?.nombre ?? '');
    _saldo = TextEditingController(
      text: c == null ? '' : aUnidades(c.saldo).toStringAsFixed(2),
    );
    _tasa = TextEditingController(
      text: ((c?.tasaAnual ?? 0) * 100).toStringAsFixed(2),
    );
    _tipo = c?.tipo ?? TipoCuenta.debito;
  }

  @override
  void dispose() {
    for (final c in [_institucion, _nombre, _saldo, _tasa]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    final cuenta = Cuenta(
      id: widget.cuenta?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      institucion: _institucion.text.trim(),
      nombre: _nombre.text.trim(),
      tipo: _tipo,
      saldo: aCentavos(leerMonto(_saldo.text)!),
      tasaAnual: _tipo == TipoCuenta.ahorro ? leerMonto(_tasa.text)! / 100 : 0,
    );
    await ref.read(cuentasRepositorioProvider).guardar(cuenta);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _borrar() async {
    final c = widget.cuenta!;
    final ok = await confirmar(
      context,
      '¿Borrar cuenta?',
      'Se borrará "${c.nombre}". Sus movimientos se quedan, sin cuenta ligada.',
    );
    if (!ok) return;
    await ref.read(cuentasRepositorioProvider).borrar(c.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.cuenta != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar cuenta' : 'Nueva cuenta'),
        actions: [
          if (editando)
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
            SegmentedButton<TipoCuenta>(
              segments: const [
                ButtonSegment(
                    value: TipoCuenta.debito, label: Text('Débito o nómina')),
                ButtonSegment(value: TipoCuenta.ahorro, label: Text('Ahorro')),
              ],
              selected: {_tipo},
              onSelectionChanged: (s) => setState(() => _tipo = s.first),
            ),
            const SizedBox(height: 16),
            CampoInstitucion(controller: _institucion, obligatorio: true),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre de la cuenta',
                hintText: 'Nómina, Ahorro vacaciones…',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
            ),
            const SizedBox(height: 16),
            CampoNumero(
              controller: _saldo,
              etiqueta: 'Saldo actual (MXN)',
              prefijo: r'$ ',
            ),
            if (_tipo == TipoCuenta.ahorro) ...[
              const SizedBox(height: 16),
              CampoNumero(
                controller: _tasa,
                etiqueta: 'Rendimiento anual',
                sufijo: '%',
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Guardar')),
            if (editando) ...[
              const SizedBox(height: 24),
              MovimientosLigados(productoId: widget.cuenta!.id),
            ],
          ],
        ),
      ),
    );
  }
}
