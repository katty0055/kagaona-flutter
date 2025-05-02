import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria2/categoria_event.dart';
import 'package:kgaona/bloc/categoria2/categoria_state.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository _categoriaRepository;

  CategoriaBloc({
    required CategoriaRepository categoriaRepository,
  })  : _categoriaRepository = categoriaRepository,
        super(const CategoriaState()) {
    on<CargarCategoriasEvent>(_onCargarCategorias);
    on<AgregarCategoriaEvent>(_onAgregarCategoria);
    on<EditarCategoriaEvent>(_onEditarCategoria);
    on<EliminarCategoriaEvent>(_onEliminarCategoria);
  }

  Future<void> _onCargarCategorias(
    CargarCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: CategoriaStatus.loading,
        errorMessage: null,
      ));

      final categorias = await _categoriaRepository.obtenerCategorias();

      emit(state.copyWith(
        categorias: categorias,
        status: CategoriaStatus.loaded,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoriaStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAgregarCategoria(
    AgregarCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await _categoriaRepository.crearCategoria(event.categoria);
      
      // Volvemos a cargar las categorías para mostrar la lista actualizada
      add(const CargarCategoriasEvent(mostrarMensaje: false));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEditarCategoria(
    EditarCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await _categoriaRepository.actualizarCategoria(event.id, event.categoria);
      
      // Actualizar la categoría en la lista local para respuesta inmediata
      final List<Categoria> categoriasActualizadas = List.from(state.categorias);
      final index = categoriasActualizadas.indexWhere((c) => c.id == event.id);
      
      if (index != -1) {
        categoriasActualizadas[index] = event.categoria;
      }
      
      emit(state.copyWith(
        categorias: categoriasActualizadas,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEliminarCategoria(
    EliminarCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    if (event.categoria.id == null) return;
    
    try {
      await _categoriaRepository.eliminarCategoria(event.categoria.id!);
      
      // Eliminar la categoría de la lista local para respuesta inmediata
      final categoriasActualizadas = state.categorias
          .where((c) => c.id != event.categoria.id)
          .toList();
      
      emit(state.copyWith(
        categorias: categoriasActualizadas,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }
}