import '../../core/finanzas/categorias.dart';
import '../../core/finanzas/modelos.dart';

String textoFrecuencia(Frecuencia f) => switch (f) {
      Frecuencia.unica => 'Única vez',
      Frecuencia.quincenal => 'Quincenal',
      Frecuencia.mensual => 'Mensual',
      Frecuencia.anual => 'Anual',
    };

String nombreCategoria(String id) {
  for (final c in categoriasPredeterminadas) {
    if (c.id == id) return c.nombre;
  }
  return id;
}

List<Categoria> categoriasDe(TipoMovimiento tipo) =>
    categoriasPredeterminadas.where((c) => c.tipo == tipo).toList();

String textoFecha(DateTime d) => '${d.day}/${d.month}/${d.year}';

const nombresMes = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', //
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];
