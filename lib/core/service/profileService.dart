import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pungutinid/core/service/authService.dart';

class ProfileService {
  Future<void> updateProfile({
    required int userId,
    required String username,
    String? password,
    File? photo,
    required String fullname,
    required String email,
    required String address,
    required String phone,
  }) async {
    final uri = Uri.parse('http://10.0.2.2:3001/profile/edit');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId.toString(); // <-- Tambahkan ini
    request.fields['username'] = username;
    request.fields['fullname'] = fullname;
    request.fields['email'] = email;
    request.fields['address'] = address;
    request.fields['phone'] = phone;

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

    // Debug print data yang dikirim
    print('[DEBUG] UpdateProfile fields: ${request.fields}');
    if (photo != null) {
      print('[DEBUG] UpdateProfile photo: ${photo.path}');
    }

    // Tambahkan token ke header
    final token = await AuthService().accessToken;
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    print('[DEBUG] UpdateProfile response: ${response.statusCode} - $respStr');

    if (response.statusCode != 200) {
      print('Update profile gagal: ${response.statusCode} - $respStr');
      throw Exception('Gagal update profile');
    }
  }
}