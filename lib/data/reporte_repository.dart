import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/api/service/reporte_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/data/base_repository.dart';
import 'package:kgaona/domain/reporte.dart';
import 'package:watch_it/watch_it.dart';

class ReporteRepository extends BaseRepository<Reporte> {
  final _reporteService = di<ReporteService>();
  final _noticiaService = di<NoticiaService>();

  @override
  void validarEntidad(Reporte reporte) {
    // Validaciones adicionales si es necesario
  }

  Future<void> enviarReporte(String noticiaId, MotivoReporte motivo) async {
    return manejarExcepcion(() async {
      await _noticiaService.verificarNoticiaExiste(noticiaId);
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );
      _reporteService.enviarReporte(reporte);
    }, mensajeError: ReporteConstantes.errorCrear);
  }

  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportesPorNoticia(
    String noticiaId,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, ValidacionConstantes.noticiaId);
      final reportes = await _reporteService.obtenerReportes(noticiaId);
      final estadisticas = <MotivoReporte, int>{};
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }      
      for (final reporte in reportes) {
        estadisticas[reporte.motivo] = (estadisticas[reporte.motivo] ?? 0) + 1;
      }
      return estadisticas;
    }, mensajeError: ReporteConstantes.errorObtenerEstadisticas);
  }

  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, ValidacionConstantes.noticiaId);
      await _reporteService.eliminarReportesPorNoticia(noticiaId);
    }, mensajeError: ReporteConstantes.errorEliminarReportes);
  }
}
