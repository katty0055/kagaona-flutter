import 'package:kgaona/constants/constants.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaHelper {
  static String obtenerNombreCategoria(String categoriaId, List<Categoria> categorias) {
    if (categoriaId.isEmpty || categoriaId == ConstantesCategoria.defaultcategoriaId) {
      return 'Sin categoría';
    }
    
    final categoria = categorias.firstWhere(
      (c) => c.id == categoriaId,
      orElse: () => Categoria(id: '', nombre: 'Desconocida', descripcion: '', imagenUrl: '')
    );
    return categoria.nombre;
  }
}