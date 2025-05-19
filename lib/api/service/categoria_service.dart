import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaService extends BaseService {
  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> obtenerCategorias() async {
    final List<dynamic> categoriasJson = await get<List<dynamic>>(
      ApiConfig.categoriaEndpoint,
      errorMessage: ConstantesCategorias.mensajeError,
    );

    return categoriasJson
        .map<Categoria>(
          (json) => CategoriaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Categoria categoria) async {
    await post(
      ApiConfig.categoriaEndpoint,
      data: categoria.toMap(),
      errorMessage: 'Error al crear la categoría',
    );
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(Categoria categoria) async {
    final url = '${ApiConfig.categoriaEndpoint}/${categoria.id}';
    await put(
      url,
      data: categoria.toMap(),
      errorMessage: 'Error al editar la categoría',
    );
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    final url = '${ApiConfig.categoriaEndpoint}/$id';
    await delete(url, errorMessage: 'Error al eliminar la categoría');
  }
}
