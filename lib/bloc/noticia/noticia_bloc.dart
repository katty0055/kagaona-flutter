import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';

part 'noticia_event.dart';
part 'noticia_state.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();

  NoticiaBloc() : super(NoticiaInitial()) {
    on<FetchNoticias>(_onFetchNoticias);
    on<AddNoticia>(_onAddNoticia);
    on<UpdateNoticia>(_onUpdateNoticia);
    on<DeleteNoticia>(_onDeleteNoticia);
    on<FilterNoticiasByPreferencias>(_onFilterNoticiasByPreferencias);
  }

  Future<void> _onFetchNoticias(FetchNoticias event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      final noticias = await noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError(
          'Error al cargar las noticias', 
          statusCode: e.statusCode
        ));
      } else {
        emit(NoticiasError('Error al cargar las noticias: ${e.toString()}'));
      }
    }
  }

  Future<void> _onAddNoticia(AddNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await noticiaRepository.crearNoticia(event.noticia);
      
      final noticias = await noticiaRepository.obtenerNoticias();
      emit(NoticiaCreated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError(
          'Error al crear la noticia', 
          statusCode: e.statusCode
        ));
      } else {
        emit(NoticiasError('Error al crear la noticia: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateNoticia(UpdateNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await noticiaRepository.editarNoticia(event.id, event.noticia);
      
      final noticias = await noticiaRepository.obtenerNoticias();
      emit(NoticiaUpdated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError(
          'Error al actualizar la noticia', 
          statusCode: e.statusCode
        ));
      } else {
        emit(NoticiasError('Error al actualizar la noticia: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDeleteNoticia(DeleteNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await noticiaRepository.eliminarNoticia(event.id);
      
      final noticias = await noticiaRepository.obtenerNoticias();
      emit(NoticiaDeleted(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError(
          'Error al eliminar la noticia', 
          statusCode: e.statusCode
        ));
      } else {
        emit(NoticiasError('Error al eliminar la noticia: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferencias event, 
    Emitter<NoticiaState> emit
  ) async {
    emit(NoticiasLoading());

    try {
      final allNoticias = await noticiaRepository.obtenerNoticias();

      final filteredNoticias =
          allNoticias
              .where(
                (noticia) => event.categoriasIds.contains(noticia.categoriaId),
              )
              .toList();

      emit(NoticiaFiltered(filteredNoticias, DateTime.now(), event.categoriasIds));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError(
          'Error al filtrar noticias', 
          statusCode: e.statusCode
        ));
      } else {
        emit(NoticiasError('Error al filtrar noticias: ${e.toString()}'));
      }
    }
  }
}
