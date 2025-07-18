// lib/widgets/custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';

class CitizenNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CitizenNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home, 'Home', 0),
          _buildNavItem(context, Icons.location_on_rounded, 'Lokasi', 1),
          _buildNavItem(context, Icons.sell_rounded, 'Jual', 2),
          _buildNavItem(context, Icons.report, 'Laporkan',3),
          _buildNavItem(context, Icons.person, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (label == 'Profile') {
          Navigator.pushNamed(context, '/profile');
        } else {
          onTap(index);
        }
        if (label == 'Lokasi') {
          Navigator.pushNamed(context, '/locationGet');
        } else {
          onTap(index);
        }
        if (label == 'Laporkan') {
          Navigator.pushNamed(context, '/wasteReport');
        } else {
          onTap(index);
        }
        if (label == 'Jual') {
          Navigator.pushNamed(context, '/citizenTransaction');
        } else {
          onTap(index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.green[700] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.green[700] : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}