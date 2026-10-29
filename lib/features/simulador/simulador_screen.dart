import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/modelos.dart';
import '../../core/finanzas/simulador.dart';
import '../../data/proveedores.dart';
import '../comun/campos.dart';
import '../movimientos/textos.dart';

/// Proyecta el patrimonio en el tiempo y lo compara con un escenario
/// "qué pasa si".
class SimuladorScreen extends ConsumerStatefulWidget {
  const SimuladorScreen({super.key});

  @override
  ConsumerState<SimuladorScreen> createState() => _SimuladorScreenState();
}

class _SimuladorScreenState extends ConsumerState<SimuladorScreen> {
  int _anios = 10;
  double _inflacion = inflacionPorDefecto;
  double _ajusteIngresos = 0;
  double _ajusteEgresos = 0;
  final _pagoExtra = TextEditingController(text: '0');

  @override
  void dispose() {
    _pagoExtra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datos = ref.watch(datosSimulacionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Simulador')),
      body: datos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudo simular: $e')),
        data: (d) {
          if (d.movimientos.isEmpty &&
              d.inversiones.isEmpty &&
              d.tarjetas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Registra tus ingresos, gastos, inversiones o tarjetas para simular tu futuro.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final hoy = DateTime.now();
          final inicio = DateTime(hoy.year, hoy.month);
          final base = Escenario(
              nombre: 'Actual', anios: _anios, inflacionAnual: _inflacion);
          final que = base.copyWith(
            nombre: 'Qué pasa si',
            ajusteIngresos: _ajusteIngresos,
            ajusteEgresos: _ajusteEgresos,
            pagoExtraTarjetas: aCentavos(leerMonto(_pagoExtra.text) ?? 0),
          );
          ResultadoSimulacion correr(Escenario e) => simular(
                escenario: e,
                inicio: inicio,
                movimientos: d.movimientos,
                inversiones: d.inversiones,
                tarjetas: d.tarjetas,
              );
          final rBase = correr(base);
          final rQue = correr(que);
          final hayCambios = _ajusteIngresos != 0 ||
              _ajusteEgresos != 0 ||
              que.pagoExtraTarjetas > 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Controles(
                anios: _anios,
                inflacion: _inflacion,
                ajusteIngresos: _ajusteIngresos,
                ajusteEgresos: _ajusteEgresos,
                pagoExtra: _pagoExtra,
                hayTarjetas: d.tarjetas.isNotEmpty,
                onAnios: (v) => setState(() => _anios = v),
                onInflacion: (v) => setState(() => _inflacion = v),
                onIngresos: (v) => setState(() => _ajusteIngresos = v),
                onEgresos: (v) => setState(() => _ajusteEgresos = v),
                onPagoExtra: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              _Resumen(base: rBase, que: hayCambios ? rQue : null),
              const SizedBox(height: 16),
              Text('Patrimonio en el tiempo',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: GraficaPatrimonio(
                    base: rBase, que: hayCambios ? rQue : null),
              ),
              const SizedBox(height: 8),
              Text(
                'Patrimonio = efectivo acumulado + inversiones − deudas. '
                'Los montos de tus movimientos se mantienen fijos; '
                '"en pesos de hoy" descuenta la inflación.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Controles extends StatelessWidget {
  const _Controles({
    required this.anios,
    required this.inflacion,
    required this.ajusteIngresos,
    required this.ajusteEgresos,
    required this.pagoExtra,
    required this.hayTarjetas,
    required this.onAnios,
    required this.onInflacion,
    required this.onIngresos,
    required this.onEgresos,
    required this.onPagoExtra,
  });

  final int anios;
  final double inflacion;
  final double ajusteIngresos;
  final double ajusteEgresos;
  final TextEditingController pagoExtra;
  final bool hayTarjetas;
  final ValueChanged<int> onAnios;
  final ValueChanged<double> onInflacion;
  final ValueChanged<double> onIngresos;
  final ValueChanged<double> onEgresos;
  final VoidCallback onPagoExtra;

  String _signo(double v) => '${v > 0 ? '+' : ''}${(v * 100).round()} %';

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plazo: $anios ${anios == 1 ? 'año' : 'años'}',
                style: texto.labelLarge),
            Slider(
              value: anios.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$anios',
              onChanged: (v) => onAnios(v.round()),
            ),
            Text('Inflación anual: ${textoTasa(inflacion)}',
                style: texto.labelLarge),
            Slider(
              value: inflacion,
              min: 0,
              max: 0.15,
              divisions: 30,
              label: textoTasa(inflacion),
              onChanged: onInflacion,
            ),
            const Divider(),
            Text('Qué pasa si…', style: texto.titleSmall),
            const SizedBox(height: 8),
            Text('Mis ingresos cambian ${_signo(ajusteIngresos)}',
                style: texto.labelLarge),
            Slider(
              value: ajusteIngresos,
              min: -0.5,
              max: 0.5,
              divisions: 20,
              label: _signo(ajusteIngresos),
              onChanged: onIngresos,
            ),
            Text('Mis gastos cambian ${_signo(ajusteEgresos)}',
                style: texto.labelLarge),
            Slider(
              value: ajusteEgresos,
              min: -0.5,
              max: 0.5,
              divisions: 20,
              label: _signo(ajusteEgresos),
              onChanged: onEgresos,
            ),
            if (hayTarjetas)
              TextField(
                controller: pagoExtra,
                decoration: const InputDecoration(
                  labelText: 'Pago extra a tarjetas cada mes (MXN)',
                  prefixText: r'$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => onPagoExtra(),
              ),
          ],
        ),
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.base, this.que});

  final ResultadoSimulacion base;
  final ResultadoSimulacion? que;

  String _fechaSinDeuda(ResultadoSimulacion r) {
    if (r.deudaInicial == 0) return 'Sin deudas';
    final mes = r.mesSinDeuda;
    if (mes == null) return 'No se salda en el plazo';
    final f = r.puntos.elementAt(mes - 1).fecha;
    return 'Sin deudas en ${nombresMes.elementAt(f.month - 1)} ${f.year}';
  }

  Widget _columna(BuildContext context, String titulo, ResultadoSimulacion r) {
    final texto = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: texto.labelMedium),
          const SizedBox(height: 4),
          Text(formatearPesos(r.ultimo.patrimonio), style: texto.titleLarge),
          Text('${formatearPesos(r.ultimo.patrimonioReal)} en pesos de hoy',
              style: texto.bodySmall),
          const SizedBox(height: 4),
          Text(_fechaSinDeuda(r), style: texto.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anios = base.escenario.anios;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patrimonio en $anios ${anios == 1 ? 'año' : 'años'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _columna(context, 'Como vas', base),
                if (que != null) ...[
                  const SizedBox(width: 16),
                  _columna(context, 'Qué pasa si', que!),
                ],
              ],
            ),
            if (que != null) ...[
              const SizedBox(height: 12),
              Text(
                'Diferencia: ${formatearPesos(que!.ultimo.patrimonio - base.ultimo.patrimonio)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Línea del patrimonio mes a mes; con [que], una segunda línea para comparar.
class GraficaPatrimonio extends StatelessWidget {
  const GraficaPatrimonio({super.key, required this.base, this.que});

  final ResultadoSimulacion base;
  final ResultadoSimulacion? que;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final colorBase = que == null ? colores.primary : colores.outline;
    final inicio = base.puntos.first.fecha.year;

    LineChartBarData linea(ResultadoSimulacion r, Color color) =>
        LineChartBarData(
          spots: [
            for (final p in r.puntos)
              FlSpot(p.mes.toDouble(), aUnidades(p.patrimonio) / 1000),
          ],
          color: color,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
        );

    final anios = base.escenario.anios;
    final pasoAnios = anios <= 5 ? 1 : (anios <= 15 ? 5 : 10);

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                linea(base, colorBase),
                if (que != null) linea(que!, colores.primary),
              ],
              gridData: const FlGridData(drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 56,
                    getTitlesWidget: (v, meta) => Text(
                      '\$${v.round()}k',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 12.0 * pasoAnios,
                    getTitlesWidget: (v, meta) => Text(
                      '${inicio + v ~/ 12}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => [
                    for (final s in spots)
                      LineTooltipItem(
                        formatearPesos(aCentavos(s.y * 1000)),
                        TextStyle(
                            color: s.bar.color, fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _Leyenda(color: colorBase, texto: 'Como vas'),
            if (que != null)
              _Leyenda(color: colores.primary, texto: 'Qué pasa si'),
          ],
        ),
      ],
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda({required this.color, required this.texto});

  final Color color;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 3, color: color),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
