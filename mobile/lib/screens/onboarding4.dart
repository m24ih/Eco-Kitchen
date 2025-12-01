
import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color lightGreenDot = Color(0xFFC7D3B5);

class Onboarding4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        actions: <Widget>[
          TextButton(
            onPressed: () {

            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFF9DB67B),
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Skip butonunun sağdan boşluğu
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),

              // 1. Üst Görsel (ClipRRect ile yuvarlak kenarlı)
              ClipRRect(
                borderRadius: BorderRadius.circular(140.0),
                child: Image.asset(
                  'assets/images/onboarding4.png',
                  height: MediaQuery.of(context).size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 12.0),

              // 2. Sayfa Gösterge Noktaları (Dots) - 3. nokta aktif
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),

              const SizedBox(height: 28.0),

              // 3. Başlık ve Metin
              const Text(
                'Your sustainable kitchen hub',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                "Recook what you have! Craft delicious, diet-friendly meals from home ingredients, responsibly share suitable leftovers with pets or strays, and master the kitchen with expert tips.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const Spacer(), // Butonları aşağı itmek için
              // Continue Butonu
              ElevatedButton(
                onPressed: () {


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
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12.0),

              // Sign In Butonu (Metin Butonu)
              OutlinedButton(
                onPressed: () {
                  // TODO: Giriş sayfasına yönlendirme
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: primaryGreen, width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  // Sayfa gösterge noktalarını (dots) oluşturan yardımcı fonksiyon
  List<Widget> _buildPageIndicator() {
    return [
      _buildDot(false),
      _buildDot(false),
      _buildDot(true),
    ];
  }

  // Tek bir nokta widget'ı
  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? primaryGreen : lightGreenDot,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}