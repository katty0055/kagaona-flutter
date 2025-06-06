import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/exceptions/api_exception.dart';

abstract class BaseRepository<T> {
  void validarEntidad(T entidad);

  Future<R> manejarExcepcion<R>(
    Future<R> Function() accion, {
    String mensajeError = AppConstantes.errorInesperado,
  }) async {
    try {
      return await accion();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('$mensajeError: $e');
      }
    }
  }

  void validarNoVacio(String? valor, String nombreCampo) {
    if (valor == null || valor.isEmpty) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.campoVacio}',
        statusCode: 400,
      );
    }
  }

  void validarId(String? id) {
    validarNoVacio(id, ValidacionConstantes.idCampo);
  }

  void validarFechaNoFutura(DateTime fecha, String nombreCampo) {
    if (fecha.isAfter(DateTime.now())) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.noFuturo}',
        statusCode: 400,
      );
    }
  }
}

abstract class CacheableRepository<T> extends BaseRepository<T> {
  List<T>? _cache;
  bool _cambiosPendientes = false;

  Future<List<T>> obtenerDatos({bool forzarRecarga = false}) async {
    if (forzarRecarga || _cache == null) {
      _cache = await cargarDatos();
    }
    return _cache ?? [];
  }

  Future<List<T>> cargarDatos();

  void marcarCambiosPendientes() {
    _cambiosPendientes = true;
  }

  bool hayCambiosPendientes() {
    return _cambiosPendientes;
  }

  void invalidarCache() {
    _cache = null;
    _cambiosPendientes = false;
  }
}
