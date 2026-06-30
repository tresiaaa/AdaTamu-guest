import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/guest_code.dart';
import '../widgets/animated_pill_button.dart';
import '../widgets/guest_dropdown_field.dart';
import '../widgets/guest_navbar.dart';
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

  // Menyimpan data dari page3 (keperluan, dll) supaya tidak hilang
  // saat user menekan "Kembali" dari page3 ke page2.
  String? _keperluan;
  String _keperluanLainnya = '';
  String _keterangan = '';
  String? _fotoPath;

  static const List<String> _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];

  // Kode tamu dihitung sekali saat halaman ini dibuka, supaya tetap sama
  // selama tamu mengisi form (page2 -> page3 -> kembali, dst). Murni dari
  // tanggal hari ini + nomor urut kedatangan (lihat lib/utils/guest_code.dart).
  late final String _kodeTamu = GuestCode.generate(
    DateTime.now(),
    GuestCode.dummyUrutanHariIni,
  );

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    final bool isFormValid = _formKey.currentState!.validate();
    final bool isJenisKelaminValid =
        _jenisKelaminFieldKey.currentState?.validate() ?? true;

    if (!isFormValid || !isJenisKelaminValid) return;

    // Kirim data yang sudah pernah diisi di page3 (kalau ada) sebagai
    // initial values, dan tunggu hasil balik saat user menekan "Kembali"
    // supaya data page3 tidak hilang ketika kembali ke page2.
    final result = await Navigator.of(context).push<Map<String, String?>>(
      MaterialPageRoute(
        builder: (_) => GuestFormPage3(
          nama: _namaController.text.trim(),
          jenisKelamin: _jenisKelamin!,
          alamat: _alamatController.text.trim(),
          nomorHandphone: _hpController.text.trim(),
          kodeTamu: _kodeTamu,
          initialKeperluan: _keperluan,
          initialKeperluanLainnya: _keperluanLainnya,
          initialKeterangan: _keterangan,
          initialFotoPath: _fotoPath,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _keperluan = result['keperluan'];
        _keperluanLainnya = result['keperluanLainnya'] ?? '';
        _keterangan = result['keterangan'] ?? '';
        _fotoPath = result['fotoPath'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      body: Column(
        children: [
          // Navbar: logo di kiri, bubble kode tamu + ikon kalender di kanan.
          GuestNavbar(kodeTamu: _kodeTamu),

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
                          final String trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          if (trimmed.length < 2) {
                            return 'Nama minimal 2 karakter';
                          }
                          if (trimmed.length > 60) {
                            return 'Nama maksimal 60 karakter';
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
                          final String trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          // Alamat minimal harus memuat Jalan + Nomor Rumah +
                          // Kelurahan/Kecamatan, jadi cegah input yang terlalu
                          // singkat (cuma 1 kata atau 1 huruf).
                          final List<String> words = trimmed
                              .split(RegExp(r'\s+'))
                              .where((w) => w.isNotEmpty)
                              .toList();
                          if (words.length < 2) {
                            return 'Alamat minimal terdiri dari 2 kata';
                          }
                          if (trimmed.length < 10) {
                            return 'Alamat terlalu singkat, tuliskan lebih lengkap';
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
