import 'package:flutter/material.dart';

import '../features/inversiones/inversiones_screen.dart';
import '../features/movimientos/movimientos_screen.dart';
import '../features/resumen/resumen_screen.dart';
import '../features/simulador/simulador_screen.dart';
import '../features/tarjetas/tarjetas_screen.dart';

/// Navegación principal: barra inferior en teléfono, menú lateral en
/// tablet y computadora.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  /// Ancho a partir del cual se usa el menú lateral.
  static const anchoMenuLateral = 600.0;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _indice = 0;

  static const _pantallas = <Widget>[
    ResumenScreen(),
    MovimientosScreen(),
    InversionesScreen(),
    TarjetasScreen(),
    SimuladorScreen(),
  ];

  static const _destinos = [
    (
      icono: Icons.pie_chart_outline,
      seleccionado: Icons.pie_chart,
      texto: 'Resumen'
    ),
    (
      icono: Icons.swap_vert,
      seleccionado: Icons.swap_vert,
      texto: 'Movimientos'
    ),
    (
      icono: Icons.savings_outlined,
      seleccionado: Icons.savings,
      texto: 'Inversiones'
    ),
    (
      icono: Icons.credit_card_outlined,
      seleccionado: Icons.credit_card,
      texto: 'Tarjetas'
    ),
    (
      icono: Icons.show_chart,
      seleccionado: Icons.show_chart,
      texto: 'Simulador'
    ),
  ];

  void _ir(int i) => setState(() => _indice = i);

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final pantalla = IndexedStack(index: _indice, children: _pantallas);

    if (ancho >= AppShell.anchoMenuLateral) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _indice,
              onDestinationSelected: _ir,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinos)
                  NavigationRailDestination(
                    icon: Icon(d.icono),
                    selectedIcon: Icon(d.seleccionado),
                    label: Text(d.texto),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: pantalla),
          ],
        ),
      );
    }

    return Scaffold(
      body: pantalla,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _ir,
        destinations: [
          for (final d in _destinos)
            NavigationDestination(
              icon: Icon(d.icono),
              selectedIcon: Icon(d.seleccionado),
              label: d.texto,
            ),
        ],
      ),
    );
  }
}
