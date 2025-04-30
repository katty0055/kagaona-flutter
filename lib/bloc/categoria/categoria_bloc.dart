import 'package:bloc/bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CategoriaCreateEvent>(_onCreate);
    on<CategoriaUpdateEvent>(_onUpdate);
    on<CategoriaDeleteEvent>(_onDelete);
  }

  Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      final categorias = await categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError('Error al cargar las categorías', e, TipoOperacion.cargar));
      } 
    }
  }

  Future<void> _onCreate(CategoriaCreateEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {

      await categoriaRepository.crearCategoria(event.categoria);
      
      final categorias = await categoriaRepository.obtenerCategorias();

      emit(CategoriaCreated(categorias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError('Error al crear la categoría', e, TipoOperacion.crear));
      }
    }
  }

  Future<void> _onUpdate(CategoriaUpdateEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      await categoriaRepository.actualizarCategoria(event.id, event.categoria);
      
      final categorias = await categoriaRepository.obtenerCategorias();

      emit(CategoriaUpdated(categorias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError('Error al actualizar la categoría', e,TipoOperacion.actualizar));
      }
    }
  }

  Future<void> _onDelete(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      await categoriaRepository.eliminarCategoria(event.id);
      
      final categorias = await categoriaRepository.obtenerCategorias();

      emit(CategoriaDeleted(categorias, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError('Error al eliminar la categoría', e, TipoOperacion.eliminar));
      } 
    }
  } 
}