import 'package:flutter/material.dart';

const orange = Color(0xFFA43D00);
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2B3147), // Deep blue-gray
  onPrimary: Color(0xFFFFFFFF), // White for text/icons on primary
  primaryContainer: Color(0xFF4B556B), // Muted blue-gray
  onPrimaryContainer: Color(0xFFE4E6EB), // Light gray-blue
  secondary: Color(0xFF5A768A), // Cool blue-gray for accents
  onSecondary: Color(0xFFFFFFFF), // White for text/icons on secondary
  secondaryContainer: Color(0xFFDCE5EC), // Soft light blue-gray
  onSecondaryContainer: Color(0xFF2B3147), // Reuse primary for contrast
  tertiary: Color(0xFF718096), // Balanced neutral blue-gray
  onTertiary: Color(0xFFFFFFFF), // White for text/icons on tertiary
  tertiaryContainer: Color(0xFFBFCAD5), // Muted steel blue
  onTertiaryContainer: Color(0xFF2B3147), // Reuse primary for contrast
  error: Color(0xFFBA1A1A), // Bright red for error
  errorContainer: Color(0xFFFFDAD6), // Soft pink for error background
  onError: Color(0xFFFFFFFF), // White for text/icons on error
  onErrorContainer: Color(0xFF410002), // Dark blue-gray for text
  surface: Color(0xFFF5F7FA), // Same as background
  onSurface: Color(0xFF2B3147), // Dark blue-gray for text/icons
  surfaceContainerHighest: Color(0xFFD0D6DE), // Muted gray-blue for surfaces
  onSurfaceVariant: Color(0xFF4B556B), // Muted blue-gray for contrast
  outline: Color(0xFF718096), // Neutral line colors
  onInverseSurface: Color(0xFFECEFF4), // Light gray for inverse
  inverseSurface: Color(0xFF2B3147), // Use primary for inverse surface
  inversePrimary: Color(0xFF98A7C4), // Lightened primary for accents
  shadow: Color(0xFF000000), // Standard shadow
  surfaceTint: Color(0xFF2B3147), // Tint aligns with primary
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF98A7C4), // Lightened primary for dark theme
  onPrimary: Color(0xFF1A202E), // Darker variant for text/icons on primary
  primaryContainer: Color(0xFF4B556B), // Muted blue-gray for containers
  onPrimaryContainer: Color(0xFFDCE5EC), // Soft light for text on containers
  secondary: Color(0xFF9AB9CE), // Softened blue-gray for secondary
  onSecondary: Color(0xFF1B252D), // Dark for text/icons on secondary
  secondaryContainer: Color(0xFF4B647A), // Muted blue-gray for containers
  onSecondaryContainer: Color(0xFFCFE6F3), // Light text for secondary container
  tertiary: Color(0xFFA3B3C8), // Neutral soft blue for accents
  onTertiary: Color(0xFF1D2A38), // Darker tone for text/icons on tertiary
  tertiaryContainer: Color(0xFF4C5B6B), // Muted tone for tertiary containers
  onTertiaryContainer: Color(0xFFD9E4F0), // Soft light for tertiary text
  error: Color(0xFFFFB4AB), // Softer red for errors in dark mode
  errorContainer: Color(0xFF93000A), // Dark red for error backgrounds
  onError: Color(0xFF690005), // Deeper red for error text/icons
  onErrorContainer: Color(0xFFFFDAD6), // Light gray for text on background
  surface: Color(0xFF1B2027), // Same as background for cohesion
  onSurface: Color(0xFFECEFF4), // Light gray for text/icons on surface
  surfaceContainerHighest:
      Color(0xFF3C4751), // Muted blue-gray for subtle surfaces
  onSurfaceVariant: Color(0xFFBFC9D3), // Softer contrast for text/icons
  outline: Color(0xFF768390), // Neutral line colors for dark theme
  onInverseSurface: Color(0xFF1B2027), // Use dark background for inverse
  inverseSurface: Color(0xFFECEFF4), // Light gray for inverted surface
  inversePrimary: Color(0xFF2B3147), // Original primary as inverted color
  shadow: Color(0xFF000000), // Standard shadow
  surfaceTint: Color(0xFF98A7C4), // Tint aligns with lightened primary
);
