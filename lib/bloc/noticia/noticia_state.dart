part of 'noticia_bloc.dart';

sealed class NoticiaState extends Equatable {
  const NoticiaState();
  
  @override
  List<Object> get props => [];
}

final class NoticiaInitial extends NoticiaState {}
