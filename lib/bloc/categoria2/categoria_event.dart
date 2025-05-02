import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  const CategoriaEvent();

  @override
  List<Object?> get props => [];
}

class CargarCategoriasEvent extends CategoriaEvent {
  final bool mostrarMensaje;

  const CargarCategoriasEvent({
    this.mostrarMensaje = true,
  });

  @override
  List<Object?> get props => [mostrarMensaje];
}

class AgregarCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;

  const AgregarCategoriaEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class EditarCategoriaEvent extends CategoriaEvent {
  final String id;
  final Categoria categoria;

  const EditarCategoriaEvent(this.id, this.categoria);

  @override
  List<Object?> get props => [id, categoria];
}

class EliminarCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;

  const EliminarCategoriaEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}