import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/onboarding4.dart';
import 'package:eco_kitchen/screens/sign_in.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color lightGreenDot = Color(0xFFC7D3B5);

class Onboarding3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
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
        child: SingleChildScrollView(
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
                    'assets/images/onboarding3.png',
                    height: MediaQuery.of(context).size.height * 0.40,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20.0),

                // 2. Sayfa Gösterge Noktaları (Dots) - 3. nokta aktif
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),

                const SizedBox(height: 18.0),

                // 3. Başlık ve Metin
                const Text(
                  'Find the suitable recipe',
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
                  "Get recipes filtered by your diet and allergies, discover safe ways to feed strays or pets, and unlock eco-friendly upcycling tips for every leftover.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24.0), // Butonları aşağı itmek için
                // Continue Butonu
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Yeni sayfanızı buraya yönlendiriyoruz
                        builder: (context) => Onboarding4Screen(),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
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
      ),
    );
  }

  // Sayfa gösterge noktalarını (dots) oluşturan yardımcı fonksiyon
  List<Widget> _buildPageIndicator() {
    return [
      _buildDot(false),
      _buildDot(true),
      _buildDot(false),
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
