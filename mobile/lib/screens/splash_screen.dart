import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/onboarding1.dart';
import 'package:eco_kitchen/screens/sign_in.dart';
import 'dart:async';

import '../backend/onboarding_store.dart';
import '../backend/token_store.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeFromSplash();
  }

  Future<void> _routeFromSplash() async {
    final onboardingStore = OnboardingStore();
    final tokenStore = TokenStore();
    final hasSeenOnboarding = await onboardingStore.hasSeenOnboarding();
    final token = await tokenStore.getToken();

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }

    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
      return;
    }

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200, // Logoyu uygun boyutta gösterelim
          height: 200,
        ),
      ),
    );
  }
}
