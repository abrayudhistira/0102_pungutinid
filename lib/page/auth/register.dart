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
  final _usernameController       = TextEditingController();
  final _passwordController       = TextEditingController();
  final _confirmPasswordController= TextEditingController();
  final _fullnameController       = TextEditingController();
  final _emailController          = TextEditingController();
  final _addressController        = TextEditingController();
  final _phoneController          = TextEditingController();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;

  // Tambahkan state untuk role
  String? _selectedRole;
  final List<String> _roles = ['Provider', 'Buyer', 'Citizen'];

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

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool isPassword    = false,
    bool obscureText   = false,
    VoidCallback? toggleObscure,
    required String? Function(String? value) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: toggleObscure,
              )
            : null,
        ),
        validator: validator,
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password tidak cocok'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih role'), backgroundColor: Colors.red),
        );
        return;
      }

      final authCtrl = context.read<AuthController>();
      final success = await authCtrl.register(
        username:  _usernameController.text.trim(),
        password:  _passwordController.text.trim(),
        fullname:  _fullnameController.text.trim(),
        address:   _addressController.text.trim(),
        phone:     _phoneController.text.trim(),
        email:     _emailController.text.trim(),
        role:      _selectedRole!,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authCtrl.error ?? 'Registrasi gagal!'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Registrasi Akun', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 32),

              // Role Dropdown
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    hintText: 'Pilih role',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) => v == null ? 'Role wajib dipilih' : null,
                ),
              ),

              _buildTextField(
                hintText: 'Tuliskan username anda',
                controller: _usernameController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Username wajib diisi';
                  if (v.length < 4)   return 'Username minimal 4 karakter';
                  return null;
                },
              ),

              _buildTextField(
                hintText: 'Tuliskan password anda',
                controller: _passwordController,
                isPassword: true,
                obscureText: _obscurePassword,
                toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password wajib diisi';
                  if (v.length < 5)   return 'Password minimal 5 karakter';
                  return null;
                },
              ),

              _buildTextField(
                hintText: 'Konfirm password anda',
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                toggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                  if (v != _passwordController.text) return 'Password tidak cocok';
                  return null;
                },
              ),

              _buildTextField(
                hintText: 'Nama lengkap',
                controller: _fullnameController,
                validator: (v) => (v == null || v.isEmpty) ? 'Nama lengkap wajib diisi' : null,
              ),

              _buildTextField(
                hintText: 'Email',
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Format email tidak valid';
                  return null;
                },
              ),

              _buildTextField(
                hintText: 'Alamat',
                controller: _addressController,
                validator: (v) => (v == null || v.isEmpty) ? 'Alamat wajib diisi' : null,
              ),

              _buildTextField(
                hintText: 'No. Telepon',
                controller: _phoneController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'No. Telepon wajib diisi';
                  if (!RegExp(r'^[0-9]{10,15}$').hasMatch(v)) return 'No. Telepon harus 10-15 digit angka';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              ButtonGreen(
                text: 'Daftar',
                onPressed: _handleRegister,
                width: double.infinity, height: 55,
                borderRadius: 12, fontSize: 16, fontWeight: FontWeight.w600,
              ),

              const SizedBox(height: 32),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'Sudah punya akun? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text('Masuk',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}
