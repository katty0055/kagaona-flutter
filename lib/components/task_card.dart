import 'package:flutter/material.dart';
import 'package:kgaona/helpers/task_card_helper.dart';
import 'package:kgaona/domain/task.dart';
import 'package:kgaona/constants/constants.dart';

// class TaskCard extends StatelessWidget {
//   final String title;
//   final String? subtitle; // Subtítulo opcional
//   final Widget leadingIcon; // Ícono dinámico pasado desde afuera
//   final String type;  
//   final String? description;
//   final DateTime? date;
//   final Widget? trailing; // Botón o widget adicional (opcional)
  
//   const TaskCard({
//     super.key,
//     required this.title,
//     this.subtitle, // Acepta un subtítulo opcional
//     required this.leadingIcon,
//     required this.type,
//     this.description,
//     this.date,
//     this.trailing, // Acepta un widget adicional
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10), // Borde redondeado
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 leadingIcon, // Ícono dinámico pasado como parámetro
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       if (subtitle != null) // Muestra el subtítulo si está definido
//                         Text(
//                           subtitle!,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black54,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 if (trailing != null) trailing!, // Muestra el botón si está definido
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               type,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               description ?? 'Sin descripción',
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Fecha: ${date != null ? "${date!.day}/${date!.month}/${date!.year}" : 'Sin fecha'}',
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TaskCard extends StatelessWidget {
  final Task tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Borde sombreado
      color: Colors.white, // Color de fondo blanco
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Agrega un padding de 10 alrededor del Card
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                CommonWidgetsHelper.buildBoldTitle(tarea.title),
                CommonWidgetsHelper.buildSpacing(), // Espacio entre el título y la descripción
                // Pasos (máximo 3 líneas)
                if (tarea.pasos != null && tarea.pasos!.isNotEmpty)
                  CommonWidgetsHelper.buildInfoLines(
                    tarea.pasos![0],
                    tarea.pasos!.length > 1 ? tarea.pasos![1] : null,
                    tarea.pasos!.length > 2 ? tarea.pasos![2] : null,
                  )
                else
                  CommonWidgetsHelper.buildNoStepsText(),
                CommonWidgetsHelper.buildSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea el botón a la derecha
                  children: [
                    CommonWidgetsHelper.buildBoldFooter('$Constants.fechaLimite $fechaLimiteDato'),
                    ElevatedButton.icon(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}