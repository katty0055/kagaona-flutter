import 'dart:async';
import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/preferencia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaService extends BaseService {

  // Servicio para obtener email del usuario
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  /// Obtiene las preferencias del usuario identificadas por su email
  Future<Preferencia> obtenerPreferencias() async {
    try {
      // Obtener el email del usuario autenticado
      final email = await _secureStorage.getUserEmail();      
      try {
        // Intentar obtener las preferencias directamente por email
        final endpoint = '${ApiConfig.preferenciasEndpoint}/$email';
        final Map<String, dynamic> responseData = await get<Map<String, dynamic>>(
          endpoint,
          errorMessage: 'Error al obtener preferencias',
        );
        
        // Si la respuesta es exitosa, convertir a objeto Preferencia
        return PreferenciaMapper.fromMap(responseData);

      } on ApiException catch (e) {        
        if (e.statusCode == 404) {
          return await _crearPreferenciasVacias(email!);
        } else {
          rethrow;
        }
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener preferencias: $e');
    }
  }
  /// Guarda las preferencias del usuario (Actualiza)
  Future<void> guardarPreferencias(Preferencia preferencia) async {    
    try {
      // Preparando datos para enviar a la API
      final dataToSend = PreferenciaMapper.ensureInitialized().encodeMap(preferencia);
      final endpoint = '${ApiConfig.preferenciasEndpoint}/${preferencia.email}';
      
      await put(
        endpoint,
        data: dataToSend,
        errorMessage: 'Error al guardar preferencias',
      );
      
    } on ApiException catch (e) {
      // Si no existe, intentar crear
      if (e.statusCode == 404) {
        await _crearPreferenciasVacias(preferencia.email, 
            categorias: preferencia.categoriasSeleccionadas);
      } else {
        rethrow;
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al guardar preferencias: $e');
    }
  }
  /// Método auxiliar para crear un nuevo registro de preferencias vacías
  Future<Preferencia> _crearPreferenciasVacias(String email, {List<String>? categorias}) async {
    try {
      // Datos para enviar a la API
      final Map<String, dynamic> preferenciasData = {
        'email': email,
        'categoriasSeleccionadas': categorias ?? []
      };

      // Crear un nuevo registro en la API
      await post(
        ApiConfig.preferenciasEndpoint,
        data: preferenciasData,
        errorMessage: 'Error al crear preferencias',
      );
      
      // Crear y devolver objeto Preferencia
      final preferencia = Preferencia(
        email: email,
        categoriasSeleccionadas: categorias ?? []
      );
      
      return preferencia;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al crear preferencias: $e');
    }
  }
}
