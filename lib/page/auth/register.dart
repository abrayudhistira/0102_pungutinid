// lib/pages/auth/register.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pungutinid/component/button/button_green.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController        = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullnameController        = TextEditingController();
  final _emailController           = TextEditingController();
  final _addressController         = TextEditingController();
  final _phoneController           = TextEditingController();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole;
  final _roles = ['Provider', 'Buyer', 'Citizen'];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username wajib diisi';
    final s = v.trim();
    if (s.length < 4) return 'Username minimal 4 karakter';
    if (s.length > 20) return 'Username maksimal 20 karakter';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(s)) {
      return 'Hanya huruf, angka, underscore';
    }
    if (RegExp(r'^[0-9]').hasMatch(s)) {
      return 'Tidak boleh diawali angka';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 8) return 'Password minimal 8 karakter';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Harus ada huruf besar';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Harus ada huruf kecil';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Harus ada angka';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
      return 'Harus ada simbol khusus';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Konfirmasi wajib diisi';
    if (v != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  String? _validateFullname(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
    final s = v.trim();
    if (s.length < 2) return 'Minimal 2 karakter';
    if (s.length > 50) return 'Maksimal 50 karakter';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(s)) {
      return 'Hanya huruf dan spasi';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final s = v.trim();
    if (s.length > 254) return 'Email terlalu panjang';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(s)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) return 'Alamat wajib diisi';
    final s = v.trim();
    if (s.length < 10) return 'Minimal 10 karakter';
    if (s.length > 200) return 'Maksimal 200 karakter';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Telepon wajib diisi';
    final s = v.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (s.startsWith('+62')) {
      if (!RegExp(r'^\+62[0-9]{9,13}$').hasMatch(s)) {
        return 'Format +62 dan 9–13 digit';
      }
    } else if (s.startsWith('0')) {
      if (!RegExp(r'^0[0-9]{9,12}$').hasMatch(s)) {
        return 'Format 0 dan 9–12 digit';
      }
    } else {
      return 'Harus diawali +62 atau 0';
    }
    return null;
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authCtrl = context.read<AuthController>();
    final ok = await authCtrl.register(
      username:  _usernameController.text.trim(),
      password:  _passwordController.text,
      fullname:  _fullnameController.text.trim(),
      address:   _addressController.text.trim(),
      phone:     _phoneController.text.trim(),
      email:     _emailController.text.trim(),
      role:      _selectedRole!,
    );

    if (ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authCtrl.error ?? 'Registrasi gagal!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Akun'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Role
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    hintText: 'Pilih role',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _roles
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(r),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) =>
                      v == null ? 'Role wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDeco('Username'),
                  validator: _validateUsername,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDeco('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: _inputDeco('Konfirmasi Password')
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      }),
                    ),
                  ),
                  validator: _validateConfirm,
                ),
                const SizedBox(height: 16),

                // Fullname
                TextFormField(
                  controller: _fullnameController,
                  decoration: _inputDeco('Nama Lengkap'),
                  validator: _validateFullname,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDeco('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: _inputDeco('Alamat Lengkap'),
                  minLines: 2,
                  maxLines: 4,
                  validator: _validateAddress,
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDeco('No. Telepon'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: _validatePhone,
                ),
                const SizedBox(height: 24),

                ButtonGreen(
                  text: 'Daftar',
                  onPressed: _handleRegister,
                  width: double.infinity,
                  height: 55,
                  borderRadius: 12,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
