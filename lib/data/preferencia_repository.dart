import 'package:kgaona/api/service/preferencia_service.dart';
import 'package:kgaona/domain/preferencia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaRepository {
  final PreferenciaService _preferenciaService = PreferenciaService();
  final SecureStorageService _secureStorage = di<SecureStorageService>(); 

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;
  
  // Flag para saber si hay cambios pendientes de guardar
  bool _cambiosPendientes = false;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.obtenerPreferencias();

      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        // En caso de error desconocido, devolver lista vacía para no romper la UI
        return [];
      }
    }
  }

  /// Actualiza la caché local con las nuevas categorías (sin hacer PUT a la API)
  Future<void> _actualizarCacheLocal(List<String> categoriaIds) async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.obtenerPreferencias();
      
      // Obtener el email del usuario autenticado
      final email = await _secureStorage.getUserEmail() ?? 'usuario@anonymous.com';
      
      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds
      );
      
      // Marcar que hay cambios pendientes
      _cambiosPendientes = true;
      
    } catch (e) {
      rethrow;
    }
  }

  /// Guarda las categorías seleccionadas en la API (solo cuando se presiona Aplicar Filtros)
  Future<void> guardarCambiosEnAPI() async {
    try {
      
      // Verificar si hay cambios pendientes
      if (!_cambiosPendientes) {
        return;
      }
      
      // Verificar que la caché esté inicializada
      if (_cachedPreferencias == null) {
        throw ApiException('No hay preferencias en caché para guardar');
      }
      

      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      
      // Reiniciar flag de cambios pendientes
      _cambiosPendientes = false;
      
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al guardar preferencias: $e');
      }
    }
  }

  /// Este método se mantiene para compatibilidad, pero ahora solo actualiza cache
  /// y no hace llamadas a la API
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      await _actualizarCacheLocal(categoriaIds);
    } catch (e) {
      rethrow;
    }
  }

  /// Añade una categoría a las categorías seleccionadas (solo en caché)
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await _actualizarCacheLocal(categorias);
      }
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al agregar categoría: $e');
      }
    }
  }

  /// Elimina una categoría de las categorías seleccionadas (solo en caché)
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await _actualizarCacheLocal(categorias);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al eliminar categoría: $e');
      }
    }
  }

  /// Limpia todas las categorías seleccionadas (solo en caché)
  Future<void> limpiarFiltrosCategorias() async {
    try {
      await _actualizarCacheLocal([]);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al limpiar filtros: $e');
      }
    }
  }

  /// Verifica si hay cambios pendientes de guardar
  bool hayCambiosPendientes() {
    return _cambiosPendientes;
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
    _cambiosPendientes = false;
  }
}
