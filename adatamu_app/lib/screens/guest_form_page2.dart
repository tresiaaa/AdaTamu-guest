import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pill_button.dart';
import '../widgets/guest_dropdown_field.dart';
import '../widgets/guest_text_field.dart';
import 'guest_form_page3.dart';

/// Page 2: Form pengisian data diri tamu.
/// Field: Nama Lengkap, Jenis Kelamin (dropdown), Alamat Lengkap,
/// Nomor Handphone. Tombol "Berikutnya" memvalidasi lalu lanjut ke page 3.
class GuestFormPage2 extends StatefulWidget {
  const GuestFormPage2({super.key});

  @override
  State<GuestFormPage2> createState() => _GuestFormPage2State();
}

class _GuestFormPage2State extends State<GuestFormPage2> {
  final _formKey = GlobalKey<FormState>();

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
    if (!_formKey.currentState!.validate()) return;
    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis kelamin terlebih dahulu')),
      );
      return;
    }

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
          // Header gradient kecil di atas, konsisten dengan dashboard.
          Container(
            height: 70,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
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
                      const SizedBox(height: 24),
                      GuestDropdownField(
                        label: 'Jenis Kelamin',
                        value: _jenisKelamin,
                        options: _jenisKelaminOptions,
                        onChanged: (value) => setState(() => _jenisKelamin = value),
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
                        hintText: 'Contoh: 081234567890',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor handphone tidak boleh kosong';
                          }
                          if (!RegExp(r'^[0-9+\-\s]{8,15}$').hasMatch(value.trim())) {
                            return 'Nomor handphone tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedPillButton(
                          label: 'Berikutnya',
                          onPressed: _goToNextPage,
                        ),
                      ),
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
