import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/flujo.dart';
import '../../core/finanzas/modelos.dart';
import '../movimientos/textos.dart';

/// Ingresos contra egresos de los 6 meses que terminan en [hasta].
class GraficaFlujo extends StatelessWidget {
  const GraficaFlujo(
      {super.key, required this.movimientos, required this.hasta});

  final List<Movimiento> movimientos;
  final DateTime hasta;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final estilo = Theme.of(context).textTheme.bodySmall;
    final colorIngreso = Colors.green.shade600;
    final colorEgreso = colores.error;
    final meses = [
      for (var i = 5; i >= 0; i--) DateTime(hasta.year, hasta.month - i)
    ];
    final resumenes = [
      for (final m in meses) flujoMensual(movimientos, m.year, m.month)
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: [
                for (var i = 0; i < meses.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: aUnidades(resumenes.elementAt(i).ingresos) / 1000,
                        color: colorIngreso,
                        width: 10,
                      ),
                      BarChartRodData(
                        toY: aUnidades(resumenes.elementAt(i).egresos) / 1000,
                        color: colorEgreso,
                        width: 10,
                      ),
                    ],
                  ),
              ],
              gridData: const FlGridData(drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (v, meta) =>
                        Text('\$${v.round()}k', style: estilo),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, meta) => Text(
                      nombresMes
                          .elementAt(meses.elementAt(v.toInt()).month - 1)
                          .substring(0, 3),
                      style: estilo,
                    ),
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (grupo, _, rod, __) => BarTooltipItem(
                    formatearPesos(aCentavos(rod.toY * 1000)),
                    TextStyle(color: rod.color, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _Leyenda(color: colorIngreso, texto: 'Ingresos'),
            _Leyenda(color: colorEgreso, texto: 'Egresos'),
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
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
