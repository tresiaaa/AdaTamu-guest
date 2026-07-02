import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'desktop_camera_capture_page.dart';

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

  bool get _useDesktopDialog =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  List<Widget> _sourceOptions(BuildContext popupContext) {
    return [
      ListTile(
        leading: const Icon(
          Icons.photo_camera_rounded,
          color: AppColors.inputBorderFocused,
        ),
        title: Text('Kamera', style: GoogleFonts.poppins(fontSize: 14)),
        onTap: () => Navigator.of(popupContext).pop(ImageSource.camera),
      ),
      ListTile(
        leading: const Icon(
          Icons.photo_library_rounded,
          color: AppColors.inputBorderFocused,
        ),
        title: Text('Galeri', style: GoogleFonts.poppins(fontSize: 14)),
        onTap: () => Navigator.of(popupContext).pop(ImageSource.gallery),
      ),
    ];
  }

  Future<ImageSource?> _showDesktopDialog() {
    return showDialog<ImageSource>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ambil Foto Tamu',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.labelText,
                  ),
                ),
                const SizedBox(height: 8),
                ..._sourceOptions(dialogContext),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<ImageSource?> _showMobileSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
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
                ..._sourceOptions(sheetContext),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSourceSheet() async {
    final ImageSource? source =
        await (_useDesktopDialog ? _showDesktopDialog() : _showMobileSheet());

    if (source == null || !mounted) return;

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    if (source == ImageSource.camera && _useDesktopDialog) {
      await _captureFromDesktopWebcam();
      return;
    }

    await _pickFrom(source);
  }

  Future<void> _captureFromDesktopWebcam() async {
    final XFile? photo = await showDialog<XFile>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => const DesktopCameraCapturePage(),
    );
    if (photo == null || !mounted) return;

    _clearError();
    widget.onChanged(File(photo.path));
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
