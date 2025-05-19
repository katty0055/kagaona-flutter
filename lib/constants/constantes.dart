class Constants {
  //const String TITLE_APPBAR = 'Lista de Tareas';
  static const String tituloAppbar = 'Lista de Tareas';
  //const String EMPTY_LIST = 'No hay tareas';
  static const String listaVacia = 'No hay tareas';
  //const String TASK_TYPE_LABEL = 'Tipo: ';
  static const String tipoTarea = 'Tipo: ';
  static const String pasosTitulo = 'Pasos para completar:';
  static const String fechaLimite = 'Fecha límite:';
  static const String tareaEliminada = 'Tarea eliminada';
  // const String titleApp = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScore = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de Nuevo';
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 10;
  static const String formatoFecha = 'dd/MM/yyyy HH:mm'; 
  static const double espaciadoAlto = 10;
}

class ConstantesNoticias {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String errorNotFound = 'Noticia no encontrada';
  static const String successUpdated = 'Noticia actualizada exitosamente';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
}

class ConstantesApi {
  static const String errorServer = 'Error del servidor';
  static const String errorUnauthorized = 'No autorizado';
  static const int timeoutSeconds = 10;
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String usuarioDefault = 'Usuario anonimo';
}

class ConstantesComentarios {
  static const String mensajeCargando = 'Cargando comentarios...';
  static const String listaVacia = 'No hay comentarios disponibles';
  static const String mensajeError = 'Error al cargar comentarios';
  static const String errorNoComentario = 'Comentario no encontrado';
  static const String successCreated = 'Comentario agregado exitosamente';
  static const String successReaction = 'Reacción registrada exitosamente';
  static const String successSubcomentario = 'Subcomentario agregado exitosamente';
}

class ConstantesCategorias{
  static const String tituloApp = 'Categorías de Noticias';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String listaVacia = 'No hay categorias disponibles';
  static const String mensajeError = 'Error al cargar categorías';
  static const String errorNocategoria = 'Categoría no encontrada';
  static const String defaultcategoriaId = 'sin_categoria';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String successCreated = 'Categoria creada exitosamente';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  static const String noticiaNoExiste = 'La noticia reportada no existe';
  static const String errorCrearReporte = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  static const String listaVacia = 'No hay reportes disponibles';
  static const String mensajeCargando = 'Cargando reportes...';
}
