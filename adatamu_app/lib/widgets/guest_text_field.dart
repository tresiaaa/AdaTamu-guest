import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Field input pil putih, berubah warna biru muda saat fokus
/// (meniru efek highlight yang terlihat pada video referensi).
class GuestTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const GuestTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<GuestTextField> createState() => _GuestTextFieldState();
}

class _GuestTextFieldState extends State<GuestTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isFocused ? AppColors.inputFillFocused : AppColors.inputFill,
            borderRadius: BorderRadius.circular(widget.maxLines > 1 ? 16 : 30),
            border: Border.all(
              color: _isFocused ? AppColors.inputBorderFocused : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            maxLines: widget.maxLines,
            textAlign: widget.maxLines > 1 ? TextAlign.start : TextAlign.center,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
