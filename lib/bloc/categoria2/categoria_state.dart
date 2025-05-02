import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/categoria.dart';

enum CategoriaStatus { initial, loading, loaded, error }

class CategoriaState extends Equatable {
   const CategoriaState() : super();

  @override
  List<Object?> get props => [];
}

class CategoriaInitState extends CategoriaState {
  
}

class CategoriaLoadingState extends CategoriaState {
 
}

class CategoriaLoadedState extends CategoriaState {
 final List<Categoria> categorias;
  final CategoriaStatus status;
  final String? errorMessage;

  CategoriaLoadedState({
    this.categorias = const [],
    this.status = CategoriaStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [categorias, status, errorMessage];
}

class CategoriaErrorState extends CategoriaState {
  final String errorMessage;

  const CategoriaErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
} 