import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1E3A8A), // Deep blue (trust, professionalism)
  onPrimary: Color(0xFFFFFFFF), // White for text/icons on primary
  primaryContainer: Color(0xFF3B5998), // Slightly muted blue
  onPrimaryContainer: Color(0xFFD1D5DB), // Light gray for contrast
  secondary: Color(0xFFF97316), // Orange (alerts, CTAs)
  onSecondary: Color(0xFFFFFFFF), // White for text/icons on secondary
  secondaryContainer: Color(0xFFFFA726), // Brighter orange for emphasis
  onSecondaryContainer: Color(0xFF5A3410), // Darker orange for contrast
  tertiary: Color(0xFFFACC15), // Yellow (road safety)
  onTertiary: Color(0xFF333333), // Dark for contrast
  tertiaryContainer: Color(0xFFFFF4B5), // Lighter yellow for highlights
  onTertiaryContainer: Color(0xFF5A4A1F), // Dark yellow-brown for readability
  error: Color(0xFFDC2626), // Red (warnings, errors)
  errorContainer: Color(0xFFFFE5E5), // Soft red background for errors
  onError: Color(0xFFFFFFFF), // White text/icons on error
  onErrorContainer: Color(0xFF7A1818), // Dark red text on background
  surface: Color(0xFFF3F4F6), // Light gray for UI background
  onSurface: Color(0xFF1E293B), // Dark blue-gray for text
  outline: Color(0xFF94A3B8), // Muted blue-gray for dividers
  shadow: Color(0xFF000000), // Standard shadow
  inverseSurface: Color(0xFF1E293B), // Dark mode surface
  onInverseSurface: Color(0xFFE5E7EB), // Light text on dark mode
  surfaceTint: Color(0xFF1E3A8A), // Primary blue tint
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF93C5FD), // Lighter blue for readability
  onPrimary: Color(0xFF1E293B), // Dark for contrast
  primaryContainer: Color(0xFF3B82F6), // Vibrant blue for highlights
  onPrimaryContainer: Color(0xFFD1D5DB), // Light gray for contrast
  secondary: Color(0xFFFFA726), // Bright orange for visibility
  onSecondary: Color(0xFF3B2A15), // Dark brown for contrast
  secondaryContainer: Color(0xFFF97316), // Deep orange for CTAs
  onSecondaryContainer: Color(0xFFFFE5C4), // Soft orange for readability
  tertiary: Color(0xFFFACC15), // Bright yellow for road safety
  onTertiary: Color(0xFF4D4D1F), // Dark yellow-brown for contrast
  tertiaryContainer: Color(0xFFFFF4B5), // Soft yellow for highlights
  onTertiaryContainer: Color(0xFF33330F), // Dark for readability
  error: Color(0xFFEF4444), // Softer red for dark mode errors
  errorContainer: Color(0xFF7A1818), // Dark red for background
  onError: Color(0xFFFFE5E5), // Light red text/icons on error
  onErrorContainer: Color(0xFFDC2626), // Brighter red for emphasis
  surface: Color(0xFF1E293B), // Dark blue-gray for UI
  onSurface: Color(0xFFE5E7EB), // Light text on dark UI
  outline: Color(0xFF94A3B8), // Soft blue-gray for dividers
  shadow: Color(0xFF000000), // Standard shadow
  inverseSurface: Color(0xFFE5E7EB), // Light gray background in dark mode
  onInverseSurface: Color(0xFF1E293B), // Dark text/icons on light mode
  surfaceTint: Color(0xFF93C5FD), // Primary tint
);
