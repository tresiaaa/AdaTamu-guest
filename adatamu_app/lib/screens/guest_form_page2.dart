import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/adatamu_logo.dart';
import '../widgets/animated_pill_button.dart';
import '../widgets/guest_dropdown_field.dart';
import '../widgets/guest_text_field.dart';
import 'guest_form_page3.dart';

class GuestFormPage2 extends StatefulWidget {
  const GuestFormPage2({super.key});

  @override
  State<GuestFormPage2> createState() => _GuestFormPage2State();
}

class _GuestFormPage2State extends State<GuestFormPage2> {
  final _formKey = GlobalKey<FormState>();
  final _jenisKelaminFieldKey = GlobalKey<GuestDropdownFieldState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hpController = TextEditingController();
  String? _jenisKelamin;

  static const List<String> _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    final bool isFormValid = _formKey.currentState!.validate();
    final bool isJenisKelaminValid =
        _jenisKelaminFieldKey.currentState?.validate() ?? true;

    if (!isFormValid || !isJenisKelaminValid) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GuestFormPage3(
          nama: _namaController.text.trim(),
          jenisKelamin: _jenisKelamin!,
          alamat: _alamatController.text.trim(),
          nomorHandphone: _hpController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      body: Column(
        children: [
          // Header gradient dengan logo AdaTamu di pojok kiri atas.
          Container(
            width: double.infinity,
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    AdaTamuLogo(scale: 0.55),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GuestTextField(
                        label: 'Nama Lengkap',
                        controller: _namaController,
                        hintText: 'Masukkan nama lengkap',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GuestDropdownField(
                        key: _jenisKelaminFieldKey,
                        label: 'Jenis Kelamin',
                        value: _jenisKelamin,
                        options: _jenisKelaminOptions,
                        onChanged: (value) =>
                            setState(() => _jenisKelamin = value),
                      ),
                      const SizedBox(height: 24),
                      GuestTextField(
                        label: 'Alamat Lengkap',
                        controller: _alamatController,
                        hintText: 'Masukkan alamat lengkap',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      GuestTextField(
                        label: 'Nomor Handphone',
                        controller: _hpController,
                        hintText: 'Masukkan nomor handphone',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor handphone tidak boleh kosong';
                          }
                          if (!RegExp(r'^[0-9+\-\s]{8,15}$')
                              .hasMatch(value.trim())) {
                            return 'Nomor handphone tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedPillButton(
                          label: 'Berikutnya',
                          onPressed: _goToNextPage,
                          compact: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
