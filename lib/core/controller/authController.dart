import 'package:flutter/material.dart';
import 'package:pungutinid/core/model/userModel.dart';
import 'package:pungutinid/core/service/authService.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service;

  User?   _user;
  bool    _isLoading = false;
  String? _error;

  AuthController(this._service);

  User?   get user      => _user;
  bool    get isLoading => _isLoading;
  String? get error     => _error;
  bool    get isLoggedIn => _user != null;

  /// Melakukan login dan update state
  Future<void> login(String username, String password) async {
    if (_user != null) {
      print('[AuthController] Prevented login: user already logged in (${_user?.username})');
      return;
    }

    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      final u = await _service.login(username, password);
      _user = u;
      print('[AuthController] Login success: ${_user?.username}');
    } catch (e) {
      _error = e.toString();
      print('[AuthController] Login failed: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password, String fullname, String address, String phone, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.register(username: username, password: password, fullname: fullname, address: address, phone: phone, email: email);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout dan update state
  Future<void> logout() async {
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  /// Contoh method memanggil resource proteksi
  Future<List<dynamic>?> fetchProtectedData() async {
    try {
      return await _service.getProtectedResource();
    } catch (_) {
      return null;
    }
  }

  /// Ambil ulang data user dari backend dan update state
  Future<void> refreshUser() async {
    try {
      final u = await _service.getProfile(); // Pastikan getProfile ada di AuthService
      _user = u;
      notifyListeners();
      print('[AuthController] User refreshed: ${_user?.username}');
    } catch (e) {
      print('[AuthController] Failed to refresh user: $e');
    }
  }
}
