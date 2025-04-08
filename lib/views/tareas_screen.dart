import 'package:flutter/material.dart';
import 'package:kgaona/api/service/tareas_service.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:kgaona/views/welcome_screen.dart';
import '../domain/task.dart';
import 'package:kgaona/helpers/task_card_helper.dart';
import '../components/add_task_modal.dart'; // Importa el modal reutilizable

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TareasService _tareasService = TareasService();
  final ScrollController _scrollController = ScrollController();
  bool _cargando = false;
  bool _hayMasTareas = true;
  int _paginaActual = 0;
  final int _limitePorPagina = 10;
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  List<Task> _tareas = []; // Lista persistente de tareas

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1: // Añadir Tarea
        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarTareas(); // Carga inicial de tareas
    _scrollController.addListener(_detectarScrollFinal);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarTareas() async {
    if (_cargando || !_hayMasTareas) return;

    setState(() {
      _cargando = true;
    });

    // Llama al servicio para obtener nuevas tareas
    final nuevasTareas = await _tareasService.obtenerTareas(
      inicio: _paginaActual * _limitePorPagina,
      limite: _limitePorPagina,
    );

    setState(() {
      if (nuevasTareas.isNotEmpty) {
        _tareas.addAll(nuevasTareas); // Agrega las nuevas tareas a la lista existente
        _paginaActual++; // Incrementa la página actual para la siguiente carga
      }
      _cargando = false;
      _hayMasTareas = nuevasTareas.length == _limitePorPagina; // Verifica si hay más tareas
    });
  }

  void _detectarScrollFinal() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !_cargando) {
      _cargarTareas();
    }
  }

  void _mostrarModalAgregarTarea() {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        onTaskAdded: (Task nuevaTarea) async {
          await _tareasService.agregarTarea(nuevaTarea); // El servicio define el tipo
          setState(() {
            _tareas.insert(0, nuevaTarea); // Agrega la nueva tarea al inicio de la lista
          });
        },
      ),
    );
  }

  Future<void> _eliminarTarea(int index) async {
    await _tareasService.eliminarTarea(index);
    setState(() {
      _tareas.removeAt(index); // Elimina la tarea de la lista persistente
    });
  }

  void _mostrarModalEditarTarea(Task tarea, int index) {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        taskToEdit: tarea,
        onTaskAdded: (Task tareaEditada) async {
          await _tareasService.actualizarTarea(index, tareaEditada);
          setState(() {
            _tareas[index] = tareaEditada; // Actualiza la tarea en la lista persistente
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TITLE_APPBAR)),
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _tareas.length + (_cargando ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _tareas.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final tarea = _tareas[index];
          return Dismissible(
            key: Key(tarea.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _eliminarTarea(index);
            },
            child: buildTaskCard(
              tarea,
              () {
                _mostrarModalEditarTarea(tarea, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarModalAgregarTarea,
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}
