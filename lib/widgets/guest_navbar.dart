import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/guest_code.dart';
import 'adatamu_logo.dart';
import 'mini_calendar_dialog.dart';

/// Header/navbar yang dipakai di semua halaman form tamu (Page2, Page3,
/// dst). Berisi:
/// - Logo AdaTamu di kiri.
/// - Bubble kode tamu di kanan. Defaultnya kode tamu HARI INI (dihitung
///   ulang secara internal, lihat [_displayedKodeTamu]). Kalau pengguna
///   memilih tanggal lain lewat dialog kalender, bubble ini ikut berubah
///   untuk PREVIEW kode tamu di tanggal tersebut — murni tampilan, tidak
///   memengaruhi data yang akan tersimpan.
/// - Ikon kalender di paling kanan, di sebelah kanan bubble kode tamu.
///   Tap ikon ini membuka popup kalender kecil.
///
/// CATATAN soal [kodeTamu]: parameter ini adalah kode tamu "resmi" milik
/// tamu yang sedang mengisi form (dipakai Page2/Page3 untuk identitas &
/// saat menyimpan data — TIDAK boleh berubah hanya karena pengguna
/// iseng buka-buka kalender). Navbar ini sengaja TIDAK menampilkan
/// [kodeTamu] tersebut secara langsung, karena bubble di sini fungsinya
/// khusus untuk preview kalender (lihat [_displayedKodeTamu]).
class GuestNavbar extends StatefulWidget implements PreferredSizeWidget {
  final String kodeTamu;

  const GuestNavbar({super.key, required this.kodeTamu});

  @override
  State<GuestNavbar> createState() => _GuestNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _GuestNavbarState extends State<GuestNavbar> {
  // Tanggal yang sedang "aktif" untuk preview kode tamu. Mulai dari hari
  // ini, lalu berubah setiap kali pengguna memilih tanggal lain di
  // dialog kalender. Disimpan di sini (bukan cuma stringnya saja) supaya
  // saat dialog dibuka LAGI, kalender bisa mulai dari tanggal yang
  // TERAKHIR dipilih, bukan selalu balik ke hari ini.
  late DateTime _activeDate = DateTime.now();

  String get _displayedKodeTamu => GuestCode.generate(
        _activeDate,
        GuestCode.dummyUrutanHariIni,
      );

  Future<void> _openCalendar() async {
    final DateTime? picked = await showMiniCalendarDialog(
      context,
      initialDate: _activeDate,
    );
    if (picked == null || !mounted) return;

    // Tanggal dipilih dari kalender -> tampilkan PREVIEW kode tamu untuk
    // tanggal itu. Nomor urut tetap pakai dummy (lihat catatan TODO di
    // guest_code.dart) karena belum terhubung database.
    setState(() {
      _activeDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AdaTamuLogo(scale: 0.55),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GuestCodeBubble(kodeTamu: _displayedKodeTamu),
                  const SizedBox(width: 10),
                  _CalendarIconButton(onTap: _openCalendar),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestCodeBubble extends StatelessWidget {
  final String kodeTamu;

  const _GuestCodeBubble({required this.kodeTamu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.badge_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            kodeTamu,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CalendarIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child:
              Icon(Icons.calendar_month_rounded, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
