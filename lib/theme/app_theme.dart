import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color gradientStart =
      Color(0xFF035B71); // teal gelap (kiri atas)
  static const Color gradientEnd =
      Color(0xFF06ADD7); // cyan terang (kanan bawah)

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const Color logoAda = Color(0xFF06CFE8);
  static const Color logoTamu = Color(0xFFFDFF44);
  static const Color logoIcon = Color(0xFF09CFEA);
  static const Color welcomeText = Color(0xFFFDFB44);
  static const Color buttonDashboardBackground = Color(0xFFFFFFFF);
  static const Color buttonFormBackground = Color(0xFFFCFF55);
  static const Color buttonText = Color(0xFF1A1A1A);

  static const Color formBackground = Color(0xFFEDEDED);
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color inputFillFocused = Color(0xFFB2EAFC);
  static const Color inputBorderFocused = Color(0xFF18B6D6);
  static const Color labelText = Color(0xFF1A1A1A);
}

class AppTextStyles {
  AppTextStyles._();

  static String get fontFamily => GoogleFonts.poppins().fontFamily!;

  static TextStyle get welcomeTitle => GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.welcomeText,
      );

  static TextStyle get logoAdaText => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.logoAda,
      );

  static TextStyle get logoTamuText => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.logoTamu,
      );

  static TextStyle get fieldLabel => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.labelText,
      );

  static TextStyle get buttonLabel => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.buttonText,
      );
}
