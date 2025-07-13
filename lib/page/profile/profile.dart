import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final user = authCtrl.user;

    return WillPopScope(
      onWillPop: () async {
        if (user != null) {
          final role = user.role?.toLowerCase();
          var route = role;
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
          return false; // prevent default pop
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<AuthController>().refreshUser();
          },
          child: user == null
              ? ListView(
                  children: [
                    const SizedBox(height: 200),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "User tidak ditemukan",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Header Section with Background
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green[700]!,
                              Colors.green[700]!,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            // Profile Picture with Shadow
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: Colors.green[200],
                                  backgroundImage: (user.photo != null && user.photo!.isNotEmpty)
                                      ? NetworkImage(user.photo!)
                                      : null,
                                  child: (user.photo == null || user.photo!.isEmpty)
                                      ? const Icon(Icons.person, size: 52, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Name Section
                            Text(
                              user.username ?? "-",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.fullname ?? "-",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      
                      // Profile Information Cards
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Contact Information Card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Kontak',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(Icons.email, 'Email', user.email ?? "-"),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(Icons.phone, 'Telepon', user.phone ?? "-"),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(Icons.location_on, 'Alamat', user.address ?? "-"),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit, size: 20),
                                    label: const Text("Edit Profile"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/editProfile');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.logout, size: 20),
                                    label: const Text("Logout"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[500],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () async {
                                      await authCtrl.logout();
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            title: const Text(
                                              'Silahkan login lagi.',
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.blue[500],
                                                ),
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
                            
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}