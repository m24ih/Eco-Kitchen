import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'screens/onboarding1.dart';

// Renk kodunu tanımlayalım
const Color primaryGreen = Color(0xFF9DB67B);

void main() {
  // Uygulamayı başlatır ve MyApp widget'ını çalıştırır
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hata ayıklama bandını kapatır
      debugShowCheckedModeBanner: false,

      // Uygulamanın temel temasını ayarlıyoruz
      theme: ThemeData(
        // Font Ayarı: Montserrat'ı tüm uygulamada varsayılan font yapmak için.
        // **NOT:** pubspec.yaml dosyanıza fontu eklediğinizden emin olun!
        fontFamily: 'Montserrat',

        // Uygulamanın birincil rengi (bu renk, bazı widget'lar için varsayılan olarak kullanılır)
        primaryColor: primaryGreen,

        // Scaffold'ların (sayfaların) varsayılan arka plan rengi
        scaffoldBackgroundColor: Colors.white,

        // Diğer widget'lar için renk şemasını ayarlama
        colorScheme: ColorScheme.light(
          primary: primaryGreen,
          secondary: primaryGreen, // Genellikle vurgu rengi
        ),
      ),

      // Uygulamanın ilk açılacak sayfasını belirliyoruz.
      home: HomeScreen(),
    );
  }
}