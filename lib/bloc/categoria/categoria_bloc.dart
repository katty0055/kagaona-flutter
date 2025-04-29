import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/data/categoria_repository.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository _categoriaRepository;
  
  CategoriaBloc({
    required CategoriaRepository categoriaRepository,
  }) : _categoriaRepository = categoriaRepository,
        super(const CategoriaLoadingState()) {
    on<CargarCategoriasEvent>(_onCargarCategorias);
  }

  Future<void> _onCargarCategorias(
    CargarCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    // Emitir estado de carga
    emit(const CategoriaLoadingState());
    
    // Para este ejemplo simple, solo mantenemos el estado de carga
    // En una implementación real, añadirías aquí la lógica para cargar datos
    // y emitir el estado loaded o error según corresponda
    
    // No realizamos ninguna acción adicional para mantener el estado de carga
  }
}
