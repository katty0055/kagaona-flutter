import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/preferencia.dart';

class PreferenciaService extends BaseService {
  Future<Preferencia> obtenerPreferenciaPorEmail(String email) async {
    final endpoint = '${ApiConstantes.preferenciasEndpoint}/$email';
    final Map<String, dynamic> responseData = await get<Map<String, dynamic>>(
      endpoint,
      errorMessage: PreferenciaConstantes.mensajeError,
    );
    return PreferenciaMapper.fromMap(responseData);
  }

  Future<Preferencia> guardarPreferencias(Preferencia preferencia) async {
    final endpoint =
        '${ApiConstantes.preferenciasEndpoint}/${preferencia.email}';
    final dataToSend = PreferenciaMapper.ensureInitialized().encodeMap(
      preferencia,
    );
    final response = await put(
      endpoint,
      data: dataToSend,
      errorMessage: PreferenciaConstantes.errorUpdated,
    );
    return PreferenciaMapper.fromMap(response);
  }

  Future<Preferencia> crearPreferencia(
    String email, {
    List<String>? categorias,
  }) async {
    final Map<String, dynamic> preferenciasData = {
      'email': email,
      'categoriasSeleccionadas': categorias ?? [],
    };
    final response = await post(
      ApiConstantes.preferenciasEndpoint,
      data: preferenciasData,
      errorMessage: PreferenciaConstantes.errorCreated,
    );
    return PreferenciaMapper.fromMap(response);
  }
}
