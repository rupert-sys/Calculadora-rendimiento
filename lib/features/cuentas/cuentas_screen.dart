import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/cuentas.dart';
import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import '../../core/finanzas/tarjeta.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import '../inversiones/inversion_form_screen.dart';
import '../rendimiento/home_screen.dart';
import '../tarjetas/tarjeta_form_screen.dart';
import 'cuenta_form_screen.dart';

/// Bancos e instituciones con todos sus productos: cuentas, inversiones y
/// tarjetas de crédito.
class CuentasScreen extends ConsumerWidget {
  const CuentasScreen({super.key});

  static Future<void> abrir(BuildContext context, Widget pantalla) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => pantalla));
  }

  Future<void> _agregar(BuildContext context) async {
    final pantalla = await showModalBottomSheet<Widget>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Cuenta de débito o ahorro'),
              onTap: () => Navigator.pop(context, const CuentaFormScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('Inversión'),
              subtitle: const Text('Pagaré, Cetes, fondo, cuenta de inversión'),
              onTap: () => Navigator.pop(context, const InversionFormScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Tarjeta de crédito'),
              onTap: () => Navigator.pop(context, const TarjetaFormScreen()),
            ),
          ],
        ),
      ),
    );
    if (pantalla != null && context.mounted) await abrir(context, pantalla);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grupos = ref.watch(gruposInstitucionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
        actions: [
          IconButton(
            tooltip: 'Calculadora rápida',
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () => abrir(context, const HomeScreen()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'agregar-cuentas',
        onPressed: () => _agregar(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: grupos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudieron cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Agrega tus cuentas, inversiones y tarjetas de cada banco '
                  'para ver cuánto tienes y cuánto debes.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final activos = lista.fold<int>(0, (s, g) => s + g.activos);
          final deudas = lista.fold<int>(0, (s, g) => s + g.deudas);
          final estilos = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              ListTile(
                title: const Text('Patrimonio hoy'),
                subtitle: Text(
                  'Tienes ${formatearPesos(activos)} · '
                  'debes ${formatearPesos(deudas)}',
                ),
                trailing: Text(
                  formatearPesos(activos - deudas),
                  style: estilos.titleMedium,
                ),
              ),
              for (final g in lista) _Grupo(grupo: g),
            ],
          );
        },
      ),
    );
  }
}

class _Grupo extends StatelessWidget {
  const _Grupo({required this.grupo});

  final GrupoInstitucion grupo;

  @override
  Widget build(BuildContext context) {
    final g = grupo;
    final colores = Theme.of(context).colorScheme;
    final estilos = Theme.of(context).textTheme;
    final deuda = colores.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Icon(Icons.account_balance, color: colores.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  g.institucion.isEmpty ? 'Sin institución' : g.institucion,
                  style: estilos.titleMedium,
                ),
              ),
              Text(formatearPesos(g.neto), style: estilos.titleSmall),
            ],
          ),
        ),
        for (final c in g.cuentas)
          ListTile(
            onTap: () =>
                CuentasScreen.abrir(context, CuentaFormScreen(cuenta: c)),
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: Text(c.nombre),
            subtitle: Text(
              c.tipo == TipoCuenta.debito
                  ? 'Débito o nómina'
                  : 'Ahorro · ${textoTasa(c.tasaAnual)} anual',
            ),
            trailing: Text(formatearPesos(c.saldo)),
          ),
        for (final i in g.inversiones)
          ListTile(
            onTap: () =>
                CuentasScreen.abrir(context, InversionFormScreen(inversion: i)),
            leading: const Icon(Icons.savings_outlined),
            title: Text(i.nombre),
            subtitle: Text(
              'Inversión · ${textoTasa(i.tasaAnual)} anual'
              '${i.aporteMensual > 0 ? ' · +${formatearPesos(i.aporteMensual)} al mes' : ''}'
              '\nEn 5 años: ${formatearPesos(valorFuturo(i, 60))}',
            ),
            isThreeLine: true,
            trailing: Text(formatearPesos(i.saldoInicial)),
          ),
        for (final t in g.tarjetas)
          ListTile(
            onTap: () =>
                CuentasScreen.abrir(context, TarjetaFormScreen(tarjeta: t)),
            leading: Icon(Icons.credit_card, color: deuda),
            title: Text(t.nombre),
            subtitle: Text(
              'Tarjeta · ${textoTasa(t.tasaAnual)} anual · '
              'mínimo ${formatearPesos(pagoMinimo(t, t.saldo))}',
            ),
            trailing: Text(
              '-${formatearPesos(t.saldo)}',
              style: TextStyle(color: deuda),
            ),
          ),
      ],
    );
  }
}
