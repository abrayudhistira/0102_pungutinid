import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // <--- Tambahkan ini
import 'package:pungutinid/core/service/authService.dart';
import '../model/wasteReportModel.dart';

class ReportService {
  final _baseUrl = 'http://10.0.2.2:3001/reports'; // ganti dengan URL-mu

  Future<List<WasteReport>> fetchReports() async {
    final uri = Uri.parse('$_baseUrl/all');
    print('[ReportService] Fetching reports from: $uri');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer <token>', // tambahkan jika perlu
    });

    print('[ReportService] HTTP ${resp.statusCode} Response body: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('[ReportService] Gagal load laporan: ${resp.statusCode}');
    }

    final decoded = jsonDecode(resp.body);
    print('[ReportService] Decoded JSON type: ${decoded.runtimeType}');

    if (decoded is! List) {
      throw Exception('[ReportService] Unexpected JSON format, expected List but got ${decoded.runtimeType}');
    }

    final List<dynamic> data = decoded;
    print('[ReportService] Number of items received: ${data.length}');
    print('[ReportService] First item keys: ${data.isNotEmpty ? (data.first as Map<String, dynamic>).keys.toList() : 'N/A'}');

    final reports = data
        .map((item) {
          final map = item as Map<String, dynamic>;
          print('[ReportService] Parsing item id=${map['id']}');
          return WasteReport.fromJson(map);
        })
        .toList();

    print('[ReportService] Parsed ${reports.length} WasteReport objects');

    return reports;
  }
   Future<void> createReport({
    required int userId,
    required double latitude,
    required double longitude,
    required File? photo,
    required String description,
  }) async {
    final uri = Uri.parse('$_baseUrl/post');
    final token = await AuthService().accessToken;

    print('[Service] Membuat laporan dengan multipart request ke: $uri');

    var request = http.MultipartRequest('POST', uri);

    // Header dengan token
    request.headers['Authorization'] = 'Bearer $token';

    // Data field
    request.fields['user_id'] = userId.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['description'] = description;
    request.fields['reported_at'] = DateTime.now().toIso8601String();

    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    print('[Service] Status Code: ${streamedResponse.statusCode}');
    print('[Service] Response Body: $responseBody');

    if (streamedResponse.statusCode != 201) {
      throw Exception('Gagal membuat laporan: $responseBody');
    }
  }
}
