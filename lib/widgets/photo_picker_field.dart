import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

/// Field untuk mengambil foto tamu, dari kamera ATAU galeri.
///
/// Gaya visual konsisten dengan [GuestTextField] & [GuestDropdownField]:
/// label di atas, kotak putih bulat, border merah + pesan error saat
/// belum diisi padahal wajib.
///
/// CATATAN: widget ini baru menangani pengambilan & preview foto secara
/// LOKAL (di memori device, lewat package image_picker). Upload foto ke
/// Firebase Storage belum dilakukan di sini — itu menyusul nanti saat
/// tahap "sambung ke database" (lihat TODO di guest_form_page3.dart).
class PhotoPickerField extends StatefulWidget {
  final File? value;
  final ValueChanged<File?> onChanged;

  const PhotoPickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<PhotoPickerField> createState() => PhotoPickerFieldState();
}

class PhotoPickerFieldState extends State<PhotoPickerField> {
  String? _errorText;
  final ImagePicker _picker = ImagePicker();

  /// Dipanggil dari luar (page3) saat tombol "Simpan" ditekan, supaya
  /// validasinya konsisten dengan field lain. Mengembalikan true jika
  /// valid (foto sudah diambil).
  bool validate() {
    if (widget.value == null) {
      setState(() => _errorText = 'Wajib ambil gambar');
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  void _clearError() {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  Future<void> _pickFrom(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1280,
      );
      if (picked == null) return;

      _clearError();
      widget.onChanged(File(picked.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil foto: $e')),
      );
    }
  }

  // image_picker TIDAK mendukung ImageSource.camera di Windows desktop
  // (cuma Android & iOS). Supaya tidak crash, opsi "Kamera" disembunyikan
  // di Windows — tamu yang pakai app di komputer cukup pilih dari Galeri.
  bool get _isCameraSupported => !kIsWeb && !Platform.isWindows;

  Future<void> _showSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  'Ambil Foto Tamu',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.labelText,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isCameraSupported)
                  ListTile(
                    leading: const Icon(
                      Icons.photo_camera_rounded,
                      color: AppColors.inputBorderFocused,
                    ),
                    title: Text(
                      'Kamera',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickFrom(ImageSource.camera);
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.inputBorderFocused,
                  ),
                  title: Text(
                    _isCameraSupported ? 'Galeri' : 'Pilih File Foto',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickFrom(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _errorText != null;
    final bool hasPhoto = widget.value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Ambil gambar', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _showSourceSheet,
          child: Container(
            width: double.infinity,
            height: hasPhoto ? 200 : 140,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasError ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasPhoto
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(widget.value!, fit: BoxFit.cover),
                      // Lapisan gelap tipis + tombol ganti foto, supaya
                      // jelas foto itu masih bisa diganti.
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_a_photo_rounded,
                        size: 32,
                        color: Colors.black38,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk untuk ambil foto',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(
          height: 26,
          width: double.infinity,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
                  child: Text(
                    _errorText!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
