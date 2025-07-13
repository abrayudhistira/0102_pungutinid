import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pungutinid/core/model/location.dart';
import 'package:pungutinid/core/service/authService.dart';

class LocationService {
  static const _baseUrl = 'http://10.0.2.2:3001/location';

  Future<List<Location>> getLocationsByUserId(int userId) async {
    final uri = Uri.parse('$_baseUrl/get/$userId');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Gagal mengambil data lokasi user');
    }

    final data = jsonDecode(resp.body);
    final List list = data is List ? data : data['locations'] ?? [];
    return list.map((e) => Location.fromJson(e)).toList();
  }

  Future<void> addLocation(Location location) async {
    final token = await AuthService().accessToken; // Ambil token dari storage
    final uri = Uri.parse('$_baseUrl/post');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- Tambahkan token di sini
      },
      body: jsonEncode(location.toJson()),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Gagal menambah lokasi: ${resp.body}');
    }
  }

  Future<List<Location>> getAllLocations() async {
  final uri = Uri.parse('$_baseUrl/all');
  final resp = await http.get(uri);

  if (resp.statusCode != 200) {
    throw Exception('Gagal mengambil semua lokasi');
  }

  final data = jsonDecode(resp.body);
  final List list = data is List ? data : data['locations'] ?? [];
  return list.map((e) => Location.fromJson(e)).toList();
}
}