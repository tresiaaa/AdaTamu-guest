import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GuestDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const GuestDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 10),
        PopupMenuButton<String>(
          // Posisi menu selalu di bawah tombol/anchor.
          position: PopupMenuPosition.under,
          offset: const Offset(0, 8),
          constraints: const BoxConstraints(minWidth: double.infinity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.inputFill,
          onSelected: (selected) => onChanged(selected),
          itemBuilder: (context) => options
              .map(
                (opt) => PopupMenuItem<String>(
                  value: opt,
                  child: Center(
                    child: Text(opt, style: const TextStyle(fontSize: 15)),
                  ),
                ),
              )
              .toList(),
          // Tampilan field (anchor) bergaya pil putih.
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Teks rata tengah; ikon diletakkan di kanan.
                Expanded(
                  child: Text(
                    value ?? 'Pilih',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: value == null ? Colors.black54 : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
