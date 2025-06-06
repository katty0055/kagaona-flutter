import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/data/preferencia_repository.dart';
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
    on<ActualizarContadorReportesEvent>(_onActualizarContadorReportes);
    on<ActualizarContadorComentariosEvent>(_onActualizarContadorComentarios);
  }

  // Modificar el método _onFetchNoticias para incluir información de filtro

  Future<void> _onFetchNoticias(
    FetchNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    emit(NoticiaLoading());
    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      final preferenciaRepo = di<PreferenciaRepository>();
      List<String> categoriasIds =
          await preferenciaRepo.obtenerCategoriasSeleccionadas();

      List<Noticia> noticiasFiltradas = _filtrarNoticiasPorCategorias(
        noticias,
        categoriasIds,
      );
      
      // Pasar categorías filtradas solo si realmente hay filtro
      emit(NoticiaLoaded(
        noticiasFiltradas, 
        DateTime.now(),
        categoriasFiltradas: categoriasIds.isEmpty ? null : categoriasIds,
      ));
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
    try {
      final noticia = await _noticiaRepository.crearNoticia(event.noticia);
      
      if (state is NoticiaLoaded) {
        final currentState = state as NoticiaLoaded;
        final updatedNoticias = List<Noticia>.from(currentState.noticias);
        
        // Si hay filtros activos, solo añadir la noticia a la lista visible si coincide con el filtro
        if (currentState.estaFiltrado) {
          if (noticia.categoriaId != null && 
              noticia.categoriaId!.isNotEmpty && 
              currentState.categoriasFiltradas!.contains(noticia.categoriaId)) {
            updatedNoticias.add(noticia);
          }
          // No añadimos la noticia a la lista visible si no coincide con el filtro actual
        } else {
          // Si no hay filtros activos, añadir la noticia normalmente
          updatedNoticias.add(noticia);
        }
        
        emit(NoticiaCreated(
          updatedNoticias, 
          DateTime.now(),
          categoriasFiltradas: currentState.categoriasFiltradas,
        ));
      }
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
      final noticiaActualizada = await _noticiaRepository.editarNoticia(
        event.noticia,
      );

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
          noticiasActuales.where((noticia) => noticia.id != event.id).toList();

      emit(NoticiaDeleted(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.eliminar));
      }
    }
  }

  // Modificar también _onFilterNoticiasByPreferencias
  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferenciasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      try {
        noticiasActuales = await _noticiaRepository.obtenerNoticias();
        List<Noticia> noticiasFiltradas = _filtrarNoticiasPorCategorias(
          noticiasActuales,
          event.categoriasIds,
        );
        emit(
          NoticiaFiltered(
            noticiasFiltradas,
            DateTime.now(),
            categoriasFiltradas: event.categoriasIds.isEmpty ? [] : event.categoriasIds,
          ),
        );
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.cargar));
        }
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

  Future<void> _onActualizarContadorReportes(
    ActualizarContadorReportesEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }

    // Buscar la noticia que necesitamos actualizar
    final index = noticiasActuales.indexWhere(
      (noticia) => noticia.id == event.noticiaId,
    );

    // Si encontramos la noticia, actualizamos su contador
    if (index >= 0) {
      try {
        // Persistir el cambio en la API
        await _noticiaRepository.incrementarContadorReportes(
          event.noticiaId,
          event.nuevoContador,
        );

        // Crear una copia de la noticia con el contador actualizado
        final noticiaActualizada = noticiasActuales[index].copyWith(
          contadorReportes: event.nuevoContador,
        );

        // Reemplazar la noticia en la lista
        noticiasActuales[index] = noticiaActualizada;

        // Emitir nuevo estado con la lista actualizada
        emit(NoticiaLoaded(noticiasActuales, DateTime.now()));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
        }
      }
    }
  }

  Future<void> _onActualizarContadorComentarios(
    ActualizarContadorComentariosEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }

    // Buscar la noticia que necesitamos actualizar
    final index = noticiasActuales.indexWhere(
      (noticia) => noticia.id == event.noticiaId,
    );

    // Si encontramos la noticia, actualizamos su contador
    if (index >= 0) {
      try {
        // Persistir el cambio en la API
        await _noticiaRepository.incrementarContadorComentarios(
          event.noticiaId,
          event.nuevoContador,
        );

        // Crear una copia de la noticia con el contador actualizado
        final noticiaActualizada = noticiasActuales[index].copyWith(
          contadorComentarios: event.nuevoContador,
        );

        // Reemplazar la noticia en la lista
        noticiasActuales[index] = noticiaActualizada;

        // Emitir nuevo estado con la lista actualizada
        emit(NoticiaLoaded(noticiasActuales, DateTime.now()));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
        }
      }
    }
  }

  // Modificar o agregar este método de filtrado
  List<Noticia> _filtrarNoticiasPorCategorias(
    List<Noticia> noticias,
    List<String> categoriaIds,
  ) {
    // Si no hay categorías seleccionadas para filtrar, devolver todas las noticias
    if (categoriaIds.isEmpty) {
      return noticias;
    }

    // Filtrar solo las noticias que tienen una categoría que coincide con las seleccionadas
    return noticias.where((noticia) {
      // Si la noticia no tiene categoría (categoriaId es null o vacío), no debe mostrarse cuando hay filtros activos
      if (noticia.categoriaId == null || noticia.categoriaId!.isEmpty) {
        return false;
      }
      
      return categoriaIds.contains(noticia.categoriaId);
    }).toList();
  }
}
