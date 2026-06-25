import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../services/guest_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pill_button.dart';
import '../widgets/guest_dropdown_field.dart';
import '../widgets/guest_text_field.dart';
import 'guest_success_page.dart';

class GuestFormPage3 extends StatefulWidget {
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final String nomorHandphone;

  const GuestFormPage3({
    super.key,
    required this.nama,
    required this.jenisKelamin,
    required this.alamat,
    required this.nomorHandphone,
  });

  @override
  State<GuestFormPage3> createState() => _GuestFormPage3State();
}

class _GuestFormPage3State extends State<GuestFormPage3> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();

  String? _keperluan;
  bool _isSaving = false;

  static const List<String> _keperluanOptions = [
    'KWH Meter',
    'Pembayaran Tagihan',
    'Perubahan Daya Listrik',
    'Masalah Administrasi',
  ];

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _saveGuest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_keperluan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih keperluan terlebih dahulu')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final guest = Guest(
      nama: widget.nama,
      jenisKelamin: widget.jenisKelamin,
      alamat: widget.alamat,
      nomorHandphone: widget.nomorHandphone,
      keperluan: _keperluan!,
      keteranganTambahan: _keteranganController.text.trim(),
    );

    try {
      await GuestService.saveGuest(guest);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const GuestSuccessPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      body: Column(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                      GuestDropdownField(
                        label: 'Keperluan',
                        value: _keperluan,
                        options: _keperluanOptions,
                        onChanged: (value) =>
                            setState(() => _keperluan = value),
                      ),
                      const SizedBox(height: 24),
                      GuestTextField(
                        label: 'Keterangan Tambahan',
                        controller: _keteranganController,
                        hintText: 'Tuliskan keterangan tambahan (opsional)',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 40),
                      // Baris tombol: Kembali (abu-abu) di kiri, Simpan (kuning) di kanan.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedPillButton(
                            label: 'Kembali',
                            backgroundColor: const Color(0xFFBDBDBD),
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 12),
                          AnimatedPillButton(
                            label: 'Simpan',
                            isLoading: _isSaving,
                            onPressed: _isSaving ? null : _saveGuest,
                          ),
                        ],
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
