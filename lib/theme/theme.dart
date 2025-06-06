import 'package:flutter/material.dart';
import 'package:kgaona/theme/colors.dart';
import 'package:kgaona/theme/text.style.dart';

class AppTheme {
  // Estilo para barras de progreso
  static ProgressIndicatorThemeData progressIndicatorTheme() {
    return const ProgressIndicatorThemeData(
      color: AppColors.primaryLightBlue,
      linearTrackColor: Colors.transparent,
      linearMinHeight: 16.0,
      refreshBackgroundColor: AppColors.gray05,
      circularTrackColor: Colors.transparent,
    );
  }
  
  // Estilo personalizado para barras de progreso con borde
  static BoxDecoration progressBarDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: AppColors.gray14.withAlpha(77),
        width: 1.0,
      ),
    );
  }
  
  static ThemeData bootcampTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    disabledColor: AppColors.neutralGray,
    //Barra de navegación
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDarkBlue,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.gray01,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
    // Configuración de ListTile (para elementos del menú)
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.gray01,
      textColor: AppColors.gray01,
      titleTextStyle: AppTextStyles.bodyMdMedium.copyWith(color: AppColors.gray01),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.blue02.withAlpha(77),
      selectedColor: AppColors.gray01,
    ),
    
    // Configuración para el DrawerHeader (para eliminar la barra horizontal)
    dividerTheme: const DividerThemeData(
      color: Colors.transparent, // Hace invisible el divisor
      space: 0, // Minimiza el espacio del divisor
      thickness: 0, // Sin grosor
    ),

    //botones de radio y checkbox
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray05;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryActive;
        } else if (states.contains(WidgetState.hovered)) {
          return AppColors.primaryHover;
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.primary;
        }
        return AppColors.gray05;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray01;
      }),
      side: const BorderSide(color: AppColors.gray05),
    ),
    //cards
    cardTheme: CardTheme(
      color: AppColors.gray01,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.gray05),
      ),
    ),
    //botones
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.gray01,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.gray08,
        textStyle: AppTextStyles.bodyLgMedium.copyWith(color: AppColors.gray01),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), // Esto quita completamente el redondeo
        ),
      ),
    ),
    //pestañas
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: AppTextStyles.bodyLgSemiBold,
      unselectedLabelStyle: AppTextStyles.bodyLg,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.gray14,
      indicator: const BoxDecoration(
        color: AppColors.blue02,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    //botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppTextStyles.bodyLgMedium.copyWith(
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    //texto
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.heading3xl,
      displayMedium: AppTextStyles.heading2xl,
      displaySmall: AppTextStyles.headingXl,

      // Headline styles
      headlineLarge: AppTextStyles.headingLg,
      headlineMedium: AppTextStyles.headingMd,
      headlineSmall: AppTextStyles.headingSm,

      // Body styles
      bodyLarge: AppTextStyles.bodyLg,
      bodyMedium: AppTextStyles.bodyMd,
      bodySmall: AppTextStyles.bodySm,

      // Subtitle styles
      titleLarge: AppTextStyles.bodyLgMedium,
      titleMedium: AppTextStyles.bodyMdMedium,
      titleSmall: AppTextStyles.bodyXs,

      // Label styles (button text, etc.)
      labelLarge: AppTextStyles.bodyLgSemiBold,
      labelMedium: AppTextStyles.bodyMdSemiBold,
      labelSmall: AppTextStyles.bodyXsSemiBold,
    ),


    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDarkBlue, 
      secondary: AppColors.primaryLightBlue,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: AppColors.gray01,
      onSecondary: AppColors.success,
      onError: AppColors.warning,      
    ),
    // Configuración para inputs de formularios
    inputDecorationTheme: InputDecorationTheme(
      // Colores y relleno
      filled: true,
      fillColor: AppColors.gray01,
      
      // Espaciado interno
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      
      // Bordes
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.gray05),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.gray05),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      
      // Estilos de texto
      labelStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.gray14),
      floatingLabelStyle: AppTextStyles.bodyMdMedium.copyWith(color: AppColors.primary),
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.gray08),
      errorStyle: AppTextStyles.bodySm.copyWith(color: AppColors.error),
  
      
      // Otras propiedades
      isDense: false,
      isCollapsed: false,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
    ),
    // Agregar tema de diálogo
    dialogTheme: dialogTheme(),
  );
  
  // Estilo para iconos con fondo pequeño
  static BoxDecoration iconDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withAlpha(51),
      borderRadius: BorderRadius.circular(10),
    );
  }
  
  // Estilo para iconos sin fondo pequeños 
  static IconThemeData infoIconTheme(BuildContext context) {
    return IconThemeData(
      color: Theme.of(context).colorScheme.primary,
      size: 24,
    );
  }

  // Estilo para copyright
  static Color copyrightColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(51);
  }

  // Estilo para tarjetas con imágenes
  static CardTheme imageCardTheme() {
    return CardTheme(
      color: AppColors.gray01,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.gray05, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // Importante para imágenes que pueden sobrepasar bordes
    );
  }
  
  // Decoración para contenedor de imagen en tarjetas
  static BoxDecoration imageContainerDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      border: Border.all(
        color: AppColors.gray05.withAlpha(127),
        width: 0.5,
      ),
    );
  }
  
  // Estilo para botones de acción en tarjetas
  static ButtonStyle cardActionButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.gray01,
      textStyle: AppTextStyles.bodyLgMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: const Size(44, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  
  // Estilo para contenido de tarjetas con padding consistente
  static EdgeInsets cardContentPadding() {
    return const EdgeInsets.all(16);
  }

  // Estilo para diálogos y modales
  static DialogTheme dialogTheme() {
    return DialogTheme(
      backgroundColor: AppColors.gray01,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: AppTextStyles.headingMd.copyWith(
        color: AppColors.gray14, 
        fontWeight: FontWeight.bold
      ),
      contentTextStyle: AppTextStyles.bodyMd.copyWith(
        color: AppColors.gray14
      ),
    );
  }
  
  // Espaciado estándar para formularios
  static const EdgeInsets formFieldSpacing = EdgeInsets.symmetric(vertical: 16);
  
  // Estilo para botones de acción en modales
  static ButtonStyle modalActionButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.gray01,
      textStyle: AppTextStyles.bodyMdSemiBold,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  
  // Estilo para botones secundarios en modales
  static ButtonStyle modalSecondaryButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.gray14,
      textStyle: AppTextStyles.bodyMdSemiBold,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}


