import 'package:intl/intl.dart';

class ComentarioConstantes {
  // static const String mensajeCargando = 'Cargando comentarios...';
  // static const String listaVacia = 'No hay comentarios disponibles';
  static const String errorNotFound = 'Comentario no encontrado';
  // static const String successCreated = 'Comentario agregado exitosamente';
  // static const String successReaction = 'Reacción registrada exitosamente';
  // static const String successSubcomentario = 'Subcomentario agregado exitosamente';
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
  static const String errorUnauthorized = 'No autorizado para acceder a comentario';
  static const String errorInvalidData = 'Datos inválidos en comentario';
  static const String errorCreated = 'Error al agregar el comentario';
  static const String errorCreatedSub = 'Error al agregar el subcomentario';
  static const String errorReaccionarComentario = 'Error al reaccionar al comentario';
  static const String errorReaccionarSubComentario = 'Error al reaccionar al subcomentario';
  static const String errorGetComentario = 'Error al buscar el subcomentario';
  static const String errorDeleteComentario = 'Error al eliminar el comentario';
  static const String errorEliminarComentarios= 'Error al eliminar comentarios';
}

class CategoriaConstantes{
  // static const String tituloApp = 'Categorías de Noticias';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String listaVacia = 'No hay categorias disponibles';
  static const String mensajeError = 'Error al obtener categorías';
  static const String errorNocategoria = 'Categoría no encontrada';
  static const String defaultcategoriaId = 'Sin Categoria';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String errorDelete = 'Error al eliminar la categoría';
  static const String errorAdd = 'Error al agregar categoría';
  static const String successCreated = 'Categoria creada exitosamente';
  static const String errorCreated = 'Error al crear la categoría';
  static const String errorUnauthorized = 'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  // static const String noticiaNoExiste = 'La noticia reportada no existe';
  static const String errorEliminarReportes = 'Error al eliminar los reportes de la noticia';
  static const String errorCrear = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  // static const String listaVacia = 'No hay reportes disponibles';
  // static const String mensajeCargando = 'Cargando reportes...';
  static const String errorUnauthorized = 'No autorizado para acceder a reporte';
  static const String errorInvalidData = 'Datos inválidos en reporte';
  static const String errorServer = 'Error del servidor en reporte';
  static const String errorNotFound = 'Reporte no encontrado';
  static const String errorObtenerEstadisticas = 'Error al obtener valores de reportes por noticia';
}

class AppConstantes {
  static const int timeoutSeconds = 10;
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  //static const int pageSize = 10;
  // static const double espaciadoAlto = 10;
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String usuarioDefault = 'Usuario anonimo';
  // static const String errorServer = 'Error del servidor';
  static const String errorUnauthorized = 'Se requiere autenticación';
  // static const String errorNoInternet = 'Sin conexión a Internet';
  // static const String errorInvalidData = 'Datos inválidos';
  static const String tokenNoEncontrado = 'No se encontró el token de autenticación';
  static const String errorDeleteDefault = 'Error al eliminar el recurso';
  static const String errorUpdateDefault = 'Error al actualizar el recurso';
  static const String errorCreateDefault = 'Error al crear el recurso';  
  static const String errorGetDefault = 'Error al obtener el recurso';  
  static const String errorAccesoDenegado = 'Acceso denegado. Verifique su API key o IP autorizada';
  static const String limiteAlcanzado = 'Límite de peticiones alcanzado. Intente más tarde';
  static const String errorServidorMock = 'Error en la configuración del servidor mock';
  static const String errorConexionProxy = 'Error de conexión con el servidor proxy';
  static const String conexionInterrumpida = 'La conexión fue interrumpida';
  static const String errorRecuperarRecursos = 'Error al recuperar recursos del servidor';
  static const String errorCriticoServidor = 'Error crítico en el servidor';
  static const String errorInesperado = 'Error inesperado:';
  static const String errorDesconocido = 'Error desconocido en ';
  static const String notUser = 'No hay usuario autenticado';
  static const String errorCache = 'Error al actualizar caché local';
  static const String inicioApp = 'Inicio';
  static const String resetColor =  'Resetear';
  static const String cambiarColor = 'Cambiar';
  static const String titleMyApp = 'Mi App';
  static const String cambioColor = '¡Cambio de color!';
  String formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }

}

class ApiConstantes {
  static const String categoriaEndpoint = '/categorias';
  static const String noticiasEndpoint = '/noticias';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String comentariosEndpoint = '/comentarios';
  static const String reportesEndpoint = '/reportes';
  static const String tareasEndpoint = '/tareas';
  static const String cotizacionesEndpoint = '/login';
}

