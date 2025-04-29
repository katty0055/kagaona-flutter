import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/categoria.dart';

// Clase base abstracta para todos los estados
abstract class CategoriaState extends Equatable {
  const CategoriaState();
  
  @override
  List<Object?> get props => [];
}

// Estado inicial
// class CategoriaInitialState extends CategoriaState {
//   const CategoriaInitialState();
// }

// Estado de carga
class CategoriaLoadingState extends CategoriaState {
  const CategoriaLoadingState();
}

// Estado cuando las categorías se han cargado con éxito
// class CategoriaLoadedState extends CategoriaState {
//   final List<Categoria> categorias;
//   final DateTime lastUpdated;
  
//   const CategoriaLoadedState({
//     required this.categorias,
//     required this.lastUpdated,
//   });
  
//   @override
//   List<Object?> get props => [categorias, lastUpdated];
// }

// Estado de error
// class CategoriaErrorState extends CategoriaState {
//   final String errorMessage;
  
//   const CategoriaErrorState({
//     required this.errorMessage,
//   });
  
//   @override
//   List<Object?> get props => [errorMessage];
// }
