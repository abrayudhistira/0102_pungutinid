import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final user = authCtrl.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: user == null
            ? const Center(child: Text("User tidak ditemukan"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.green[200],
                      backgroundImage: (user.photo != null && user.photo?.isNotEmpty == true)
                          ? NetworkImage(user.photo!)
                          : null,
                      child: (user.photo == null || user.photo?.isEmpty == true)
                          ? const Icon(Icons.person, size: 48, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      user.username,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      user.role,
                      style: TextStyle(fontSize: 16, color: Colors.green[700]),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(user.username ?? "-"),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await authCtrl.logout();
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Silahkan login lagi.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}