class TareasCachePrefsConstantes {
  // static const String tituloApp = 'Preferencias de Tareas';
  // static const String mensajeCargando = 'Cargando preferencias de tareas...';
  // static const String listaVacia = 'No hay preferencias de tareas disponibles';
  // static const String mensajeError = 'Error al obtener preferencias de tareas';
  // static const String errorNotFound = 'Preferencias de tareas no encontradas';
  // static const String successUpdated = 'Preferencias de tareas actualizadas exitosamente';
  // static const String errorUpdated = 'Error al editar las preferencias de tareas';
  // static const String successDeleted = 'Preferencias de tareas eliminadas exitosamente';
  // static const String errorDelete = 'Error al eliminar las preferencias de tareas';
  // static const String errorAdd = 'Error al agregar preferencias de tareas';
  // static const String successCreated = 'Preferencias de tareas creadas exitosamente';
  // static const String errorCreated = 'Error al crear las preferencias de tareas';
  // static const String errorUnauthorized = 'No autorizado para acceder a preferencias de tareas';
  // static const String errorInvalidData = 'Datos inválidos en preferencias de tareas';
  // static const String errorServer = 'Error del servidor en preferencias de tareas';
  // static const String errorSync = 'Error al sincronizar preferencias de tareas';
  // static const String successSync = 'Preferencias de tareas sincronizadas correctamente';
}

class TareasConstantes {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  // static const String tipoTarea = 'Tipo: ';
  static const String tareaTipoNormal = 'normal';
  // static const String taskTypeUrgent = 'urgente';
  // static const String taskDescription = 'Descripción: ';
  // static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  // static const String tareaEliminada = 'Tarea eliminada';
  static const String mensajeError = 'Error al obtener tareas';
  static const String errorEliminar = 'Error al eliminar la tarea';
  static const String errorActualizar = 'Error al actualizar la tarea';
  static const String errorCrear = 'Error al crear la tarea';
  static const String errorNotFound = 'Tarea no encontrada';
  static const String errorUnauthorized = 'No autorizado para acceder a tarea';
  static const String errorInvalidData = 'Datos inválidos en tarea';  
  static const String errorServer = 'Error del servidor en tarea';
  static const String tareaCompletadaExito = 'Tarea completada exitosamente';
  static const String tareaPendiente = 'Tarea marcada como pendiente';
  static const String recargarTareas = 'Recargar tareas';
  static const String recargandoTareas = 'Recargando tareas...';
  static const String agregarTarea = 'Agregar Tarea';
  static const String cargar = 'Cargando tareas...';
  static const String mensajeEliminar = '¿Estás seguro de que deseas eliminar esta tarea?';
  static String limiteTareasAlcanzado(int limite) => 
      'Solo puedes tener $limite tareas. Elimina una tarea existente para crear una nueva.';
  static const String noHayTareasAnteriores = 'No hay tareas anteriores';
  static const String noHayTareasPosteriores = 'No hay tareas posteriores';
}

class PreguntasConstantes {
  static const String titleApp = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  // static const String finalScoreQuestions = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de nuevo';
  static const String results = 'Resultados';
  static const String gameEnded = '¡Juego Terminado!';
  static const String excellent = '¡Excelente trabajo!';
  static const String wellDone = '¡Muy bien!';
  static const String goodJob = '¡Buen intento!';
  static const String keepTrying = '¡Sigue practicando!';
  static const String puntuacion = 'Puntuación: ';
}

class CotizacionConstantes {
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String stockPrice = 'Precio actual';
  static const String emptyList = 'No hay cotizaciones disponibles';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 12;
  static const String nombreEmpresa = 'Empresa';
  static const String errorPorcentaje = 'El porcentaje de cambio debe estar entre -100 y 100.';
  static const String errorPageSize = 'El tamaño de página debe ser mayor que 0.';
  static const String errorPageNumber = 'El número de página debe ser mayor o igual a 1.';
  static const String lastUpdated= 'Última actualización';
}

