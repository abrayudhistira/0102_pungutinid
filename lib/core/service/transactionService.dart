import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pungutinid/core/model/transactionGetModel.dart';
import 'package:pungutinid/core/model/wasteSalesModel.dart';
import '../model/transactionModel.dart';
import 'authService.dart';

class TransactionService {
  final _baseUrl = 'http://10.0.2.2:3001/transactions';

  Future<String?> _token() async => await AuthService().accessToken;

  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService().accessToken;
    if (token == null) throw Exception('Token tidak tersedia');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<Transaction> createSale({
    required int sellerId,
    double? weightKg,
    double? pricePerKg,
  }) async {
    final uri = Uri.parse('$_baseUrl/create');
    final token = await _token();
    final body = jsonEncode({
      'seller_id': sellerId,
      'weight_kg': weightKg,
      'price_per_kg': pricePerKg,
    });
    final resp = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body);
    if (resp.statusCode != 201) {
      throw Exception('Gagal membuat sale: ${resp.body}');
    }
    return Transaction.fromJson(jsonDecode(resp.body));
  }
  Future<List<TransactionGetModel>> fetchMyTransactions() async {
    final uri = Uri.parse('$_baseUrl/my'); // misal route backend: GET /transactions/my
    final headers = await _authHeaders();

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat transaksi: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body);
    return data
        .map((e) => TransactionGetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  // Future<List<WasteSale>> fetchAvailableWaste() async {
  //   final token = await _authHeaders();
  //   final res = await http.get(
  //     Uri.parse('$_baseUrl/all'),
  //     headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  //   );

  //   if (res.statusCode == 200) {
  //     final List list = jsonDecode(res.body);
  //     return list.map((e) => WasteSale.fromJson(e)).where((e) => e.status == 'not_yet').toList();
  //   } else {
  //     throw Exception('Failed to load waste sales');
  //   }
  // }
  Future<List<WasteSale>> fetchAvailableWaste() async {
    final token = await _token();
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[TransactionService] Status Code: ${response.statusCode}');
      print('[TransactionService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data
            .map((json) => WasteSale.fromJson(json))
            .where((sale) => sale.status == 'not_yet')
            .toList();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('[TransactionService] Exception: $e');
      rethrow;
    }
  }
    Future<void> uploadPaymentProof({
      required int saleId,
      required File imageFile,
    }) async {
      final token = await _token();

      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$_baseUrl/payment/$saleId'),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('payment_proof', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Gagal upload bukti pembayaran');
      }
    }
}
