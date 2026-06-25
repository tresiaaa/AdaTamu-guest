import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semua warna & gaya visual aplikasi AdaTamu dikumpulkan di sini
/// supaya konsisten di setiap halaman dan mudah diubah dari satu tempat.
class AppColors {
  AppColors._();

  // Warna gradient utama (dashboard & header form), dikalibrasi dari
  // sampel piksel langsung pada gambar referensi dashboard.
  static const Color gradientStart = Color(0xFF035B71); // teal gelap (kiri atas)
  static const Color gradientEnd = Color(0xFF06ADD7); // cyan terang (kanan bawah)

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  // Warna khusus logo "AdaTamu" — JANGAN diubah, sesuai permintaan.
  // Dikalibrasi dari sampel piksel langsung pada gambar referensi.
  static const Color logoAda = Color(0xFF06CFE8); // "Ada" = cyan terang
  static const Color logoTamu = Color(0xFFFDFF44); // "Tamu" = kuning
  static const Color logoIcon = Color(0xFF09CFEA); // garis buku & petir

  // Warna teks "Selamat Datang"
  static const Color welcomeText = Color(0xFFFDFB44); // kuning terang

  // Tombol di dashboard (page 1): putih solid, sesuai gambar referensi.
  static const Color buttonDashboardBackground = Color(0xFFFFFFFF);

  // Tombol di halaman form (page 2 & 3): kuning terang, sesuai video
  // referensi ("Berikutnya" / "Simpan").
  static const Color buttonFormBackground = Color(0xFFFCFF55);

  static const Color buttonText = Color(0xFF1A1A1A);

  // Halaman form (page 2 & 3)
  static const Color formBackground = Color(0xFFEDEDED);
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color inputFillFocused = Color(0xFFB2EAFC);
  static const Color inputBorderFocused = Color(0xFF18B6D6);
  static const Color labelText = Color(0xFF1A1A1A);
}

class AppTextStyles {
  AppTextStyles._();

  /// Dipakai sebagai `fontFamily` di ThemeData (lihat main.dart).
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
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.labelText,
      );

  static TextStyle get buttonLabel => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.buttonText,
      );
}
