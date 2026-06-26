import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../services/guest_service.dart';
import '../theme/app_theme.dart';
import '../widgets/adatamu_logo.dart';
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
  final _keperluanLainnyaController = TextEditingController();

  // Key untuk paksa rebuild validator saat "Lainnya" muncul/hilang
  Key _lainnyaFieldKey = UniqueKey();

  String? _keperluan;
  bool _isSaving = false;
  // State error keperluan dropdown (ditangani manual seperti page2 jenis kelamin)
  bool _keperluanError = false;

  static const List<String> _keperluanOptions = [
    'KWH Meter',
    'Pembayaran Tagihan',
    'Perubahan Daya Listrik',
    'Masalah Administrasi',
    'Lainnya',
  ];

  bool get _isLainnya => _keperluan == 'Lainnya';

  @override
  void dispose() {
    _keteranganController.dispose();
    _keperluanLainnyaController.dispose();
    super.dispose();
  }

  Future<void> _saveGuest() async {
    // Validasi form (termasuk field "Tuliskan Keperluan Anda" kalau muncul)
    final bool isFormValid = _formKey.currentState!.validate();

    // Validasi dropdown keperluan secara manual
    if (_keperluan == null) {
      setState(() => _keperluanError = true);
    }

    if (!isFormValid || _keperluan == null) return;

    setState(() => _isSaving = true);

    final String keperluanFinal =
        _isLainnya ? _keperluanLainnyaController.text.trim() : _keperluan!;

    final guest = Guest(
      nama: widget.nama,
      jenisKelamin: widget.jenisKelamin,
      alamat: widget.alamat,
      nomorHandphone: widget.nomorHandphone,
      keperluan: keperluanFinal,
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
          // Header gradient dengan logo AdaTamu — sama seperti page2
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
                      // Dropdown keperluan — validasi manual (error merah)
                      GuestDropdownField(
                        label: 'Keperluan',
                        value: _keperluan,
                        options: _keperluanOptions,
                        onChanged: (value) {
                          setState(() {
                            _keperluan = value;
                            _keperluanError = false;
                            // Reset field lainnya + paksa rebuild validator
                            if (!_isLainnya) {
                              _keperluanLainnyaController.clear();
                            }
                            _lainnyaFieldKey = UniqueKey();
                          });
                        },
                      ),

                      // Pesan error merah untuk dropdown keperluan
                      if (_keperluanError)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 12, right: 12),
                          child: Text(
                            'Keperluan tidak boleh kosong',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),

                      // Field "Tuliskan Keperluan Anda" — muncul & WAJIB diisi saat "Lainnya"
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1,
                          child:
                              FadeTransition(opacity: animation, child: child),
                        ),
                        child: _isLainnya
                            ? Padding(
                                key: _lainnyaFieldKey,
                                padding: const EdgeInsets.only(top: 16),
                                child: GuestTextField(
                                  label: 'Tuliskan Keperluan Anda',
                                  controller: _keperluanLainnyaController,
                                  hintText: 'Contoh: Pengajuan pemasangan baru',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Keperluan tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : const SizedBox.shrink(
                                key: ValueKey('no_lainnya')),
                      ),

                      const SizedBox(height: 24),

                      // Keterangan tambahan — OPSIONAL, tidak ada validator
                      GuestTextField(
                        label: 'Keterangan Tambahan',
                        controller: _keteranganController,
                        hintText: 'Tuliskan keterangan tambahan (opsional)',
                        maxLines: 5,
                      ),

                      const SizedBox(height: 20),

                      // Tombol compact rata kanan — sama seperti page2
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedPillButton(
                              label: 'Kembali',
                              backgroundColor: const Color(0xFFBDBDBD),
                              compact: true,
                              onPressed: _isSaving
                                  ? null
                                  : () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 12),
                            AnimatedPillButton(
                              label: 'Simpan',
                              compact: true,
                              isLoading: _isSaving,
                              onPressed: _isSaving ? null : _saveGuest,
                            ),
                          ],
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
