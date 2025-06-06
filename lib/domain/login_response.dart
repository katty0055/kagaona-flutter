import 'package:dart_mappable/dart_mappable.dart';
import 'package:kgaona/constants/constantes.dart';
part 'login_response.mapper.dart';

@MappableClass()
class LoginResponse with LoginResponseMappable {
  @MappableField(key: AuthConstantes.sessionToken)
  final String sessionToken;
  const LoginResponse({required this.sessionToken});
}
