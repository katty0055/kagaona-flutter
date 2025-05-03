import 'package:bloc/bloc.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/bloc/noticia/noticia_state.dart';



class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository _noticiaRepository = di<NoticiaRepository>();

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
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError('Error al cargar las noticias', e, TipoOperacion.cargar));
      }
    }
  }

  Future<void> _onAddNoticia(AddNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await _noticiaRepository.crearNoticia(event.noticia);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaCreated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError('Error al crear la noticia', e, TipoOperacion.crear));
      }
    }
  }

  Future<void> _onUpdateNoticia(UpdateNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await _noticiaRepository.editarNoticia(event.id, event.noticia);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaUpdated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError('Error al actualizar la noticia', e, TipoOperacion.actualizar));
      }
    }
  }

  Future<void> _onDeleteNoticia(DeleteNoticia event, Emitter<NoticiaState> emit) async {
    emit(NoticiasLoading());

    try {
      await _noticiaRepository.eliminarNoticia(event.id);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaDeleted(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError('Error al eliminar la noticia',e, TipoOperacion.eliminar));
      }
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferencias event, 
    Emitter<NoticiaState> emit
  ) async {
    emit(NoticiasLoading());

    try {
      final allNoticias = await _noticiaRepository.obtenerNoticias();

      final filteredNoticias =
          allNoticias
              .where(
                (noticia) => event.categoriasIds.contains(noticia.categoriaId),
              )
              .toList();

      emit(NoticiaFiltered(filteredNoticias, DateTime.now(), event.categoriasIds));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiasError('Error al filtrar noticias', e, TipoOperacion.filtrar));
      }
    }
  }
}
