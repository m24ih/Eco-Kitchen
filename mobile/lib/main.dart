import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. ÖNEMLİ: Riverpod paketi eklendi
import 'package:eco_kitchen/screens/splash_screen.dart';

// Renk kodunu tanımlayalım
const Color primaryGreen = Color(0xFF9DB67B);

void main() {
  runApp(
    // 2. ÖNEMLİ: ProviderScope, uygulamanın en tepesine sarıldı.
    // Bu olmadan "Bad state: No ProviderScope found" hatası alırsın.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hata ayıklama bandını kapatır
      debugShowCheckedModeBanner: false,
      title: 'Eco Kitchen',

      // Uygulamanın temel temasını ayarlıyoruz
      theme: ThemeData(
        // Font Ayarı: Montserrat'ı tüm uygulamada varsayılan font yapmak için.
        fontFamily: 'Montserrat',

        // Uygulamanın birincil rengi
        primaryColor: primaryGreen,

        // Scaffold'ların (sayfaların) varsayılan arka plan rengi
        scaffoldBackgroundColor: Colors.white,

        // Diğer widget'lar için renk şemasını ayarlama
        colorScheme: ColorScheme.light(
          primary: primaryGreen,
          secondary: primaryGreen, // Genellikle vurgu rengi
        ),

        // Buton stilleri vb. global ayarlar buraya eklenebilir
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      // Uygulamanın ilk açılacak sayfası: Splash Screen
      // Buradan sonra Onboarding veya Home'a kendi yönlenir.
      home: SplashScreen(),
    );
  }
}