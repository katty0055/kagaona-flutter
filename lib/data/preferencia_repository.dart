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
  /// Inicializa las preferencias del usuario autenticado actual.
  /// Busca directamente por email las preferencias del usuario.
  /// Si no existen, crea unas preferencias vacías para ese email.
  Future<void> inicializarPreferenciasUsuario() async {
    try {
      // Obtener el email del usuario autenticado
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException('No hay usuario autenticado');
      }
      
      try {
        // Buscar directamente por email (más eficiente)
        _cachedPreferencias = await _preferenciaService.obtenerPreferenciaPorEmail(email);
      } catch (e) {
        // Si no encuentra la preferencia (error 404), crear una nueva
        if (e is ApiException && e.statusCode == 404) {
          _cachedPreferencias = await _preferenciaService.crearPreferencias(email);
        } else {
          // Si es otro tipo de error, propagarlo
          rethrow;
        }
      }
    } catch (e) {
      // Propagar errores ApiException o convertir otros errores
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Error al inicializar preferencias: $e');
      }
    }
  }
  
  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, inicializar preferencias
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }

      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    } catch (e) {
      if (e is ApiException) {
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
      // Si no hay caché, inicializar preferencias
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }
      
      // Obtener el email actual desde la caché o buscar uno nuevo
      final email = _cachedPreferencias?.email ?? 
                   (await _secureStorage.getUserEmail() ?? 'usuario@anonymous.com');
      
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
        await inicializarPreferenciasUsuario();
        // Si no hay cambios después de inicializar, no hay nada que guardar
        if (!_cambiosPendientes) {
          return;
        }
      }
      
      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      
      // Reiniciar flag de cambios pendientes
      _cambiosPendientes = false;
      
    } catch (e) {
      if (e is ApiException) {
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
