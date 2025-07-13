import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/component/button/buyerNavbar.dart';
import 'package:pungutinid/component/button/citizenNavbar.dart';
import 'package:pungutinid/core/controller/authController.dart';

class CitizenDashboardScreen extends StatefulWidget {
  @override
  _CitizenDashboardScreenState createState() => _CitizenDashboardScreenState();
}

class _CitizenDashboardScreenState extends State<CitizenDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Set status bar color sama dengan header
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green[700], // samakan dengan warna header
        statusBarIconBrightness: Brightness.light, // agar icon status bar tetap terlihat
      ),
    );

    final authCtrl = context.watch<AuthController>();
    final user = authCtrl.user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Pungutin.id',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.notifications_outlined, color: Colors.white),
                            SizedBox(width: 16),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Text(
                                (user?.username != null && user?.username?.isNotEmpty == true)
                                    ? user!.username!.substring(0, 1).toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Greeting
                    Row(
                      children: [
                        Text(
                          user != null
                              ? 'Hai, ${user.username}!'
                              : 'Hai, Pengguna!',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Selamat Datang Kembali !',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Balance Card
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Penghasilan Cash',
                              style:
                                  TextStyle(color: Colors.grey[600], fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Rp 200,000',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(height: 8),
                          Text('Periode: Mei 2024',
                              style:
                                  TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildIconBox(Icons.trending_up, Colors.green[100], Colors.green[700]),
                        SizedBox(width: 8),
                        _buildIconBox(Icons.account_balance_wallet, Colors.blue[100], Colors.blue[700]),
                        SizedBox(width: 8),
                        _buildIconBox(Icons.history, Colors.red[100], Colors.red[700]),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu Grid
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildMenuCard(
                      icon: Icons.list_alt_rounded,
                      title: 'Langganan',
                      subtitle: 'Layanan Sampah',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/mySubscription');
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.info_outline_rounded,
                      title: 'Panduan',
                      subtitle: 'Guide Pengelolaan Sampah',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100), // spacing bottom
            ],
          ),
        ),
      ),
      bottomNavigationBar: CitizenNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color? bgColor, Color? iconColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color, 
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}