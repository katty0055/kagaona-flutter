import 'package:flutter/material.dart';
import 'package:kgaona/components/responsive_container.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/helpers/common_widgets_helper.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de Sodep')),
      drawer: const SideMenu(),

      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Column(
            children: [
              CommonWidgetsHelper.paddingContainer32(
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    CommonWidgetsHelper.sodepLogo(),
                    CommonWidgetsHelper.buildSpacing32(),
                    CommonWidgetsHelper.textoPrincipal(
                      context,
                      text:
                          'Somos una empresa formada por profesionales en el área de TIC con amplia experiencia en diferentes lenguajes y la capacidad de adaptarnos a la herramienta que mejor sirva para solucionar el problema.',
                    ),
                  ],
                ),
              ),

              CommonWidgetsHelper.paddingContainerHorizontal32(
                color: theme.colorScheme.surface,
                children: [
                  CommonWidgetsHelper.seccionSubTitulo(title: 'Valores'),
                  CommonWidgetsHelper.buildSpacing16(),
                  CommonWidgetsHelper.seccionValoresSodep(
                    icon: Icons.handshake_outlined,
                    title: 'Honestidad',
                  ),
                  CommonWidgetsHelper.buildSpacing16(),
                  CommonWidgetsHelper.seccionValoresSodep(
                    icon: Icons.forum_outlined,
                    title: 'Comunicación',
                  ),
                  CommonWidgetsHelper.buildSpacing16(),
                  CommonWidgetsHelper.seccionValoresSodep(
                    icon: Icons.settings_outlined,
                    title: 'Autogestión',
                  ),
                  CommonWidgetsHelper.buildSpacing16(),
                  CommonWidgetsHelper.seccionValoresSodep(
                    icon: Icons.cyclone_outlined,
                    title: 'Flexibilidad',
                  ),
                  CommonWidgetsHelper.buildSpacing16(),
                  CommonWidgetsHelper.seccionValoresSodep(
                    icon: Icons.verified_outlined,
                    title: 'Calidad',
                  ),
                  CommonWidgetsHelper.buildSpacing32(),
                  CommonWidgetsHelper.seccionSubTitulo(
                    title: 'Más Información',
                  ),
                  CommonWidgetsHelper.buildSpacing32(),
                  CommonWidgetsHelper.seccionInfo(
                    icon: Icons.location_on,
                    text: 'Bélgica 839 c/ Eusebio Lillo, Asunción, Paraguay',
                  ),
                  CommonWidgetsHelper.buildSpacing32(),
                  CommonWidgetsHelper.seccionInfo(
                    icon: Icons.phone,
                    text: 'Tel:(+595)981-131-694',
                  ),
                  CommonWidgetsHelper.buildSpacing32(),
                  CommonWidgetsHelper.seccionInfo(
                    icon: Icons.email,
                    text: 'info@sodep.com.py',
                  ),
                  CommonWidgetsHelper.buildSpacing32(),
                        CommonWidgetsHelper.copyrightFooter(context),
                        CommonWidgetsHelper.buildSpacing32(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
