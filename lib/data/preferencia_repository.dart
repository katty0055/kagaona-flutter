import 'package:kgaona/api/service/preferencia_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/data/base_repository.dart';
import 'package:kgaona/domain/preferencia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaRepository extends CacheableRepository<Preferencia> {
  final _preferenciaService = di<PreferenciaService>();
  final _secureStorage = di<SecureStorageService>();

  Preferencia? _cachedPreferencias;

  @override
  void validarEntidad(Preferencia preferencia) {
    validarNoVacio(preferencia.email, ValidacionConstantes.email);
  }

  @override
  Future<List<Preferencia>> cargarDatos() async {
    if (_cachedPreferencias == null) {
      await inicializarPreferenciasUsuario();
    }
    return _cachedPreferencias != null ? [_cachedPreferencias!] : [];
  }

  /// Inicializa las preferencias del usuario autenticado actual.
  /// Busca directamente por email las preferencias del usuario.
  /// Si no existen, crea unas preferencias vacías para ese email.
  Future<void> inicializarPreferenciasUsuario() async {
    return manejarExcepcion(() async {
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException(AppConstantes.notUser, statusCode: 401);
      }
      try {
        final preferencia = await _preferenciaService
            .obtenerPreferenciaPorEmail(email);
        _cachedPreferencias = preferencia;
      } catch (e) {
        if (e is ApiException && e.statusCode == 404) {
          _cachedPreferencias = await _preferenciaService.crearPreferencia(
            email,
          );
        } else {
          rethrow;
        }
      }
    }, mensajeError: PreferenciaConstantes.errorInit);
  }

  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }
      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    }, mensajeError: CategoriaConstantes.mensajeError);
  }

  Future<void> _actualizarCacheLocal(List<String> categoriaIds) async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }
      final email =
          _cachedPreferencias?.email ??
          (await _secureStorage.getUserEmail() ?? AppConstantes.usuarioDefault);
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds,
      );
      marcarCambiosPendientes();
    }, mensajeError: AppConstantes.errorCache);
  }

  Future<void> guardarCambiosEnAPI() async {
    return manejarExcepcion(() async {
      if (!hayCambiosPendientes()) {
        return;
      }
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
        if (!hayCambiosPendientes()) {
          return;
        }
      }
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      super.invalidarCache();
    }, mensajeError: PreferenciaConstantes.errorUpdated);
  }

  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return _actualizarCacheLocal(categoriaIds);
  }

  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await _actualizarCacheLocal(categorias);
      }
    }, mensajeError: CategoriaConstantes.errorAdd);
  }

  /// Elimina una categoría de las categorías seleccionadas (solo en caché)
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await _actualizarCacheLocal(categorias);
    }, mensajeError: CategoriaConstantes.errorDelete);
  }

  /// Limpia todas las categorías seleccionadas (solo en caché)
  Future<void> limpiarFiltrosCategorias() async {
    return _actualizarCacheLocal([]);
  }

  @override
  void invalidarCache() {
    super.invalidarCache();
    _cachedPreferencias = null;
  }
}
