import 'package:flutter/material.dart';
import '../domain/task.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final Task? taskToEdit; // Tarea opcional para editar

  const AddTaskModal({super.key, required this.onTaskAdded, this.taskToEdit});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  late TextEditingController tituloController;
  late TextEditingController descripcionController;
  late TextEditingController fechaController;
  DateTime? fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos de la tarea a editar (si existe)
    tituloController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    descripcionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    fechaSeleccionada = widget.taskToEdit?.date;
    fechaController = TextEditingController(
      text: fechaSeleccionada != null
          ? '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'
          : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taskToEdit == null ? 'Agregar Tarea' : 'Editar Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                hintText: 'Seleccionar Fecha',
              ),
              onTap: () async {
                DateTime? nuevaFecha = await showDatePicker(
                  context: context,
                  initialDate: fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (nuevaFecha != null) {
                  setState(() {
                    fechaSeleccionada = nuevaFecha;
                    fechaController.text =
                        '${nuevaFecha.day}/${nuevaFecha.month}/${nuevaFecha.year}';
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final titulo = tituloController.text.trim();
            final descripcion = descripcionController.text.trim();
            // final type = 
            if (titulo.isEmpty || descripcion.isEmpty || fechaSeleccionada == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, completa todos los campos')),
              );
              return;
            }

            // Crear la tarea sin el campo 'type'
            final nuevaTarea = Task(
              title: titulo,
              description: descripcion,
              date: fechaSeleccionada,
            );

            widget.onTaskAdded(nuevaTarea); // Llama al callback para agregar la tarea
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}