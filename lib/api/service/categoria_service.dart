import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/exceptions/api_exception.dart';


class CategoriaService {
  final CategoriaRepository _categoriaRepository = CategoriaRepository();

  // Método privado para validar una categoría
  void _validarCategoria(Category categoria) {
    if (categoria.nombre.isEmpty) {
      throw ApiException('El nombre de la categoría no puede estar vacío.', statusCode: 400);
    }
    if (categoria.descripcion.isEmpty) {
      throw ApiException('La descripción de la categoría no puede estar vacía.', statusCode: 400);
    }
    if (categoria.imagenUrl.isEmpty) {
      throw ApiException('La URL de la imagen no puede estar vacía.', statusCode: 400);
    }
  }

  // Obtiene todas las categorías desde el repositorio
  Future<List<Category>> obtenerCategorias() async {
    try {
      return await _categoriaRepository.obtenerCategorias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  
  // Crea una nueva categoría
  Future<void> crearCategoria(Category categoria) async {
    try {
      // Validar la categoría antes de enviarla
      _validarCategoria(categoria);

      // Este método necesita ser implementado en el repositorio
      await _categoriaRepository.crearCategoria(categoria.toJson());

    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  // Edita una categoría existente
  Future<void> actualizarCategoria(String id, Category categoria) async {
    try {
      // Validar la categoría antes de enviarla
      _validarCategoria(categoria);

      // Este método necesita ser implementado en el repositorio
      await _categoriaRepository.editarCategoria(id, categoria.toJson());

    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  // Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('El ID de la categoría no puede estar vacío.');
      }

      await _categoriaRepository.eliminarCategoria(id);

    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  } 
}