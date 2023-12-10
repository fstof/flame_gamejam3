import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const paddingS = 4.0;
const paddingM = 8.0;
const paddingL = 16.0;

const spaceS = SizedBox.square(dimension: paddingS);
const spaceM = SizedBox.square(dimension: paddingM);
const spaceL = SizedBox.square(dimension: paddingL);

const edgeAllS = EdgeInsets.all(paddingS);
const edgeAllM = EdgeInsets.all(paddingM);
const edgeAllL = EdgeInsets.all(paddingL);

const edgeHS = EdgeInsets.symmetric(horizontal: paddingS);
const edgeHM = EdgeInsets.symmetric(horizontal: paddingM);
const edgeHL = EdgeInsets.symmetric(horizontal: paddingL);

const edgeVS = EdgeInsets.symmetric(vertical: paddingS);
const edgeVL = EdgeInsets.symmetric(vertical: paddingL);
const edgeVM = EdgeInsets.symmetric(vertical: paddingM);

// final theme = ThemeData.from(colorScheme: colorScheme);
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: GoogleFonts.icebergTextTheme(),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006686),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC0E8FF),
  onPrimaryContainer: Color(0xFF001E2B),
  secondary: Color(0xFF006E1D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF76FE7B),
  onSecondaryContainer: Color(0xFF002204),
  tertiary: Color(0xFFB90063),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD9E2),
  onTertiaryContainer: Color(0xFF3E001D),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF001849),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF001849),
  surfaceVariant: Color(0xFFDCE3E9),
  onSurfaceVariant: Color(0xFF40484C),
  outline: Color(0xFF71787D),
  onInverseSurface: Color(0xFFEEF0FF),
  inverseSurface: Color(0xFF002B75),
  inversePrimary: Color(0xFF71D2FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006686),
  outlineVariant: Color(0xFFC0C7CD),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF71D2FF),
  onPrimary: Color(0xFF003547),
  primaryContainer: Color(0xFF004D66),
  onPrimaryContainer: Color(0xFFC0E8FF),
  secondary: Color(0xFF58E162),
  onSecondary: Color(0xFF00390B),
  secondaryContainer: Color(0xFF005313),
  onSecondaryContainer: Color(0xFF76FE7B),
  tertiary: Color(0xFFFFB1C8),
  onTertiary: Color(0xFF650033),
  tertiaryContainer: Color(0xFF8E004A),
  onTertiaryContainer: Color(0xFFFFD9E2),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF001849),
  onBackground: Color(0xFFDBE1FF),
  surface: Color(0xFF001849),
  onSurface: Color(0xFFDBE1FF),
  surfaceVariant: Color(0xFF40484C),
  onSurfaceVariant: Color(0xFFC0C7CD),
  outline: Color(0xFF8A9297),
  onInverseSurface: Color(0xFF001849),
  inverseSurface: Color(0xFFDBE1FF),
  inversePrimary: Color(0xFF006686),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF71D2FF),
  outlineVariant: Color(0xFF40484C),
  scrim: Color(0xFF000000),
);
