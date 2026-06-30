import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Menampilkan popup/dialog kalender kecil saat ikon kalender di navbar
/// di-tap. Tamu/admin bisa memilih tanggal, bulan, maupun tahun secara
/// bebas:
/// - Dropdown "Bulan" & "Tahun" di atas grid -> langsung lompat ke
///   bulan/tahun manapun tanpa perlu geser panah satu-satu.
/// - Tap tanggal di grid -> pilih tanggal itu.
/// - Tombol "Hari ini" -> reset langsung ke tanggal hari ini.
///
/// Grid tanggal dibangun MANUAL (bukan pakai CalendarDatePicker bawaan
/// Flutter) supaya perhitungan hari 100% terkontrol dan tidak bergantung
/// pada locale data Flutter — semua label hari/bulan sudah Bahasa
/// Indonesia secara native.
///
/// [initialDate] adalah tanggal yang sedang aktif/terpilih SAAT dialog
/// ini dibuka — biasanya tanggal terakhir kali dipilih pengguna (kalau
/// belum pernah pilih apa-apa, pakai DateTime.now()). Ini supaya kalau
/// dialog ditutup lalu dibuka lagi, kalender tidak "lupa" dan balik ke
/// hari ini, melainkan tetap menunjukkan tanggal yang terakhir dipilih.
///
/// Tombol "OK" mengembalikan tanggal yang sedang dipilih ke pemanggil
/// (lewat Navigator.pop), tombol "Batal" menutup tanpa mengembalikan apa-apa.
Future<DateTime?> showMiniCalendarDialog(
  BuildContext context, {
  DateTime? initialDate,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (context) => _MiniCalendarDialogContent(
      initialDate: initialDate ?? DateTime.now(),
    ),
  );
}

class _MiniCalendarDialogContent extends StatefulWidget {
  final DateTime initialDate;

  const _MiniCalendarDialogContent({required this.initialDate});

  @override
  State<_MiniCalendarDialogContent> createState() =>
      _MiniCalendarDialogContentState();
}

class _MiniCalendarDialogContentState
    extends State<_MiniCalendarDialogContent> {
  late DateTime _selectedDate = widget.initialDate;
  // Bulan/tahun yang sedang ditampilkan di grid. Dipisah dari
  // _selectedDate supaya pengguna bisa GESER-GESER bulan untuk
  // melihat-lihat tanpa kehilangan tanggal yang sudah dipilih.
  late DateTime _displayedMonth =
      DateTime(_selectedDate.year, _selectedDate.month);

  static const List<String> _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Senin=1 ... Minggu=7, dipakai untuk nama hari di label tanggal
  // terpilih (mis. "Senin, 29 Mei 2006").
  static const List<String> _namaHariLengkap = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // Urutan grid mulai dari Senin (standar Indonesia). Dibuat lengkap
  // (bukan disingkat) sesuai permintaan, grid diperlebar supaya muat.
  static const List<String> _namaHariGrid = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  String get _formattedSelectedDate {
    final String namaHari = _namaHariLengkap[_selectedDate.weekday - 1];
    return '$namaHari, ${_selectedDate.day} ${_namaBulan[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  void _changeMonthBy(int delta) {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    });
  }

  void _jumpToMonth(int month) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, month);
    });
  }

  void _jumpToYear(int year) {
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
    });
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDate =
          DateTime(_displayedMonth.year, _displayedMonth.month, day);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = now;
      _displayedMonth = DateTime(now.year, now.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int firstYear = now.year - 100;
    final int lastYear = now.year + 100;

    final int daysInMonth =
        _daysInMonth(_displayedMonth.year, _displayedMonth.month);

    // DateTime.weekday: Senin=1 ... Minggu=7. Grid kita mulai dari
    // Senin, jadi jumlah sel kosong sebelum tanggal 1 = weekday - 1.
    final int firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday;
    final int leadingEmptyCells = firstWeekday - 1;

    final bool isDisplayingCurrentMonth =
        _displayedMonth.year == now.year && _displayedMonth.month == now.month;
    final bool isSelectionInDisplayedMonth =
        _selectedDate.year == _displayedMonth.year &&
            _selectedDate.month == _displayedMonth.month;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.inputBorderFocused, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Kalender',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.labelText,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Baris label tanggal terpilih + tombol "Hari ini", dibuat
            // SAMA TINGGI & SAMA GAYA (sama-sama berbentuk pill abu muda)
            // supaya keduanya terasa sepasang, bukan dua elemen berbeda.
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.inputBorderFocused.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formattedSelectedDate,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.inputBorderFocused,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    onPressed: _goToToday,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(
                        color: AppColors.inputBorderFocused.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Hari ini',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.inputBorderFocused,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Dropdown Bulan & Tahun -> SAMA BESAR (masing-masing setengah
            // lebar), cara cepat lompat langsung tanpa geser panah satu-satu.
            Row(
              children: [
                Expanded(
                  child: _DropdownPill<int>(
                    value: _displayedMonth.month,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(
                          _namaBulan[i],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    onChanged: (month) {
                      if (month != null) _jumpToMonth(month);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DropdownPill<int>(
                    value: _displayedMonth.year,
                    items: [
                      for (int y = lastYear; y >= firstYear; y--)
                        DropdownMenuItem(value: y, child: Text('$y')),
                    ],
                    onChanged: (year) {
                      if (year != null) _jumpToYear(year);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Header navigasi bulan (panah kiri/kanan) di atas grid.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: AppColors.inputBorderFocused,
                  onPressed: () => _changeMonthBy(-1),
                ),
                Text(
                  '${_namaBulan[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.labelText,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: AppColors.inputBorderFocused,
                  onPressed: () => _changeMonthBy(1),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Baris nama hari, Senin di kiri s/d Minggu di kanan. Pakai
            // nama lengkap (bukan singkatan) sesuai permintaan, font
            // dikecilkan sedikit & FittedBox supaya tetap muat di kolom.
            Row(
              children: _namaHariGrid
                  .map(
                    (h) => Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            h,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),

            // Grid tanggal, dihitung manual dari DateTime.weekday supaya
            // perhitungan hari dijamin akurat untuk tanggal berapa pun.
            // Lebar diperbesar (dari 300 -> 340) supaya nama hari lengkap
            // di atas tidak terlalu sempit/terpotong.
            SizedBox(
              width: 340,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: leadingEmptyCells + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < leadingEmptyCells) {
                    return const SizedBox.shrink();
                  }

                  final int day = index - leadingEmptyCells + 1;
                  final bool isToday =
                      isDisplayingCurrentMonth && day == now.day;
                  final bool isSelected =
                      isSelectionInDisplayedMonth && day == _selectedDate.day;

                  return GestureDetector(
                    onTap: () => _selectDay(day),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.inputBorderFocused
                            : isToday
                                ? AppColors.inputBorderFocused.withOpacity(0.12)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppColors.inputBorderFocused
                                  : AppColors.labelText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Batal & OK. Batal diberi warna abu pucat supaya
            // jelas berbeda dari background putih dialog.
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0E0E0),
                        foregroundColor: AppColors.labelText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.inputBorderFocused,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Kembalikan tanggal yang sedang dipilih ke pemanggil.
                        Navigator.of(context).pop(_selectedDate);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown kecil bergaya "pill" supaya senada dengan tema bubble lain
/// di aplikasi ini. Lebar mengikuti Expanded dari pemanggil supaya
/// dropdown Bulan & Tahun selalu sama besar.
class _DropdownPill<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownPill({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBorderFocused.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.inputBorderFocused.withOpacity(0.3)),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          borderRadius: BorderRadius.circular(12),
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.labelText,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
