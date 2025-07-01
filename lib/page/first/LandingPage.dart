import 'package:flutter/material.dart';
import 'package:pungutinid/component/button/button_green.dart';
import 'package:pungutinid/component/button/button_white.dart';

class Landingpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Container(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Trash bin (pakai asset atau container sederhana)
                    Positioned(
                      //bottom: 40,
                      child: Image.asset(
                        'assets/images/trashbin.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Title
              Text(
                'Pungut Sampah\nDapat Untung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                  height: 1.2,
                ),
              ),

              SizedBox(height: 20),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Bergabunglah dengan program lingkungan inovatif dan dapatkan reward dari setiap langkah kecil dalam menjaga lingkungan. Mari bersama-sama dengan mengubah dunia di sekitar kita.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ButtonGreen(
                      text: 'Daftar',
                      onPressed: () {
                        print('Daftar button pressed');
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ButtonWhite(
                      text: 'Masuk',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallingItem(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}