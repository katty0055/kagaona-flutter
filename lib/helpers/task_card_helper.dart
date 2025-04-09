import 'package:flutter/material.dart';
import 'package:kgaona/constants.dart';
import '../domain/task.dart';
import '../components/task_card.dart'; // Importa el diseño del Card

Widget buildTaskCard(Task task, VoidCallback onEdit,  {String? subtitulo}) {
  // Lógica para determinar el ícono dinámico
  final Widget leadingIcon = Icon(
    task.type == 'normal' ? Icons.task : Icons.warning,
    color: task.type == 'normal' ? Colors.blue : Colors.red,
    size: 32,
  );

  return TaskCard(
    title: task.title,
    subtitle: subtitulo,
    leadingIcon: leadingIcon, // Pasa el ícono dinámico al Card
    type: task.type,
    description: task.description,
    date: task.date,
    trailing: IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: onEdit, // Llama al callback para editar
    ),
  );
}


Widget construirTarjetaDeportiva(Task tarea, int indice, VoidCallback onEdit) {
   final String imageUrl = 'https://picsum.photos/200/300?random=$indice';
   final String fechaLimite = tarea.fechaLimite != null
       ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
       : 'Sin fecha límite';
 
   return Card(
     elevation: 8, // Borde sombreado
     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10), // Borde redondeado
     ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         // Imagen aleatoria
         ClipRRect(
           borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
           child: Image.network(
             imageUrl,
             height: 150,
             width: double.infinity,
             fit: BoxFit.cover,
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Título
               Text(
                 tarea.title,
                 style: const TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               const SizedBox(height: 8),
               // Pasos (máximo 3 líneas)
               if (tarea.pasos != null && tarea.pasos!.isNotEmpty)
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: tarea.pasos!
                       .take(3) // Toma un máximo de 3 pasos
                       .map((paso) => Text(
                             paso,
                             style: const TextStyle(fontSize: 14, color: Colors.black54),
                           ))
                       .toList(),
                 )
               else
                 const Text(
                   'No hay pasos disponibles',
                   style: TextStyle(fontSize: 14, color: Colors.black54),
                 ),
               const SizedBox(height: 8),                           
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$FECHA_LIMITE $fechaLimite',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  //Use para visualizar el tipo de tarea y corregir el problema de editar
                  // Text(
                  //   tarea.type,
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ), 
                  IconButton(
                    onPressed: onEdit, // Llama a la función de edición
                    icon: const Icon(Icons.edit, size: 16),
                    style: ElevatedButton.styleFrom(                     
                      foregroundColor: Colors.grey, // Color del texto
                    ),
                  ),
                ],
              ),
             ],
           ),
         ),
       ],
     ),
   );
 }
