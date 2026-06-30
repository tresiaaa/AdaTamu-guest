import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guest.dart';
import 'firebase_config.dart';

/// Service untuk menyimpan data buku tamu ke Cloud Firestore.
///
/// Memakai Firestore REST API langsung (lewat package `http`) untuk
/// SEMUA platform (Android maupun Windows). Pendekatan ini dipilih
/// karena plugin resmi `cloud_firestore` masih sering bermasalah saat
/// dikompilasi/dijalankan di Windows desktop, sedangkan REST API
/// bekerja sama persis di semua platform tanpa perlu kode native.
///
/// Referensi endpoint:
/// https://firebase.google.com/docs/firestore/reference/rest/v1/projects.databases.documents/createDocument
class GuestService {
  /// Menyimpan satu data tamu ke collection [FirebaseConfig.collection].
  /// Melempar [Exception] dengan pesan yang jelas kalau gagal, supaya
  /// UI bisa menampilkan pesan error ke pengguna.
  static Future<void> saveGuest(Guest guest) async {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/${FirebaseConfig.projectId}'
      '/databases/(default)/documents/${FirebaseConfig.collection}'
      '?key=${FirebaseConfig.apiKey}',
    );

    final body = jsonEncode({'fields': _toFirestoreFields(guest.toMap())});

    http.Response response;
    try {
      response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception(
        'Tidak bisa terhubung ke server. Periksa koneksi internet kamu.\n($e)',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal menyimpan data ke Firestore (${response.statusCode}): '
        '${response.body}',
      );
    }
  }

  /// Mengonversi Map biasa ke format "fields" yang dipakai Firestore REST API.
  static Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> data) {
    final fields = <String, dynamic>{};
    data.forEach((key, value) {
      fields[key] = _toFirestoreValue(value);
    });
    return fields;
  }

  static Map<String, dynamic> _toFirestoreValue(dynamic value) {
    if (value is String) {
      return {'stringValue': value};
    } else if (value is int) {
      return {'integerValue': value};
    } else if (value is double) {
      return {'doubleValue': value};
    } else if (value is bool) {
      return {'booleanValue': value};
    }
    return {'stringValue': value.toString()};
  }
}
