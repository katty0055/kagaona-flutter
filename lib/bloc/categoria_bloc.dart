import 'package:bloc/bloc.dart';
import 'package:kgaona/bloc/categoria_event.dart';
import 'package:kgaona/bloc/categoria_state.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
  }

  Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      final categorias = await categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to load categories: ${e.toString()}'));
    }
  }

}
