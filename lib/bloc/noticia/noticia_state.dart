part of 'noticia_bloc.dart';

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

class NoticiasError extends NoticiaState {
  final String errorMessage;
  final int? statusCode;

  const NoticiasError(this.errorMessage, {this.statusCode});

  @override
  List<Object> get props => [errorMessage, statusCode ?? 0];
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