class NoticiasConstantes {
  static const String tituloApp = 'Noticias';
  // static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al obtener noticias';
  // static const String defaultCategoriaId = 'default';
  static const String editarNoticia = 'Editar Noticia';
  static const String errorNotFound = 'Noticia no encontrada';
  static const String successUpdated = 'Noticia actualizada exitosamente';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized = 'No autorizado para acceder a noticia';
  static const String errorInvalidData = 'Datos inválidos en noticia';
  static const String errorServer = 'Error del servidor en noticia';
  static const String errorCreated = 'Error al crear la noticia';
  static const String errorUpdated = 'Error al editar la noticia';
  static const String errorDelete = 'Error al eliminar la noticia';
  // static const String errorFilter = "Error al filtrar noticias";
  // static const String errorVerificarNoticiaExiste = 'Error al verificar si la noticia existe';
  static const String errorActualizarContadorReportes = 'Error al actualizar el contador de reportes';
  static const String errorActualizarContadorComentarios = 'Error al actualizar el contador de comentarios';
  static const String mensajeEliminar = '¿Estás seguro de que deseas eliminar esta noticia?';
  static const String addNoticia = 'Agregar Noticia';
  static const String successLoaded = 'Noticias cargadas correctamente';
}

class ConectividadConstantes {
  static const String mensajeSinConexion = 'Por favor, verifica tu conexión a internet.';
  // static const String mensajeReconectando = 'Intentando reconectar...';
  // static const String mensajeReconectado = 'Conexión restablecida';
  // static const int intentosReconexion = 3;
  // static const int tiempoEsperaReconexion = 5000; // milisegundos
  // static const String tituloModoOffline = 'Modo sin conexión';
  // static const String mensajeDinosaurio = 'Oh no! Parece que estás sin conexión';
}

class ValidacionConstantes {
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  static const String reintentar= 'Reintentar';
  
  static const String imagenUrl = 'URL de la imagen';
  static const String comentarioTexto = 'texto del comentario';
  static const String comentarioAutor = 'autor del comentario';
  static const String noticiaId = 'ID de la noticia';
  static const String comentarioId = 'ID del comentario';
  static const String cancelar = 'Cancelar';
  static const String eliminar = 'Eliminar';
  static const String confirmarEliminar = 'Confirmar eliminación';
  static const String seleccionadas = 'Seleccionadas: ';
  static const String limpiar = 'Limpiar';
  static const String aplicar = 'Aplicar';
  // static const String nombre = 'nombre';
  // static const String descripcion = 'descripción';
  // static const String imagen = 'imagen';
  // static const String url = 'URL';
  // static const String titulo = 'título';
  // static const String fecha = 'La fecha';
  static const String email = 'email del usuario';
  // static const String precio = 'precio';
  // static const String cantidad = 'cantidad';
  static const String idCampo = 'ID';
  static const String textoUser= 'Usuario';
  
  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
  static const String tituloTarea = 'El título de la tarea';
  static const String inicioApp = 'Aplicación Kgaona';
}

class PreferenciaConstantes {
  static const String titleApp = 'Mis Preferencias';
  static const String mensajeError = 'Error al obtener preferencia';
  // static const String mensajeCargando = 'Cargando preferencias...';
  // static const String listaVacia = 'No hay preferencias disponibles';
  // static const String errorNoPreferencia = 'Preferencia no encontrada';
  // static const String successUpdated = 'Preferencia actualizada exitosamente';
  static const String errorUpdated = 'Error al guardar preferencias';
  // static const String successCreated = 'Preferencia creada exitosamente';
  static const String errorCreated = 'Error al crear la preferencia';
  static const String errorServer = 'Error del servidor en preferencia';
  static const String errorUnauthorized = 'No autorizado para acceder a preferencia';
  static const String errorInvalidData = 'Datos inválidos en preferencia';
  static const String errorNotFound = 'Preferencia no encontrada';
  static const String errorInit = 'Error al inicializar preferencias';
  static const String preferenciasSaved = 'Preferencias guardadas correctamente';
  static const String noCategoria = 'No hay categorías disponibles en este momento';
  static const String errorNoFiltro = 'No se pueden aplicar los filtros debido a un error';
  static const String preferenciaInvalida = 'Preferencias inválidas';
}

class AuthConstantes {
  // static const String mensajeCargando = 'Cargando autenticación...';
  static const String errorLogin = 'Error al iniciar sesión';
  // static const String errorLogout = 'Error al cerrar sesión';
  // static const String errorUnauthorized = 'No autorizado para acceder a autenticación';
  // static const String errorInvalidCredentials = 'Credenciales inválidas';
  static const String errorServer = 'Error del servidor en autenticación';
  // static const String successLogin = 'Inicio de sesión exitoso';
  // static const String successLogout = 'Cierre de sesión exitoso';
  static const String errorVacio = 'Usuario o contraseña no pueden estar vacíos';
  static const String sessionToken = 'session_token';
}