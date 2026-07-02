/// Konfigurasi Cloudinary untuk upload foto tamu.
///
/// CATATAN PENTING: hanya `cloudName` dan `uploadPreset` yang boleh ada
/// di sini. API Secret TIDAK BOLEH pernah ditaruh di kode Flutter,
/// karena kode ini bisa dibongkar/dibaca siapa saja yang pasang APK-nya.
///
/// Upload preset ini harus dibuat dengan Signing Mode = "Unsigned" di
/// Cloudinary Console (Settings → Upload → Upload presets → Add upload
/// preset). Dengan mode unsigned, upload bisa dilakukan langsung dari
/// app tanpa API Secret sama sekali — Cloudinary membatasi apa yang
/// boleh di-upload lewat aturan preset itu sendiri (folder, ukuran, dll).
class CloudinaryConfig {
  static const String cloudName = 'ijqftx0e';
  static const String uploadPreset = 'adatamu_guest_unsigned';
}
