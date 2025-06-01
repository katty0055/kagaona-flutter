import 'package:flutter/material.dart';
import 'package:kgaona/domain/tarea.dart';
import 'package:kgaona/theme/theme.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Tarea) onTaskAdded;
  final Tarea? taskToEdit; // Tarea opcional para editar

  const AddTaskModal({super.key, required this.onTaskAdded, this.taskToEdit});

  @override
  AddTaskModalState createState() => AddTaskModalState();
}

class AddTaskModalState extends State<AddTaskModal> {
  late TextEditingController tituloController;
  late TextEditingController descripcionController;
  late TextEditingController fechaController;
  late TextEditingController fechaLimiteController;
  DateTime? fechaSeleccionada;
  DateTime? fechaLimiteSeleccionada;
  late List<String> pasos;
  late String tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos de la tarea a editar (si existe)
    tituloController = TextEditingController(text: widget.taskToEdit?.titulo ?? '');
    descripcionController = TextEditingController(text: widget.taskToEdit?.descripcion ?? '');
    fechaSeleccionada = widget.taskToEdit?.fecha;
    fechaController = TextEditingController(
      text: fechaSeleccionada != null
          ? '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'
          : '',
    );

    fechaLimiteSeleccionada = widget.taskToEdit?.fechaLimite;
    fechaLimiteController = TextEditingController(
      text: fechaLimiteSeleccionada != null
          ? '${fechaLimiteSeleccionada!.day}/${fechaLimiteSeleccionada!.month}/${fechaLimiteSeleccionada!.year}'
          : '',
    );
    tipoSeleccionado = widget.taskToEdit?.tipo ?? 'normal';
  }

  void _guardarTarea() {
    final titulo = tituloController.text.trim();
    final descripcion = descripcionController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el título de la tarea')),
      );
      return;
    }

    // Crear o actualizar la tarea
    final tarea = Tarea(
      id: widget.taskToEdit?.id,
      usuario: widget.taskToEdit?.usuario ?? '',
      titulo: titulo,
      tipo: tipoSeleccionado,
      descripcion: descripcion.isEmpty ? null : descripcion,
      fecha: fechaSeleccionada ?? DateTime.now(),
      fechaLimite: fechaLimiteSeleccionada,
    );

    Navigator.of(context).pop(); // Primero cerramos el modal
    widget.onTaskAdded(tarea); // Luego llamamos al callback
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                // No es necesario definir el border aquí, ya se aplica el tema
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              maxLines: 3, // Permitir múltiples líneas para la descripción
              decoration: const InputDecoration(
                labelText: 'Descripción',
                // El tema se aplica automáticamente
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                suffixIcon: Icon(Icons.calendar_today), // Icono para indicar selección
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
            const SizedBox(height: 16),
            TextField(
              controller: fechaLimiteController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha Límite',
                suffixIcon: Icon(Icons.calendar_today),
                hintText: 'Seleccionar Fecha Límite',
              ),
              onTap: () async {
                DateTime? nuevaFechaLimite = await showDatePicker(
                  context: context,
                  initialDate: fechaLimiteSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (nuevaFechaLimite != null) {
                  setState(() {
                    fechaLimiteSeleccionada = nuevaFechaLimite;
                    fechaLimiteController.text =
                        '${nuevaFechaLimite.day}/${nuevaFechaLimite.month}/${nuevaFechaLimite.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de Tarea',
                // Tema aplicado automáticamente
              ),
              items: [
                DropdownMenuItem(
                  value: 'normal',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text('Normal'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'urgente',
                  child: Row(
                    children: [
                      Icon(Icons.priority_high, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text('Urgente', style: TextStyle(color: theme.colorScheme.error)),
                    ],
                  ),
                ),
              ],
              onChanged: (String? nuevoValor) {
                setState(() {
                  tipoSeleccionado = nuevoValor!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: AppTheme.modalSecondaryButtonStyle(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarTarea,
          style: AppTheme.modalActionButtonStyle(),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}