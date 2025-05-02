import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'noticia_event.dart';
part 'noticia_state.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  NoticiaBloc() : super(NoticiaInitial()) {
    on<NoticiaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
