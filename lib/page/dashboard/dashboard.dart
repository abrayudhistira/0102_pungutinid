import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/component/button/custom_bottom_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.mail_outline, color: Colors.white),
                            SizedBox(width: 16),
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
                              style: TextStyle(
                                color: Colors.grey[600], 
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: 8),
                          Text('Rp 200,000',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Periode: Mei 2024',
                                style: TextStyle(
                                  color: Colors.green[700], 
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildIconBox(Icons.trending_up, Colors.green[100], Colors.green[700]),
                            SizedBox(width: 8),
                            _buildIconBox(Icons.account_balance_wallet, Colors.blue[100], Colors.blue[700]),
                          ],
                        ),
                        SizedBox(height: 8),
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
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85, // Added to provide more height
                  children: [
                    _buildMenuCard(
                      icon: Icons.people,
                      title: 'Langganan',
                      subtitle: 'Kelola Paket Langganan',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/subscribe');
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.group,
                      title: 'Pengguna',
                      subtitle: 'Kelola Langganan Pengguna',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/providerSubscription');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100), // spacing bottom
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 20),
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
        padding: EdgeInsets.all(12), // reduced padding
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
              padding: EdgeInsets.all(10), // reduced padding
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20), // reduced icon size
            ),
            SizedBox(height: 6), // reduced spacing
            Text(
              title,
              style: TextStyle(
                fontSize: 11, // reduced font size
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2), // reduced spacing
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9, // reduced font size
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}