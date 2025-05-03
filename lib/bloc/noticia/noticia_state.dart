import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

sealed class NoticiaState extends Equatable {
  const NoticiaState();
  
  @override
  List<Object> get props => [];
}

class NoticiaInitial extends NoticiaState {}

class NoticiasLoading extends NoticiaState {}

class NoticiasLoaded extends NoticiaState {
  final List<Noticia> noticiasList;
  final DateTime lastUpdated;

  const NoticiasLoaded(this.noticiasList, this.lastUpdated);

  @override
  List<Object> get props => [noticiasList, lastUpdated];
}

enum TipoOperacion {
  cargar,
  crear,
  actualizar,
  eliminar,
  filtrar
}

class NoticiasError extends NoticiaState {
  final String errorMessage;
  final ApiException error;
  final TipoOperacion tipoOperacion;

  const NoticiasError(this.errorMessage, this.error, this.tipoOperacion);

  @override
  List<Object> get props => [errorMessage, error, tipoOperacion];
}

class NoticiaCreated extends NoticiasLoaded {
  const NoticiaCreated(super.noticiasList, super.lastUpdated);
}

class NoticiaUpdated extends NoticiasLoaded {
  const NoticiaUpdated(super.noticiasList, super.lastUpdated);
}

class NoticiaDeleted extends NoticiasLoaded {
  const NoticiaDeleted(super.noticiasList, super.lastUpdated);
}

class NoticiaFiltered extends NoticiasLoaded {
  final List<String> appliedFilters;
  
  const NoticiaFiltered(
    super.noticiasList, 
    super.lastUpdated,
    this.appliedFilters
  );
  
  @override
  List<Object> get props => [...super.props, appliedFilters];
}
