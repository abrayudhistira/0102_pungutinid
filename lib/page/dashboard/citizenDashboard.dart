// lib/pages/dashboard/citizenDashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/component/button/citizenNavbar.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/model/transactionModel.dart';
import 'package:pungutinid/core/service/transactionService.dart';
import 'package:intl/intl.dart';

class CitizenDashboardScreen extends StatefulWidget {
  @override
  _CitizenDashboardScreenState createState() => _CitizenDashboardScreenState();
}

class _CitizenDashboardScreenState extends State<CitizenDashboardScreen> {
  late Future<double> _earningsFuture;

  @override
  void initState() {
    super.initState();
    _earningsFuture = _loadEarnings();
  }

  Future<double> _loadEarnings() async {
    final service = TransactionService();
    final all = await service.fetchMyTransactions();
    // hanya yang sudah sold
    final sold = all.where((t) => t.status == 'sold');
    double sum = 0.0;
    for (var t in sold) {
      sum += await t.totalPrice;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // atur warna status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green[700],
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final authCtrl = context.watch<AuthController>();
    final user = authCtrl.user;
    int _currentIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    // top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pungutin.id',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.notifications_outlined, 
                                  color: Colors.white, size: 20),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Text(
                                  user?.username?.substring(0, 1).toUpperCase() ?? '?',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    // greeting
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user != null ? 'Hai, ${user.username}!' : 'Hai, Pengguna!',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selamat Datang Kembali !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // BALANCE CARD
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // future builder untuk earnings
                    FutureBuilder<double>(
                      future: _earningsFuture,
                      builder: (ctx, snap) {
                        if (snap.connectionState != ConnectionState.done) {
                          return Container(
                            height: 80,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.green[700],
                                strokeWidth: 3,
                              ),
                            ),
                          );
                        }
                        if (snap.hasError) {
                          return Container(
                            height: 80,
                            child: Center(
                              child: Text('Error: ${snap.error}', 
                                  style: TextStyle(color: Colors.red)),
                            ),
                          );
                        }
                        final total = snap.data ?? 0.0;
                        final formatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                            .format(total);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Penghasilan Cash',
                                    style: TextStyle(
                                      color: Colors.grey[600], 
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Bulan Ini',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(formatted,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            SizedBox(height: 8),
                            Text('Periode: ${DateFormat('MMMM yyyy').format(DateTime.now())}',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // ikon tambahan dengan layout yang lebih baik
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(Icons.trending_up, 'Trending', Colors.green),
                        _buildStatItem(Icons.account_balance_wallet, 'Wallet', Colors.blue),
                        _buildStatItem(Icons.history, 'History', Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),

              // SECTION TITLE
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // GRID MENU - Fixed overflow issue
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85, // Adjusted to prevent overflow
                  children: [
                    _buildMenuCard(
                      icon: Icons.list_alt_rounded,
                      title: 'Langganan',
                      subtitle: 'Layanan Sampah',
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/mySubscription'),
                    ),
                    _buildMenuCard(
                      icon: Icons.info_outline_rounded,
                      title: 'Panduan',
                      subtitle: 'Guide Pengelolaan',
                      color: Colors.blue,
                    ),
                    _buildMenuCard(
                      icon: Icons.point_of_sale_rounded,
                      title: 'Sale',
                      subtitle: 'Transaksi Saya',
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/myTransaction'),
                    ),
                  ],
                ),
              ),

              // // ADDITIONAL FEATURES SECTION
              // Padding(
              //   padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
              //   child: Text(
              //     'Fitur Tambahan',
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black87,
              //     ),
              //   ),
              // ),

              // // HORIZONTAL SCROLL CARDS
              // Container(
              //   height: 140,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              //     children: [
              //       _buildFeatureCard(
              //         icon: Icons.eco,
              //         title: 'Tips Ramah Lingkungan',
              //         description: 'Dapatkan tips untuk hidup lebih ramah lingkungan',
              //         color: Colors.green,
              //       ),
              //       SizedBox(width: 16),
              //       _buildFeatureCard(
              //         icon: Icons.star,
              //         title: 'Reward Program',
              //         description: 'Kumpulkan poin dari setiap transaksi',
              //         color: Colors.amber,
              //       ),
              //       SizedBox(width: 16),
              //       _buildFeatureCard(
              //         icon: Icons.support_agent,
              //         title: 'Customer Support',
              //         description: 'Hubungi kami untuk bantuan 24/7',
              //         color: Colors.blue,
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(height: 120), // Bottom padding for navbar
            ],
          ),
        ),
      ),
      bottomNavigationBar: CitizenNavbar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Flexible( // Prevent text overflow
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2),
            Flexible( // Prevent text overflow
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}