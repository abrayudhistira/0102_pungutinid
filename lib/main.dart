import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/component/screen/splashscreen.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/authService.dart';
import 'package:pungutinid/page/auth/login.dart';
import 'package:pungutinid/page/dashboard/dashboard.dart';
import 'package:pungutinid/page/profile/profile.dart';


void main() {
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(authService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pungutin.id',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Poppins',
      ),
      home: const Splashscreen(),
      routes: {
        '/buyerDashboard': (context) => DashboardScreen(),
        '/providerDashboard': (context) => DashboardScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}