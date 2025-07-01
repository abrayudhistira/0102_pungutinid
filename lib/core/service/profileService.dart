import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pungutinid/core/service/authService.dart'; // pastikan import ini

class ProfileService {
  Future<void> updateProfile({
    required String username,
    String? password,
    File? photo,
  }) async {
    final uri = Uri.parse('http://192.168.1.21:3001/profile/edit');
    var request = http.MultipartRequest('POST', uri);

    request.fields['username'] = username;
    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }
    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Tambahkan token ke header
    final token = await AuthService().accessToken;
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode != 200) {
      print('Update profile gagal: ${response.statusCode} - $respStr');
      throw Exception('Gagal update profile');
    }
  }
}