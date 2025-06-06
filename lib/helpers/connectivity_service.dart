import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Retorna true si hay conexión, false en caso contrario
  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Verifica la conectividad y lanza una excepción si no hay conexión
  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      throw ApiException(
        ConectividadConstantes.mensajeSinConexion,
        statusCode: 503,
      );
    }
  }
}
