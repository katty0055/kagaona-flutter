import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaHelper {
  static String obtenerNombreCategoria(String categoriaId, List<Categoria> categorias) {
    if (categoriaId.isEmpty || categoriaId == ConstantesCategorias.defaultcategoriaId) {
      return 'Sin categoría';
    }
    
    final categoria = categorias.firstWhere(
      (c) => c.id == categoriaId,
      orElse: () => const Categoria(id: '', nombre: 'Desconocida', descripcion: '', imagenUrl: '')
    );
    return categoria.nombre;
  }
}