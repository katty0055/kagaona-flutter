import 'package:equatable/equatable.dart';

abstract class CategoriaEvent extends Equatable {
  const CategoriaEvent();

  @override
  List<Object?> get props => [];
}

class CargarCategoriasEvent extends CategoriaEvent {
  final bool mostrarMensaje;

  const CargarCategoriasEvent({this.mostrarMensaje = false});

  @override
  List<Object?> get props => [mostrarMensaje];
}
