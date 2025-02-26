import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    // proses pengecekan sesi user
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        // Langsung ke home
        Get.offAllNamed('/home');
      } else {
        // ke login
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen sudah digantikan oleh flutter_native_splash,
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/wastewise_logo.png',
          width: 300,
        ),
      ),
    );
  }
}
