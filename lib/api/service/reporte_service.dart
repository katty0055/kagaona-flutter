import 'dart:async';
import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/reporte.dart';


class ReporteService extends BaseService {
  /// Envía un reporte
  Future<void> enviarReporte(Reporte reporte) async {
    await post(
      ApiConstantes.reportesEndpoint,
      data: reporte.toMap(),
      errorMessage: ReporteConstantes.errorCrear,
    );
  }

  /// Obtiene todos los reportes de una noticia específica
  Future<List<Reporte>> obtenerReportes(noticiaId) async {
    final List<dynamic> reportesJson = await get<List<dynamic>>(
      '${ApiConstantes.reportesEndpoint}?noticiaId=$noticiaId',
      errorMessage: ReporteConstantes.errorObtenerReportes,
    );
    return reportesJson
        .map<Reporte>(
          (json) => ReporteMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }
}
