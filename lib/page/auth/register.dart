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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscure, required String? Function(dynamic value) validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field ini tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password tidak cocok'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authCtrl = context.read<AuthController>();
      final success = await authCtrl.register(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        _fullnameController.text.trim(),
        _addressController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registrasi berhasil! Silakan login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Kembali ke halaman login
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Registrasi Akun',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Username
                  _buildTextField(
                    hintText: 'Tuliskan username anda',
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username wajib diisi';
                      }
                      if (value.length < 4) {
                        return 'Username minimal 4 karakter';
                      }
                      return null;
                    },
                  ),

                  // Password
                  _buildTextField(
                    hintText: 'Tuliskan password anda',
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    toggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (value.length < 5) {
                        return 'Password minimal 5 karakter';
                      }
                      return null;
                    },
                  ),

                  // Confirm Password
                  _buildTextField(
                    hintText: 'Konfirm password anda',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password wajib diisi';
                      }
                      if (value != _passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      return null;
                    },
                  ),

                  // Fullname
                  _buildTextField(
                    hintText: 'Nama lengkap',
                    controller: _fullnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama lengkap wajib diisi';
                      }
                      return null;
                    },
                  ),

                  // Email
                  _buildTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),

                  // Address
                  _buildTextField(
                    hintText: 'Alamat',
                    controller: _addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat wajib diisi';
                      }
                      return null;
                    },
                  ),

                  // Phone
                  _buildTextField(
                    hintText: 'No. Telepon',
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'No. Telepon wajib diisi';
                      }
                      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                        return 'No. Telepon harus 10-15 digit angka';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24),

                  // Register Button
                  ButtonGreen(
                    text: 'Daftar',
                    onPressed: _handleRegister,
                    width: double.infinity,
                    height: 55,
                    borderRadius: 12,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 32),

                  // Login link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(text: 'Sudah punya akun? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Masuk',
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

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}