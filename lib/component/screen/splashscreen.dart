import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pungutinid/page/dashboard/dashboard.dart';
import 'package:pungutinid/page/first/OnBoardingPage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  void startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    Timer(duration, () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => OnboardingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: 500.0,
              height: 500.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
