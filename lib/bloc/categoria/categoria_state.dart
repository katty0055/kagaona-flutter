import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/exceptions/api_exception.dart';

abstract class CategoriaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitial extends CategoriaState {
  @override
  List<Object> get props => [];
}

enum TipoOperacion {
  cargar,
  crear,
  actualizar,
  eliminar
}

class CategoriaError extends CategoriaState {
  final String message;
  final ApiException error;
  final TipoOperacion tipoOperacion;

  CategoriaError(this.message, this.error, this.tipoOperacion);

  @override
  List<Object?> get props => [message, error, tipoOperacion];
}

class CategoriaLoading extends CategoriaState {

}

class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime lastUpdated;

  CategoriaLoaded(this.categorias, this.lastUpdated);

  @override
  List<Object?> get props => [categorias, lastUpdated];
}

class CategoriaCreated extends CategoriaLoaded {
  CategoriaCreated(super.categorias, super.lastUpdated);
}

class CategoriaUpdated extends CategoriaLoaded {
  CategoriaUpdated(super.categorias, super.lastUpdated);
}

class CategoriaDeleted extends CategoriaLoaded {
  CategoriaDeleted(super.categorias, super.lastUpdated);
}