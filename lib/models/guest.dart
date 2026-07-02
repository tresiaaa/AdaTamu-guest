class Guest {
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final String nomorHandphone;
  final String keperluan;
  final String keteranganTambahan;
  final String kodeTamu;
  final String fotoUrl;
  final DateTime createdAt;
  final String status;
  final DateTime? waktuSelesai;

  Guest({
    required this.nama,
    required this.jenisKelamin,
    required this.alamat,
    required this.nomorHandphone,
    required this.keperluan,
    required this.keteranganTambahan,
    required this.kodeTamu,
    required this.fotoUrl,
    DateTime? createdAt,
    this.status = 'menunggu',
    this.waktuSelesai,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
      'nomorHandphone': nomorHandphone,
      'keperluan': keperluan,
      'keteranganTambahan': keteranganTambahan,
      'kodeTamu': kodeTamu,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt,
      'status': status,
      if (waktuSelesai != null) 'waktuSelesai': waktuSelesai,
    };
  }
}
