import 'package:flutter/material.dart';
import 'package:pungutinid/component/screen/splashscreen.dart';
import 'package:pungutinid/page/dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
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
    );
  }
}