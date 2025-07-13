import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/component/button/buyerNavbar.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/model/wasteSalesModel.dart';
import 'package:pungutinid/core/service/transactionService.dart';

class BuyerDashboardScreen extends StatefulWidget {
  @override
  _BuyerDashboardScreenState createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
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
                            SizedBox(width: 4),
                            Text('Pungutin.id',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                          ],
                        ),
                        Row(
                          children: [
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

              SizedBox(height: 30), // reduced spacing

              // Menu Grid
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85, // Adjusted aspect ratio to provide more height
                  children: [
                    _buildMenuCard(
                      icon: Icons.location_on_rounded,
                      title: 'Lokasi',
                      subtitle: 'Lokasi Bank Sampah',
                      color: Colors.green[700]!,
                      onTap: () {
                        Navigator.pushNamed(context, '/locationGet');
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.add_chart_rounded,
                      title: 'Beli',
                      subtitle: 'Beli Sampah',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/buyerTransaction');
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20), // spacing before sales section
              
              FutureBuilder(
                future: TransactionService().fetchAvailableWaste(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text("Belum ada penjualan tersedia."));
                  }

                  final sales = (snapshot.data as List<WasteSale>)
                      .where((sale) => sale.status == 'not_yet')
                      .take(4)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Penjualan Tersedia", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sales.length,
                          itemBuilder: (context, index) {
                            final sale = sales[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: index < sales.length - 1
                                    ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                                    : null,
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.recycling, color: Colors.green[700], size: 20),
                                ),
                                title: Text(
                                  "${sale.seller.fullname} - ${sale.weightKg} kg",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  "Rp ${sale.totalPrice}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    sale.status == "not_yet" ? "Tersedia" : sale.status,
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 100), // spacing bottom
            ],
          ),
        ),
      ),
      bottomNavigationBar: BuyerNavbar(
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