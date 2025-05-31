import 'package:flutter/material.dart';
import 'package:kgaona/theme/colors.dart';
import 'package:kgaona/theme/text.style.dart';

class AppTheme {
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
        borderRadius: BorderRadius.all(Radius.circular(80)),
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
      onSecondary: AppColors.gray01,
      onError: AppColors.gray01,
    ),
  );
  //decoraciones reutilizables
  static final BoxDecoration sectionBorderGray05 = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: AppColors.gray05),
    color: Colors.white, // Fondo blanco
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(51), // Sombra suave
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
  // Añadir más decoraciones
  static final BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: AppColors.gray01,
    border: Border.all(color: AppColors.gray05),
  );

  static BoxDecoration valueIconDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withAlpha(51),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static final BoxDecoration surfaceContainer = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(8),
  );

  // Colores semitransparentes comunes
  static Color withEmphasis(Color color, {double alpha = 0.2}) {
    return color.withAlpha((alpha * 255).toInt());
  }
  
  // Estilo para iconos de valores
  static IconThemeData valueIconTheme(BuildContext context) {
    return IconThemeData(
      color: Theme.of(context).colorScheme.primary,
      size: 24,
    );
  }
  
  // Estilo para iconos de información
  static IconThemeData infoIconTheme(BuildContext context) {
    return IconThemeData(
      color: Theme.of(context).colorScheme.primary,
      size: 20,
    );
  }

  // Estilo para copyright
  static Color copyrightColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(51);
  }

  // Constantes de espaciado
  static const spacing = _Spacing();
  static const EdgeInsets contentPadding = EdgeInsets.all(32);
  static const EdgeInsets contentPaddingHorizontal = EdgeInsets.symmetric(horizontal: 32);
  static const EdgeInsets itemSpacing = EdgeInsets.symmetric(vertical: 8);
}

// Clase separada para espaciado
class _Spacing {
  const _Spacing();
  final double xs = 4;
  final double sm = 8;
  final double md = 16;
  final double lg = 24;
  final double xl = 32;
  final double xxl = 48;
}
