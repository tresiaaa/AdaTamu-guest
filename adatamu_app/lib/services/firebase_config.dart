/// Konfigurasi project Firebase.
///
/// GANTI nilai di bawah ini dengan milik project Firebase kamu sendiri:
/// - [projectId] ada di Firebase Console > Project settings > General
///   (kolom "Project ID", bukan "Project name").
/// - [apiKey] adalah "Web API Key", ada di halaman yang sama. Dipakai
///   untuk autentikasi permintaan ke Firestore REST API (Android & Windows).
/// - [collection] adalah nama collection Firestore tempat data tamu
///   disimpan.
///
/// Lihat panduan setup lengkap di README.md.
class FirebaseConfig {
  static const String projectId = 'GANTI_DENGAN_PROJECT_ID';
  static const String apiKey = 'GANTI_DENGAN_WEB_API_KEY';
  static const String collection = 'guests';
}
