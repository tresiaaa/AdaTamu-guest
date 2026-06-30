/// Utility untuk menghasilkan "Kode Tamu" yang TIDAK acak — murni hasil
/// kombinasi tanggal kedatangan + nomor urut tamu pada hari itu. Karena itu,
/// kode ini bisa dihitung & ditampilkan dari awal (sebelum tamu menekan
/// "Simpan"), selama kita tahu tanggal hari ini dan nomor urut kedatangan.
///
/// Format: <HariSingkat><Tanggal><BulanSingkat><TahunSingkat>-<Urutan>
/// Contoh: Selasa, 30 Juni 2026, tamu ke-1 hari itu -> "SEL30JUN26-01"
///
/// Catatan perbaikan dari usul awal ("S30J26-01"):
/// Singkatan hari & bulan diperpanjang jadi 3 huruf (SEL, JUN, dst),
/// karena banyak nama hari (Senin/Selasa/Sabtu sama-sama berawalan "S")
/// dan nama bulan (Januari/Juni/Juli sama-sama berawalan "J") yang kalau
/// disingkat 1 huruf akan bentrok / ambigu. Dengan 3 huruf, setiap kode
/// tetap pendek & mudah dibaca tapi tidak ada tabrakan arti.
class GuestCode {
  GuestCode._();

  static const List<String> _dayAbbr = [
    'SEN', // Senin
    'SEL', // Selasa
    'RAB', // Rabu
    'KAM', // Kamis
    'JUM', // Jumat
    'SAB', // Sabtu
    'MIN', // Minggu
  ];

  static const List<String> _monthAbbr = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MEI',
    'JUN',
    'JUL',
    'AGU',
    'SEP',
    'OKT',
    'NOV',
    'DES',
  ];

  /// Menghasilkan kode tamu dari [date] (tanggal kedatangan) dan [urutan]
  /// (nomor urut kedatangan tamu pada hari itu, dimulai dari 1).
  ///
  /// TODO(database): Saat ini nomor urut masih HARDCODE (lihat
  /// [dummyUrutanHariIni]). Setelah terhubung ke Firestore, ganti dengan
  /// hasil hitung jumlah dokumen tamu yang `createdAt`-nya = hari ini,
  /// lalu tambah 1.
  static String generate(DateTime date, int urutan) {
    final String hari = _dayAbbr[date.weekday - 1]; // weekday: 1 = Senin
    final String bulan = _monthAbbr[date.month - 1];
    final String tahun = (date.year % 100).toString().padLeft(2, '0');
    final String urutanStr = urutan.toString().padLeft(2, '0');
    return '$hari${date.day}$bulan$tahun-$urutanStr';
  }

  /// Nomor urut dummy untuk tahap UI (belum connect database).
  /// Nanti diganti hitungan asli dari Firestore.
  static const int dummyUrutanHariIni = 1;
}
