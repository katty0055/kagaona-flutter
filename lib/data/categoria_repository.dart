import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class CategoriaRepository {
  final CategoriaService _categoriaService = CategoriaService();

  /// Método privado para validar una categoría
  void _validarCategoria(Categoria categoria) {
    if (categoria.nombre.isEmpty) {
      throw ApiException(
        'El nombre de la categoría no puede estar vacío.',
        statusCode: 400,
      );
    }
    if (categoria.descripcion.isEmpty) {
      throw ApiException(
        'La descripción de la categoría no puede estar vacía.',
        statusCode: 400,
      );
    }
    if (categoria.imagenUrl.isEmpty) {
      throw ApiException(
        'La URL de la imagen no puede estar vacía.',
        statusCode: 400,
      );
    }
  }

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      return await _categoriaService.obtenerCategorias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      _validarCategoria(categoria);
      await _categoriaService.crearCategoria(categoria);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Edita una categoría existente
  Future<void> actualizarCategoria(Categoria categoria) async {
    try {
      _validarCategoria(categoria);
      await _categoriaService.editarCategoria(categoria);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('El ID de la categoría no puede estar vacío.');
      }
      await _categoriaService.eliminarCategoria(id);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
