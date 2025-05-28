import 'package:flutter/material.dart';
import 'package:kgaona/components/responsive_container.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/helpers/responsive_helper.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de Sodep'),
      ),
      drawer: !isDesktop ? const SideMenu() : null,
    
      
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: const EdgeInsets.all(32),
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo_sodep.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Somos una empresa formada por profesionales en el área de TIC con amplia experiencia en diferentes lenguajes y la capacidad de adaptarnos a la herramienta que mejor sirva para solucionar el problema.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify, // Cambiado de center a justify
                    ),
                  ],
                ),
              ),
              
              // Valores Section
              _buildSection(
                title: 'Valores',
                content: Column(
                  children: [
                    _buildValueItem(
                      icon: Icons.handshake_outlined, // Icono de apretón de manos
                      title: 'Honestidad',                     
                    ),
                    _buildValueItem(
                      icon: Icons.forum_outlined, // Icono de comunicación
                      title: 'Comunicación',                      
                    ),
                    _buildValueItem(
                      icon: Icons.settings_outlined, // Icono de engranaje
                      title: 'Autogestión',                     
                    ),
                    _buildValueItem(
                      icon: Icons.cyclone_outlined, // Icono de flexibilidad
                      title: 'Flexibilidad',  
                    ),
                    _buildValueItem(
                      icon: Icons.verified_outlined, // Icono de calidad
                      title: 'Calidad',                      
                    ),
                  ],
                ),
              ),

              // Más Información Section
              _buildSection(
                title: 'Más Información',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem(
                      icon: Icons.location_on,
                      text: 'Bélgica 839 c/ Eusebio Lillo, Asunción, Paraguay',
                    ),
                    _buildInfoItem(
                      icon: Icons.phone,
                      text: 'Tel:(+595)981-131-694',
                    ),
                    _buildInfoItem(
                      icon: Icons.email,
                      text: 'info@sodep.com.py',
                    ),
                    const SizedBox(height: 48), // Reducido de 48 a 24
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copyright_rounded,
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2025 SODEP S.A.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Software Development & Products',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32), // Reducido de 48 a 24
                  ],
                ),
              ),             
            ],
          ),
        ),
      ),
    );
  }

  // Actualiza el método _buildSection para quitar el aspecto de card
  Widget _buildSection({required String title, required Widget content}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reducido de 16 a 8 en vertical
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: theme.textTheme.headlineLarge, // Usando el tema en lugar de AppTextStyles directamente
              ),
              const SizedBox(height: 24),
              DefaultTextStyle(
                style: theme.textTheme.bodyMedium ?? const TextStyle(), // Estilo por defecto para el contenido
                child: content,
              ),
            ],
          ),
        );
      },
    );
  }

  // Actualiza la sección de valores con los iconos apropiados
  Widget _buildValueItem({
    required IconData icon,
    required String title,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Cambiado a center
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon, 
                  color: theme.colorScheme.primary, 
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title, 
                  style: theme.textTheme.titleMedium, // Usando el tema
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: theme.textTheme.titleMedium,),
              ),
            ],
          ),
        );
      },
    );
  }

}