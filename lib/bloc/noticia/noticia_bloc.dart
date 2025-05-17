import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/bloc/noticia/noticia_state.dart';



class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository _noticiaRepository = di<NoticiaRepository>();

  NoticiaBloc() : super(NoticiaInitial()) {
    on<FetchNoticiasEvent>(_onFetchNoticias);
    on<AddNoticiaEvent>(_onAddNoticia);
    on<UpdateNoticiaEvent>(_onUpdateNoticia);
    on<DeleteNoticiaEvent>(_onDeleteNoticia);
    on<FilterNoticiasByPreferenciasEvent>(_onFilterNoticiasByPreferencias);
  }

  Future<void> _onFetchNoticias(FetchNoticiasEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());

    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaLoaded(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al cargar las noticias', e, TipoOperacionNoticia.cargar));
      }
    }
  }

  Future<void> _onAddNoticia(AddNoticiaEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());

    try {
      await _noticiaRepository.crearNoticia(event.noticia);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaCreated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al crear la noticia', e, TipoOperacionNoticia.crear));
      }
    }
  }

  Future<void> _onUpdateNoticia(UpdateNoticiaEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());

    try {
      await _noticiaRepository.editarNoticia(event.noticia);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaUpdated(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al actualizar la noticia', e, TipoOperacionNoticia.actualizar));
      }
    }
  }

  Future<void> _onDeleteNoticia(DeleteNoticiaEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());

    try {
      await _noticiaRepository.eliminarNoticia(event.id);
      
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaDeleted(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al eliminar la noticia',e, TipoOperacionNoticia.eliminar));
      }
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferenciasEvent event, 
    Emitter<NoticiaState> emit
  ) async {
    emit(NoticiaLoading());

    try {
      List<Noticia> noticias;
      
      // Si no hay categorías seleccionadas, mostrar todas las noticias
      if (event.categoriasIds.isEmpty) {
        noticias = await _noticiaRepository.obtenerNoticias();
      } else {
        // Si hay categorías seleccionadas, filtrar por ellas
        noticias = await _noticiaRepository.obtenerNoticias();
        noticias = noticias.where(
          (noticia) => event.categoriasIds.contains(noticia.categoriaId)
        ).toList();
      }
      
      // Emitir un estado específico de filtrado con las categorías aplicadas
      emit(NoticiaFiltered(noticias, DateTime.now(), event.categoriasIds));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(
          'Error al filtrar noticias', 
          e, 
          TipoOperacionNoticia.filtrar
        ));
      } else {
        emit(NoticiaError(
          'Error desconocido al filtrar noticias', 
          ApiException(e.toString()), 
          TipoOperacionNoticia.filtrar
        ));
      }
    }
  }
}
