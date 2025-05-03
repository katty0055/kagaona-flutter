import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/preferencia/preferencia_event.dart';
import 'package:kgaona/bloc/preferencia/preferencia_state.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciasRepository = di<PreferenciaRepository>(); // Obtenemos el repositorio del locator

  PreferenciaBloc() : super(const PreferenciaState()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<ChangeCategory>(_onChangeCategory);
    on<ChangeFavoritesVisibility>(_onChangeFavoritesVisibility);
    on<SavePreferences>(_onSavePreferences);
    on<SearchByKeyword>(_onSearchByKeyword);
    on<FilterByDate>(_onFilterByDate);
    on<ChangeSort>(_onChangeSort);
    on<ResetFilters>(_onResetFilters);
  }

  Future<void> _onLoadPreferences(
    LoadPreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Obtener solo las categorías seleccionadas del repositorio existente
      final categoriasSeleccionadas = await _preferenciasRepository.obtenerCategoriasSeleccionadas();

      // Como el repositorio original solo almacena categorías, el resto de valores serían por defecto
      emit(PreferenciaState(
        categoriasSeleccionadas: categoriasSeleccionadas,
        // Valores por defecto para el resto de propiedades
        mostrarFavoritos: false,
        palabraClave: '',
        fechaDesde: null,
        fechaHasta: null,
        ordenarPor: 'fecha',
        ascendente: false,
      ));
    } catch (e) {
      emit(PreferenciaError('Error al cargar preferencias: ${e.toString()}'));
    }
  }

  void _onChangeCategory(
    ChangeCategory event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // 1. Crear una copia de las categorías actuales para modificar
      final List<String> categoriasActualizadas = [...state.categoriasSeleccionadas];

      // 2. Actualizar localmente primero para feedback inmediato
      if (event.selected) {
        if (!categoriasActualizadas.contains(event.category)) {
          categoriasActualizadas.add(event.category);
        }
      } else {
        categoriasActualizadas.remove(event.category);
      }

      // 3. Emitir estado actualizado inmediatamente para UI responsiva
      emit(state.copyWith(categoriasSeleccionadas: categoriasActualizadas));

      // 4. Luego intentar persistir el cambio (sin bloquear la UI)
      try {
        if (event.selected) {
          await _preferenciasRepository.agregarCategoriaFiltro(event.category);
        } else {
          await _preferenciasRepository.eliminarCategoriaFiltro(event.category);
        }
      } catch (e) {
        // Si falla la persistencia, no interrumpir la experiencia del usuario
        // pero registrar el error para depuración
        print('Error al persistir cambio de categoría: $e');

        // Opcionalmente, podrías emitir un estado de "sincronización pendiente"
        // para indicar que los cambios locales no se han guardado aún
      }
    } catch (e) {
      // Este catch solo atraparía errores graves en la lógica del bloc
      emit(PreferenciaError('Error al cambiar categoría: ${e.toString()}'));
    }
  }

  void _onChangeFavoritesVisibility(
    ChangeFavoritesVisibility event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(mostrarFavoritos: event.showFavorites);
    emit(nuevoEstado);
  }

  void _onSearchByKeyword(
    SearchByKeyword event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(palabraClave: event.keyword);
    emit(nuevoEstado);
  }

  void _onFilterByDate(
    FilterByDate event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(
      fechaDesde: event.fromDate,
      fechaHasta: event.toDate,
    );
    emit(nuevoEstado);
  }

  void _onChangeSort(
    ChangeSort event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(
      ordenarPor: event.sortBy,
      ascendente: event.ascending,
    );
    emit(nuevoEstado);
  }

  void _onResetFilters(
    ResetFilters event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Limpiar las categorías seleccionadas usando el método del repositorio
      await _preferenciasRepository.limpiarFiltrosCategorias();

      // Emitir un estado inicial
      const estadoInicial = PreferenciaState();
      emit(estadoInicial);
    } catch (e) {
      emit(PreferenciaError('Error al reiniciar filtros: ${e.toString()}'));
    }
  }

  Future<void> _onSavePreferences(
    SavePreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Más eficiente: guardar todas las categorías a la vez
      await _preferenciasRepository.guardarCategoriasSeleccionadas(event.selectedCategories);

      // Emitir el estado actualizado
      emit(state.copyWith(categoriasSeleccionadas: event.selectedCategories));
    } catch (e) {
      emit(PreferenciaError('Error al guardar preferencias: ${e.toString()}'));
    }
  }
}
