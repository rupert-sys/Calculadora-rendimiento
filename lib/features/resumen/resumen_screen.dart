import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/cuentas.dart';
import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/flujo.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import '../../core/finanzas/tarjeta.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import '../comun/rendimientos.dart';
import '../movimientos/textos.dart';
import 'grafica_flujo.dart';

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
            data: (r) => _Contenido(
              resumen: r,
              movimientos:
                  ref.watch(movimientosProvider).valueOrNull ?? const [],
              mes: mes,
            ),
          ),
          const _Tarjetas(),
          const _Rendimientos(),
        ],
      ),
    );
  }
}

/// Próximos cortes y pagos de cada tarjeta, la más próxima a pagar primero.
class _Tarjetas extends ConsumerWidget {
  const _Tarjetas();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarjetas = ref.watch(tarjetasProvider).valueOrNull ?? const [];
    if (tarjetas.isEmpty) return const SizedBox();
    final hoy = DateTime.now();
    final texto = Theme.of(context).textTheme;

    DateTime? pago(TarjetaCredito t) =>
        t.diaPago == null ? null : proximoDiaDelMes(t.diaPago!, hoy);
    final orden = [...tarjetas]..sort((a, b) {
        final pa = pago(a), pb = pago(b);
        if (pa == null || pb == null) return pa == null ? 1 : -1;
        return pa.compareTo(pb);
      });

    String fecha(int? dia) {
      if (dia == null) return 'sin indicar';
      final f = proximoDiaDelMes(dia, hoy);
      final faltan = DateTime.utc(f.year, f.month, f.day)
          .difference(DateTime.utc(hoy.year, hoy.month, hoy.day))
          .inDays;
      final cuando = switch (faltan) {
        0 => 'hoy',
        1 => 'mañana',
        _ => 'en $faltan días',
      };
      return '${f.day} de ${nombresMes.elementAt(f.month - 1)} ($cuando)';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text('Tarjetas de crédito', style: texto.titleMedium),
        for (final t in orden)
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.institucion.isEmpty
                        ? t.nombre
                        : '${t.institucion} · ${t.nombre}',
                    style: texto.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _Dato('Saldo total', formatearPesos(t.saldo)),
                  _Dato('Para no generar intereses',
                      formatearPesos(pagoParaNoGenerarIntereses(t))),
                  _Dato('Pago mínimo', formatearPesos(pagoMinimo(t, t.saldo))),
                  _Dato('Corte', fecha(t.diaCorte)),
                  _Dato('Pago', fecha(t.diaPago)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Lo que ganan hoy las inversiones y cuentas de ahorro.
class _Rendimientos extends ConsumerWidget {
  const _Rendimientos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inversiones = [
      ...?ref.watch(inversionesProvider).valueOrNull,
      ...ahorrosComoInversiones(ref.watch(cuentasProvider).valueOrNull ?? []),
    ].where((i) => i.saldoInicial > 0 && i.tasaAnual > 0).toList();
    if (inversiones.isEmpty) return const SizedBox();
    final texto = Theme.of(context).textTheme;

    Rendimientos de(Inversion i) =>
        rendimientosDe(i.saldoInicial, i.tasaAnual, i.capitalizacion);
    final total = inversiones.fold(const Rendimientos(), (s, i) => s + de(i));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text('Rendimientos', style: texto.titleMedium),
        Card(
          margin: const EdgeInsets.only(top: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilaRendimientos(rendimientos: total),
          ),
        ),
        for (final i in inversiones)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(i.nombre),
            subtitle: Text(
              '${textoTasa(i.tasaAnual)} anual · pago '
              '${textoCapitalizacion(i.capitalizacion).toLowerCase()}',
            ),
            trailing: Text('${formatearPesos(de(i).mes)} al mes'),
          ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato(this.titulo, this.valor);

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(titulo)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.resumen,
    required this.movimientos,
    required this.mes,
  });

  final ResumenMensual resumen;
  final List<Movimiento> movimientos;
  final DateTime mes;

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
        if (movimientos.isNotEmpty) ...[
          Text('Últimos 6 meses',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          GraficaFlujo(movimientos: movimientos, hasta: mes),
          const SizedBox(height: 24),
        ],
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
