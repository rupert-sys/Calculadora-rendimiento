import 'modelos.dart';

/// Categorías con las que arranca la app; el usuario puede agregar más.
const categoriasPredeterminadas = <Categoria>[
  Categoria(id: 'vivienda', nombre: 'Vivienda', tipo: TipoMovimiento.egreso),
  Categoria(id: 'comida', nombre: 'Comida', tipo: TipoMovimiento.egreso),
  Categoria(
      id: 'transporte', nombre: 'Transporte', tipo: TipoMovimiento.egreso),
  Categoria(id: 'servicios', nombre: 'Servicios', tipo: TipoMovimiento.egreso),
  Categoria(id: 'salud', nombre: 'Salud', tipo: TipoMovimiento.egreso),
  Categoria(id: 'educacion', nombre: 'Educación', tipo: TipoMovimiento.egreso),
  Categoria(
      id: 'entretenimiento',
      nombre: 'Entretenimiento',
      tipo: TipoMovimiento.egreso),
  Categoria(id: 'deudas', nombre: 'Deudas', tipo: TipoMovimiento.egreso),
  Categoria(id: 'otros_egresos', nombre: 'Otros', tipo: TipoMovimiento.egreso),
  Categoria(id: 'sueldo', nombre: 'Sueldo', tipo: TipoMovimiento.ingreso),
  Categoria(id: 'extras', nombre: 'Extras', tipo: TipoMovimiento.ingreso),
  Categoria(
      id: 'inversiones', nombre: 'Inversiones', tipo: TipoMovimiento.ingreso),
  Categoria(
      id: 'otros_ingresos', nombre: 'Otros', tipo: TipoMovimiento.ingreso),
];
