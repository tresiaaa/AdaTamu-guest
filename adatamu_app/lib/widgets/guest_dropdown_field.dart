import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Dropdown bergaya pil putih, konsisten dengan [GuestTextField].
/// Dipakai untuk "Jenis Kelamin" (page 2) dan "Keperluan" (page 3).
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: options
                .map((opt) => DropdownMenuItem(
                      value: opt,
                      child: Text(opt, style: const TextStyle(fontSize: 15)),
                    ))
                .toList(),
            onChanged: onChanged,
            validator: validator,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            borderRadius: BorderRadius.circular(16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            hint: const Text('Pilih', style: TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }
}
