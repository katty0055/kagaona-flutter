import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/noticia.dart';

sealed class NoticiaEvent extends Equatable {
  const NoticiaEvent();

  @override
  List<Object> get props => [];
}

class FetchNoticias extends NoticiaEvent {
  const FetchNoticias();
}

class AddNoticia extends NoticiaEvent {
  final Noticia noticia;

  const AddNoticia(this.noticia);

  @override
  List<Object> get props => [noticia];
}

class UpdateNoticia extends NoticiaEvent {
  final String id;
  final Noticia noticia;

  const UpdateNoticia(this.id, this.noticia);

  @override
  List<Object> get props => [id, noticia];
}

class DeleteNoticia extends NoticiaEvent {
  final String id;

  const DeleteNoticia(this.id);

  @override
  List<Object> get props => [id];
}

class FilterNoticiasByPreferencias extends NoticiaEvent {
  final List<String> categoriasIds;

  const FilterNoticiasByPreferencias(this.categoriasIds);

  @override
  List<Object> get props => [categoriasIds];
}