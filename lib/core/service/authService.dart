import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pungutinid/core/model/userModel.dart';

class AuthService {
  static const _baseUrl = 'http://10.0.2.2:3001/auth';
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey  = 'pungutinidakses';
  static const _refreshTokenKey = 'pungutinidaksesrefresh';

  /// Melakukan login, menyimpan token, dan mengembalikan User object
  Future<User> login(String username, String password) async {
    // Validasi input
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username dan password wajib diisi');
    }

    final uri = Uri.parse('$_baseUrl/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('[DEBUG] Login request: $username / $password');
    print('[DEBUG] Login response: ${resp.statusCode} - ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Login gagal: ${resp.body}');
    }

    final data = jsonDecode(resp.body);

    final token    = data['token'];
    final userJson = data['user'];

    if (token == null || userJson == null) {
      throw Exception('Data login tidak lengkap: $data');
    }

    await _storage.write(key: _accessTokenKey, value: token as String);

    print('[DEBUG] Login success, token: $token');
    print('[DEBUG] User: $userJson');

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
  Future<void> register({
    required String username,
    required String password,
    required String fullname,
    required String address,
    required String phone,
    String? role,
    String? photo,
    String? email,
  }) async {
    // Validasi input
    if (username.isEmpty || password.isEmpty || fullname.isEmpty || address.isEmpty || phone.isEmpty) {
      throw Exception('Semua field wajib diisi');
    }
    if (email != null && email.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Format email tidak valid');
    }

    final uri = Uri.parse('$_baseUrl/register');
    final body = {
      'username': username,
      'password': password,
      'fullname': fullname,
      'address': address,
      'phone': phone,
      if (role != null) 'role': role,
      if (photo != null) 'photo': photo,
      if (email != null) 'email': email,
    };

    print('[DEBUG] Register request: $body');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('[DEBUG] Register response: ${resp.statusCode} - ${resp.body}');

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Register gagal: ${resp.body}');
    }
  }

  Future<User> getProfile() async {
    final token = await accessToken; // Ambil token yang benar
    final uri = Uri.parse('$_baseUrl/profile');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode != 200) throw Exception('Gagal ambil profile');
    final data = jsonDecode(resp.body);
    return User.fromJson(data['user']);
  }
}