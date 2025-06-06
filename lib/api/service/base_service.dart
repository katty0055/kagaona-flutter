import 'package:dio/dio.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/connectivity_service.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart' show di;

class BaseService {
  late final Dio _dio;
  final _secureStorage = di<SecureStorageService>();

  BaseService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.beeceptorBaseUrl,
        connectTimeout: const Duration(
          milliseconds: (AppConstantes.timeoutSeconds * 1000),
        ),
        receiveTimeout: const Duration(
          milliseconds: (AppConstantes.timeoutSeconds * 1000),
        ),
        headers: {
          'x-beeceptor-auth': ApiConfig.beeceptorApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static ApiException handleError(DioException e, String endpoint) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(AppConstantes.errorTimeOut);
    }

    String errorNotFound = '';
    String errorUnauthorized = '';
    String errorBadRequest = '';
    String errorServer = '';

    if (endpoint.contains(ApiConstantes.categoriaEndpoint)) {
      errorNotFound = CategoriaConstantes.errorNocategoria;
      errorUnauthorized = CategoriaConstantes.errorUnauthorized;
      errorBadRequest = CategoriaConstantes.errorInvalidData;
      errorServer = CategoriaConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.noticiasEndpoint)) {
      errorNotFound = NoticiasConstantes.errorNotFound;
      errorUnauthorized = NoticiasConstantes.errorUnauthorized;
      errorBadRequest = NoticiasConstantes.errorInvalidData;
      errorServer = NoticiasConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.preferenciasEndpoint)) {
      errorNotFound = PreferenciaConstantes.errorNotFound;
      errorUnauthorized = PreferenciaConstantes.errorUnauthorized;
      errorBadRequest = PreferenciaConstantes.errorInvalidData;
      errorServer = PreferenciaConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.reportesEndpoint)) {
      errorNotFound = ReporteConstantes.errorNotFound;
      errorUnauthorized = ReporteConstantes.errorUnauthorized;
      errorBadRequest = ReporteConstantes.errorInvalidData;
      errorServer = ReporteConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.comentariosEndpoint)) {
      errorNotFound = ComentarioConstantes.errorNotFound;
      errorUnauthorized = ComentarioConstantes.errorUnauthorized;
      errorBadRequest = ComentarioConstantes.errorInvalidData;
      errorServer = ComentarioConstantes.errorServer;
    } else if (ApiConstantes.tareasEndpoint.contains(endpoint)) {
      errorNotFound = TareasConstantes.errorNotFound;
      errorUnauthorized = TareasConstantes.errorUnauthorized;
      errorBadRequest = TareasConstantes.errorInvalidData;
      errorServer = TareasConstantes.errorServer;
    }

    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 400:
        return ApiException(errorBadRequest, statusCode: 400);
      case 401:
        return ApiException(errorUnauthorized, statusCode: 401);
      case 403:
        return ApiException(AppConstantes.errorAccesoDenegado, statusCode: 403);
      case 404:
        return ApiException(errorNotFound, statusCode: 404);
      case 429:
        return ApiException(AppConstantes.limiteAlcanzado, statusCode: 429);
      case 500:
        return ApiException(errorServer, statusCode: 500);
      case 561:
        return ApiException(AppConstantes.errorServidorMock, statusCode: 561);
      case 562:
        return ApiException(AppConstantes.errorUnauthorized, statusCode: 562);
      case 571:
      case 572:
      case 573:
      case 574:
      case 575:
      case 576:
      case 577:
      case 578:
        return ApiException(
          AppConstantes.errorConexionProxy,
          statusCode: statusCode,
        );
      case 580:
        return ApiException(
          AppConstantes.conexionInterrumpida,
          statusCode: 580,
        );
      case 581:
        return ApiException(
          AppConstantes.errorRecuperarRecursos,
          statusCode: 581,
        );
      case 599:
        return ApiException(
          AppConstantes.errorCriticoServidor,
          statusCode: 599,
        );
      default:
        return ApiException(
          '${AppConstantes.errorDesconocido} $endpoint',
          statusCode: statusCode,
        );
    }
  }

  Future<T> _executeRequest<T>(
    Future<Response<dynamic>> Function() requestFn,
    String errorMessage,
  ) async {
    try {
      final connectivityService = di<ConnectivityService>();
      await connectivityService.checkConnectivity();
      final response = await requestFn();
      if (response.statusCode == 200) {
        return response.data as T;
      } else {
        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final endpoint = e.requestOptions.path;
      throw handleError(e, endpoint);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('${AppConstantes.errorInesperado} ${e.toString()}');
    }
  }

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorGetDefault,
    bool requireAuthToken = true,
  }) async {
    final options = await _getRequestOptions(
      requireAuthToken: requireAuthToken,
    );
    return _executeRequest<T>(
      () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  Future<dynamic> post(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorCreateDefault,
    bool requireAuthToken = true,
  }) async {
    final options = await _getRequestOptions(
      requireAuthToken: requireAuthToken,
    );
    return _executeRequest<dynamic>(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorUpdateDefault,
    bool requireAuthToken = true,
  }) async {
    final options = await _getRequestOptions(
      requireAuthToken: requireAuthToken,
    );
    return _executeRequest<dynamic>(
      () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorDeleteDefault,
    bool requireAuthToken = true,
  }) async {
    final options = await _getRequestOptions(
      requireAuthToken: requireAuthToken,
    );
    return _executeRequest<dynamic>(
      () => _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorUpdateDefault,
    bool requireAuthToken = true,
  }) async {
    final options = await _getRequestOptions(
      requireAuthToken: requireAuthToken,
    );
    return _executeRequest<dynamic>(
      () => _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  Future<Options> _getRequestOptions({bool requireAuthToken = true}) async {
    final options = Options();
    if (requireAuthToken) {
      final jwt = await _secureStorage.getJwt();
      if (jwt != null && jwt.isNotEmpty) {
        options.headers = {...(options.headers ?? {}), 'X-Auth-Token': jwt};
      } else {
        throw ApiException(AppConstantes.tokenNoEncontrado, statusCode: 401);
      }
    }
    return options;
  }

  Future<dynamic> postUnauthorized(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorCreateDefault,
  }) async {
    final options = await _getRequestOptions(requireAuthToken: false);
    return _executeRequest<dynamic>(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }
}
