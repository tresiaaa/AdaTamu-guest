/// Model data buku tamu, merangkum data dari page 2 (data diri)
/// dan page 3 (keperluan).
class Guest {
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final String nomorHandphone;
  final String keperluan;
  final String keteranganTambahan;
  final DateTime createdAt;

  Guest({
    required this.nama,
    required this.jenisKelamin,
    required this.alamat,
    required this.nomorHandphone,
    required this.keperluan,
    required this.keteranganTambahan,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Untuk dikirim ke Cloud Firestore lewat REST API (lihat
  /// services/guest_service.dart).
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
      'nomorHandphone': nomorHandphone,
      'keperluan': keperluan,
      'keteranganTambahan': keteranganTambahan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
