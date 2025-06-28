import 'package:flutter/material.dart';
import 'package:pungutinid/page/dashboard/dashboard.dart';
import 'package:pungutinid/page/first/LandingPage.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),
            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? Colors.green 
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  // Next/Mulai Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to main app or login
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landingpage()));
                        //print("Navigate to main app");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Mulai' : 'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                ),
                Image.asset('assets/images/waste1.png', width: 200, height: 200),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Title
          Text(
            'Selamat Datang',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'di Pungutin.id',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Description
          Text(
            'Tak perlu khawatir lagi tentang sampah biar kami datang untuk membayar sampah anda.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                ),
                Image.asset('assets/images/jumbo.png', width: 200, height: 200),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Title
          Text(
            'Nikmati kemudahan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Pungutin Sekali',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Description
          Text(
            'Dapatkan kemudahan dalam mengumpulkan layanan Pungutin Sekali, kamu yang dapat mengurangi sampah sekali saja kapan pun dibutuhkan.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Image.asset('assets/images/boy.png', width: 250, height: 250),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Title
          Text(
            'Tanpa ribet,',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Pungutin Terjadwal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Description
          Text(
            'Jadwalkan pengambilan sampah secara Terencana! Layanan kami menyediakan Pungutin Terjadwal untuk membantu untuk jadwal rutin perminggu.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonWithBin(Color binColor, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Person (simple representation)
        Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.orange.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 8),
        // Recycling bin
        Container(
          width: 30,
          height: 40,
          decoration: BoxDecoration(
            color: binColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonWithRecycling(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Person head
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.orange.shade300,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        // Person body
        Container(
          width: 40,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.recycling,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBuilding(double height, Color color) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    );
  }
}

// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pungutin.id Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: OnboardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}