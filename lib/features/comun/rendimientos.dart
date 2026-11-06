import 'package:flutter/material.dart';

import '../../core/finanzas/dinero.dart';
import '../../core/finanzas/inversion.dart';
import '../../core/finanzas/modelos.dart';
import 'campos.dart';

String textoCapitalizacion(Capitalizacion c) => switch (c) {
      Capitalizacion.diaria => 'Diario',
      Capitalizacion.semanal => 'Semanal',
      Capitalizacion.mensual => 'Mensual',
      Capitalizacion.anual => 'Anual',
    };

/// Cada cuándo se paga y se reinvierte el rendimiento.
class CampoCapitalizacion extends StatelessWidget {
  const CampoCapitalizacion({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  final Capitalizacion valor;
  final ValueChanged<Capitalizacion> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Capitalizacion>(
      initialValue: valor,
      decoration: const InputDecoration(
        labelText: 'El rendimiento se paga',
        helperText: 'Cada cuándo se abona y se reinvierte',
      ),
      items: [
        for (final c in Capitalizacion.values)
          DropdownMenuItem(value: c, child: Text(textoCapitalizacion(c))),
      ],
      onChanged: (v) => onChanged(v!),
    );
  }
}

/// Ganancia por día, semana, mes y año en una fila de cifras.
class FilaRendimientos extends StatelessWidget {
  const FilaRendimientos({super.key, required this.rendimientos});

  final Rendimientos rendimientos;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final r = rendimientos;
    Widget cifra(String titulo, Centavos valor) => Expanded(
          child: Column(
            children: [
              Text(titulo, style: texto.labelMedium),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(formatearPesos(valor), style: texto.titleSmall),
              ),
            ],
          ),
        );
    return Row(
      children: [
        cifra('Día', r.dia),
        cifra('Semana', r.semana),
        cifra('Mes', r.mes),
        cifra('Año', r.anio),
      ],
    );
  }
}

/// Tarjeta con lo que gana hoy un saldo y su tasa efectiva.
class TarjetaRendimientos extends StatelessWidget {
  const TarjetaRendimientos({
    super.key,
    required this.saldo,
    required this.tasaAnual,
    required this.capitalizacion,
  });

  final Centavos saldo;
  final double tasaAnual;
  final Capitalizacion capitalizacion;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final efectiva = tasaEfectivaAnual(tasaAnual, capitalizacion);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Rendimiento', style: texto.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Con pago ${textoCapitalizacion(capitalizacion).toLowerCase()}, '
              'tu tasa efectiva es ${textoTasa(efectiva)} anual.',
              style: texto.bodySmall,
            ),
            const SizedBox(height: 12),
            FilaRendimientos(
              rendimientos: rendimientosDe(saldo, tasaAnual, capitalizacion),
            ),
          ],
        ),
      ),
    );
  }
}
