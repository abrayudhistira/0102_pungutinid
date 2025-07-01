import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pungutinid/core/model/userModel.dart';

class AuthService {
  // Ganti dengan base URL backend-mu
  static const _baseUrl = 'http://10.69.6.124:3000/auth';
  final _storage = const FlutterSecureStorage();

  // Keys untuk storage
  static const _accessTokenKey  = 'pungutinidakses';
  static const _refreshTokenKey = 'pungutinidaksesrefresh';

  /// Melakukan login, menyimpan token, dan mengembalikan User object
  Future<User> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (resp.statusCode != 200) {
      throw Exception('Login gagal: ${resp.body}');
    }

    final data = jsonDecode(resp.body);

    final token      = data['token'];
    final userJson   = data['user'];

    if (token == null || userJson == null) {
      throw Exception('Data login tidak lengkap: $data');
    }

    await _storage.write(key: _accessTokenKey, value: token as String);

    return User.fromJson(userJson as Map<String, dynamic>);
  }

  /// Mendapatkan token dari secure storage
  Future<String?> get accessToken async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Menghapus semua token (logout)
  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Contoh method untuk request endpoint yang memerlukan autentikasi
  Future<List<dynamic>> getProtectedResource() async {
    final token = await accessToken;
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login terlebih dahulu.');
    }

    final uri = Uri.parse('$_baseUrl/protected');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Error: ${resp.body}');
    }
    return jsonDecode(resp.body) as List<dynamic>;
  }
}