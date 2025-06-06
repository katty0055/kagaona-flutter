import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/domain/login_request.dart';
import 'package:kgaona/domain/login_response.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/constants/constantes.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dynamic data;
      final List<LoginRequest> usuariosTest = [
        const LoginRequest(username: 'profeltes', password: 'sodep'),
        const LoginRequest(username: 'monimoney', password: 'sodep'),
        const LoginRequest(username: 'sodep', password: 'sodep'),
        const LoginRequest(username: 'gricequeen', password: 'sodep'),
      ];
      bool credencialesValidas = usuariosTest.any(
        (usuario) =>
            usuario.username == request.username &&
            usuario.password == request.password,
      );
      if (credencialesValidas) {
        data = await postUnauthorized(
          ApiConstantes.cotizacionesEndpoint,
          data: request.toJson(),
        );
      }

      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException(AuthConstantes.errorServer);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(AuthConstantes.errorLogin);
      }
    }
  }
}
