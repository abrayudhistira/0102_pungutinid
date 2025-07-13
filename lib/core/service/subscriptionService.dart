// lib/core/service/subscriptionService.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pungutinid/core/model/citizenSubscriptionModel.dart';
import 'package:pungutinid/core/model/userSubscriptionModel.dart';
import 'package:pungutinid/core/model/subscriptionPlanModel.dart';
import 'package:pungutinid/core/service/authService.dart';

class SubscriptionService {
  final _baseUrl = 'http://10.0.2.2:3001/subscriptions';

  /// Ambil token dari AuthService
  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService().accessToken;
    print('[SubscriptionService] Retrieved token: $token');
    if (token == null) throw Exception('Token tidak tersedia');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Fetch all subscription plans
  Future<List<SubscriptionPlan>> fetchPlans() async {
    final uri = Uri.parse('$_baseUrl/plans');
    final headers = await _authHeaders();
    print('[SubscriptionService] GET $uri');
    print('Headers: $headers');

    final resp = await http.get(uri, headers: headers);
    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat paket: ${resp.statusCode} ${resp.body}');
    }

    final decoded = jsonDecode(resp.body);
    if (decoded is! List) {
      throw Exception('Format respons tidak terduga: ${resp.body}');
    }

    return (decoded as List)
        .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Subscribe user to a plan
  // Future<void> subscribe({
  //   required int userId,
  //   required int planId,
  // }) async {
  //   final uri = Uri.parse('$_baseUrl/post');
  //   final headers = await _authHeaders();
  //   final body = jsonEncode({'user_id': userId, 'plan_id': planId});

  //   print('[SubscriptionService] POST $uri');
  //   print('Headers: $headers');
  //   print('Body: $body');

  //   final resp = await http.post(uri, headers: headers, body: body);
  //   print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

  //   if (resp.statusCode != 201) {
  //     throw Exception('Gagal berlangganan: ${resp.statusCode} ${resp.body}');
  //   }
  // }
  Future<void> subscribe({
    required int userId,
    required int planId,
  }) async {
    final uri = Uri.parse('$_baseUrl/post');
    // Ambil token dari AuthService
    final token = await AuthService().accessToken;
    print('[SubscriptionService] Retrieved token: $token');

    if (token == null) {
      throw Exception('Token tidak tersedia');
    }

    // Siapkan headers, wajib kirim Authorization
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Siapkan body JSON
    final body = jsonEncode({
      'user_id': userId,
      'plan_id': planId,
    });

    print('[SubscriptionService] POST $uri');
    print('Headers: $headers');
    print('Body: $body');

    // Lakukan POST
    final resp = await http.post(uri, headers: headers, body: body);

    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode != 201) {
      throw Exception('Gagal berlangganan: ${resp.statusCode} ${resp.body}');
    }
  }

  /// Fetch subscriptions milik user
  Future<List<CitizenSubscription>> fetchUserSubscriptions() async {
    final uri = Uri.parse('$_baseUrl/all');
    final headers = await _authHeaders();
    print('[SubscriptionService] GET $uri');
    print('Headers: $headers');

    final resp = await http.get(uri, headers: headers);
    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
        print('[SubscriptionService] Message from server: ${decoded['message']}');
        return [];
      }

      if (decoded is! List) {
        throw Exception('Format respons tidak terduga: ${resp.body}');
      }

      return (decoded as List)
          .map((e) => CitizenSubscription.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (resp.statusCode == 401) {
      throw Exception('Unauthorized: ${resp.body}');
    }

    throw Exception('Gagal load langganan: ${resp.statusCode} ${resp.body}');
  }

  /// Create a new plan (Provider only)
  Future<SubscriptionPlan> createPlan(SubscriptionPlan p) async {
    final uri = Uri.parse('$_baseUrl/plans');
    final headers = await _authHeaders();
    final body = jsonEncode(p.toJson());

    print('[SubscriptionService] POST $uri');
    print('Headers: $headers');
    print('Body: $body');

    final resp = await http.post(uri, headers: headers, body: body);
    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode != 201) {
      throw Exception('Gagal membuat paket: ${resp.statusCode} ${resp.body}');
    }

    return SubscriptionPlan.fromJson(jsonDecode(resp.body));
  }
  // Ambil semua langganan (untuk admin)
  Future<List<UserSubscription>> getAllUserSubscriptions() async {
    final uri = Uri.parse('$_baseUrl/subscription'); // sesuaikan dengan endpoint backend
    final headers = await _authHeaders();

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat semua langganan: ${resp.body}');
    }

    final decoded = jsonDecode(resp.body);
    if (decoded is! List) {
      throw Exception('Format respons tidak sesuai');
    }

    return decoded
        .map<UserSubscription>((e) => UserSubscription.fromJson(e))
        .toList();
  }

  /// Update existing plan (Provider only)
  Future<SubscriptionPlan> updatePlan(SubscriptionPlan p) async {
    final uri = Uri.parse('$_baseUrl/plans/${p.planId}');
    final headers = await _authHeaders();
    final body = jsonEncode(p.toJson());

    print('[SubscriptionService] PUT $uri');
    print('Headers: $headers');
    print('Body: $body');

    final resp = await http.put(uri, headers: headers, body: body);
    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Gagal memperbarui paket: ${resp.statusCode} ${resp.body}');
    }

    return SubscriptionPlan.fromJson(jsonDecode(resp.body));
  }

  /// Delete plan (Provider only)
  Future<void> deletePlan(int planId) async {
    final uri = Uri.parse('$_baseUrl/plans/$planId');
    final headers = await _authHeaders();

    print('[SubscriptionService] DELETE $uri');
    print('Headers: $headers');

    final resp = await http.delete(uri, headers: headers);
    print('[SubscriptionService] Response ${resp.statusCode}: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Gagal menghapus paket: ${resp.statusCode} ${resp.body}');
    }
  }
  // Batalkan langganan
  Future<void> cancelSubscription(int subscriptionId) async {
    final uri = Uri.parse('$_baseUrl/cancel/$subscriptionId');
    final token = await AuthService().accessToken;

    final resp = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Gagal membatalkan langganan: ${resp.body}');
    }
  }
  // Ubah status aktif/inaktif (jika ingin endpoint khusus)
  Future<void> updateSubscriptionStatus({
    required int subscriptionId,
    required bool isActive,
  }) async {
    final uri = Uri.parse('$_baseUrl/update/$subscriptionId');
    final token = await AuthService().accessToken;

    final resp = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'is_active': isActive}),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gagal update status langganan: ${resp.body}');
    }
  }

  Future<void> updateSubscriptionStatusByProvider({
    required int subscriptionId,
    required bool isActive,
  }) async {
    final uri = Uri.parse('$_baseUrl/provider/update/$subscriptionId');
    final token = await AuthService().accessToken;

    final resp = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'is_active': isActive}),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gagal update status langganan: ${resp.body}');
    }
  }
}
