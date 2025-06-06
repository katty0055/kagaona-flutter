import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

abstract class NoticiaState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoticiaInitial extends NoticiaState {}

class NoticiaLoading extends NoticiaState {}

class NoticiaLoaded extends NoticiaState {
  final List<Noticia> noticias;
  final DateTime lastUpdated;
  final List<String>? categoriasFiltradas;

  NoticiaLoaded(
    this.noticias, 
    this.lastUpdated, {
    this.categoriasFiltradas,
  });

  @override
  List<Object> get props => [
    noticias, 
    lastUpdated, 
    if (categoriasFiltradas != null) categoriasFiltradas!,
  ];
  
  bool get estaFiltrado => categoriasFiltradas != null && categoriasFiltradas!.isNotEmpty;
}

enum TipoOperacionNoticia { cargar, crear, actualizar, eliminar, filtrar }

class NoticiaError extends NoticiaState {
  final ApiException error;
  final TipoOperacionNoticia tipoOperacion;

  NoticiaError(this.error, this.tipoOperacion);

  @override
  List<Object> get props => [error, tipoOperacion];
}

class NoticiaCreated extends NoticiaLoaded {
  NoticiaCreated(super.noticias, super.lastUpdated, {super.categoriasFiltradas});
}

class NoticiaUpdated extends NoticiaLoaded {
  NoticiaUpdated(super.noticias, super.lastUpdated, {super.categoriasFiltradas});
}

class NoticiaDeleted extends NoticiaLoaded {
  NoticiaDeleted(super.noticias, super.lastUpdated, {super.categoriasFiltradas});
}

class NoticiaFiltered extends NoticiaLoaded {
  NoticiaFiltered(
    super.noticias, 
    super.lastUpdated, {
    required List<String> categoriasFiltradas,
  }) : super(categoriasFiltradas: categoriasFiltradas);

}
