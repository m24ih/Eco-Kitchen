import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/onboarding1.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 saniye sonra diğer ekrana geçiş yap
    Timer(Duration(seconds: 3), () {
      // Burada kullanıcı giriş yapmış mı kontrolü yapılabilir.
      // Şimdilik OnboardingScreen'e yönlendiriyorum (veya HomeScreen'e)
      // Kullanıcının main.dart'ta HomeScreen vardı, ama genelde Splash -> Onboarding (ilk açılışta) olur.
      // Ancak kullanıcı oturum açmış gibi davranıyorsak HomeScreen.
      // Kullanıcının requestinden "uygulama açılırken" dediği için,
      // ve main.dart'ta şu an HomeScreen olduğu için HomeScreen'e yönlendiriyorum.

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
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
