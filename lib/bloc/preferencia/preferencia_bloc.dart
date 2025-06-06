import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/preferencia/preferencia_event.dart';
import 'package:kgaona/bloc/preferencia/preferencia_state.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciaRepository =
      di<PreferenciaRepository>();

  PreferenciaBloc() : super(PreferenciaInitial()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<SavePreferences>(_onSavePreferences);
    on<ChangeCategory>(_onChangeCategory);
    on<ResetFilters>(_onResetFilters);
  }

  Future<void> _onLoadPreferences(
    LoadPreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    emit(PreferenciaLoading());

    try {
      final categoriasSeleccionadas =
          await _preferenciaRepository.obtenerCategoriasSeleccionadas();
      emit(
        PreferenciasLoaded(
          categoriasSeleccionadas: categoriasSeleccionadas,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.cargar));
      }
    }
  }

  Future<void> _onSavePreferences(
    SavePreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      emit(PreferenciaLoading());
      await _preferenciaRepository.guardarCategoriasSeleccionadas(
        event.selectedCategories,
      );
      await _preferenciaRepository.guardarCambiosEnAPI();
      emit(
        PreferenciasSaved(
          categoriasSeleccionadas: event.selectedCategories,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.guardar));
      }
    }
  }

  Future<void> _onChangeCategory(
    ChangeCategory event,
    Emitter<PreferenciaState> emit,
  ) async {
    if (state is! PreferenciasLoaded) {
      return;
    }
    final currentState = state as PreferenciasLoaded;
    List<String> updatedCategories = List.from(
      currentState.categoriasSeleccionadas,
    );

    if (event.selected) {
      if (!updatedCategories.contains(event.category)) {
        updatedCategories.add(event.category);
      }
    } else {
      updatedCategories.remove(event.category);
    }

    emit(
      PreferenciasLoaded(
        categoriasSeleccionadas: updatedCategories,
        lastUpdated: DateTime.now(),
      ),
    );

    try {
      if (event.selected) {
        await _preferenciaRepository.agregarCategoriaFiltro(event.category);
      } else {
        await _preferenciaRepository.eliminarCategoriaFiltro(event.category);
      }
    } catch (e) {
      if (e is ApiException && e.statusCode! >= 500) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.cambiarCategoria));
      }
    }
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<PreferenciaState> emit,
  ) async {
    emit(PreferenciaLoading());

    try {
      await _preferenciaRepository.limpiarFiltrosCategorias();
      await _preferenciaRepository.guardarCambiosEnAPI();
      emit(
        PreferenciasSaved(
          categoriasSeleccionadas:const [],
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.reiniciar));
      }
    }
  }
}
