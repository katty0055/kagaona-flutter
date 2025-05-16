import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent {}

class CategoriaCreateEvent extends CategoriaEvent {
  final Categoria categoria;
  
  CategoriaCreateEvent(this.categoria);
  
  @override
  List<Object?> get props => [categoria];
}

class CategoriaUpdateEvent extends CategoriaEvent {
  final Categoria categoria;
  
  CategoriaUpdateEvent(this.categoria);
  
  @override
  List<Object?> get props => [categoria];
}

class CategoriaDeleteEvent extends CategoriaEvent {
  final String id;
  
  CategoriaDeleteEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}