import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/onboarding2.dart';
const Color primaryGreen = Color(0xFF9DB67B);

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. Arka Plan Resmi ve Karartma (Overlay)
          Image.asset(
            'assets/images/kitchen.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),

          // 2. Ön Plan İçeriği (Dinamik Konumlandırma)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Metni aşağı itmek için boşluk
              SizedBox(height: screenHeight * 0.35),

              // Başlık Metnini Sadece Buradan Padding ile sarıyoruz
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: const Text(
                  'What You Have,\nGet Inspired,\nCook & Reuse.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),

              const Spacer(),

              // Alt Kısım Kartı (Beyaz Alan)
              Container(
                width: double.infinity,
                // İç padding (soldan ve sağdan) buradaki butonlara uygulanacak.
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // 'Get Started' Butonu
                    ElevatedButton(
                      onPressed: () {
                      // YÖNLENDİRME KODU BURADA
                        Navigator.push(
                        context,
                         MaterialPageRoute(
                      // Yeni sayfanızı buraya yönlendiriyoruz
                    builder: (context) => Onboarding2Screen(),
                    ),
                    );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // **YENİ BÖLÜM: OR ve ÇİZGİLER**
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(child: Divider(color: Colors.grey, thickness: 1.0)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Or',
                              style: TextStyle(color: Colors.grey, fontSize: 14.0),
                            ),
                          ),
                          const Expanded(child: Divider(color: Colors.grey, thickness: 1.0)),
                        ],
                      ),
                    ),
                    // **YENİ BÖLÜM SONU**

                    const SizedBox(height: 8.0),

                    // 'Login' Metin Butonu
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: primaryGreen,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),
            ],
          ),
        ],
      ),
    );
  }
}