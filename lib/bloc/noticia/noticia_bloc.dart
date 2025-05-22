import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/constants/constantes.dart';
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
    on<ResetNoticiaEvent>(_onResetNoticias);
  }

  Future<void> _onFetchNoticias(
    FetchNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    emit(NoticiaLoading());

    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiaLoaded(noticias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.cargar));
      }
    }
  }

  Future<void> _onAddNoticia(
    AddNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      final noticiaCreada = await _noticiaRepository.crearNoticia(
        event.noticia,
      );
      final noticiasActualizadas = [...noticiasActuales, noticiaCreada];
      emit(NoticiaCreated(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.crear));
      }
    }
  }

  Future<void> _onUpdateNoticia(
    UpdateNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      final noticiaActualizada = await _noticiaRepository.editarNoticia(event.noticia);

      // Reemplazar la noticia con el mismo ID por la versión actualizada
      final noticiasActualizadas =
          noticiasActuales.map((noticia) {
            // Si encuentra la noticia con el mismo ID, devuelve la versión actualizada
            if (noticia.id == noticiaActualizada.id) {
              return noticiaActualizada;
            }
            // De lo contrario, mantiene la noticia original
            return noticia;
          }).toList();

      emit(NoticiaUpdated(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
      }
    }
  }

  Future<void> _onDeleteNoticia(
    DeleteNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      await _noticiaRepository.eliminarNoticia(event.id);

      // Filtrar la lista de noticias para quitar la noticia eliminada
      final noticiasActualizadas =
          noticiasActuales
              .where((noticia) => noticia.id != event.id)
              .toList();

      emit(NoticiaDeleted(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.eliminar));
      }
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferenciasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      // Si no hay categorías seleccionadas, mostrar todas las noticias
      if (event.categoriasIds.isEmpty) {
        emit(NoticiaFiltered(noticiasActuales, DateTime.now(), event.categoriasIds));
      } else {
        // Si hay categorías seleccionadas, filtrar por ellas
        final noticiasFiltradas =
          noticiasActuales
              .where((noticia) =>  event.categoriasIds.contains(noticia.categoriaId),)
              .toList();
        emit(NoticiaFiltered(noticiasFiltradas, DateTime.now(), event.categoriasIds));
      }
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.filtrar));
      } 
    }
  }

  Future<void> _onResetNoticias(
    ResetNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    // Reiniciar el estado a inicial
    emit(NoticiaInitial());
  }
}
