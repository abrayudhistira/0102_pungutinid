import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/component/button/button_green.dart';
import 'package:pungutinid/core/controller/authController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Variable untuk menampilkan debug message
  String? _debugMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    // Navigasi jika sudah terautentikasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authCtrl.user != null) {
        final String route;
        final String? role = authCtrl.user!.role;

        if (role == 'buyer') {
          route = '/buyerDashboard';
        } else if (role == 'provider') {
          route = '/providerDashboard';
        } else if (role == 'citizen') {
          route = '/citizenDashboard';
        } else {
          // Role tidak dikenali, arahkan ke halaman default atau login
          route = '/login'; // atau halaman error/landing page
        }

        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Pungutin.id',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selamat datang kembali! Kami senang kebersamaan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              const Text(
                'Username',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _buildInputField(_emailController, 'Masukkan Username'),

              const SizedBox(height: 20),

              // Password Field
              const Text(
                'Kata Sandi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _buildPasswordField(),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotPassword');
                  },
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(color: Colors.green[600], fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button atau Loading
              authCtrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ButtonGreen(
                      text: 'Masuk',
                      width: double.infinity,
                      height: 52,
                      borderRadius: 12,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        setState(() => _debugMessage = null);

                        if (email.isEmpty || password.isEmpty) {
                          setState(() => _debugMessage = 'Field email atau password kosong');
                          return;
                        }

                        try {
                          print('[LoginPage] Attempt login with $email / $password');
                          await authCtrl.login(email, password);
                          print('[LoginPage] Login complete: user=${authCtrl.user}');
                        } catch (e) {
                          print('[LoginPage] Login error: \$e');
                          setState(() => _debugMessage = 'Error: \$e');
                        }
                      },
                    ),

              // Tampilkan debug message
              if (_debugMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _debugMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],

              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'Tidak punya akun? Buat Akun',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: 'Masukkan kata sandi',
          hintStyle: TextStyle(color: Colors.grey[400]),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[400],
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
      ),
    );
  }
}
