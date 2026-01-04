import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/onboarding3.dart';
import 'package:eco_kitchen/screens/sign_in.dart';

// Ana renk kodumuz
const Color primaryGreen = Color(0xFF9DB67B);
const Color lightGreenDot =
    Color(0xFFC7D3B5); // Noktalar için biraz daha açık bir ton kullandım.

class Onboarding2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Geri butonu (geri oku) otomatik olarak eklenir, ancak rengini ve temayı ayarlayalım.
        backgroundColor: Colors.transparent, // AppBar arka planını şeffaf yapar
        elevation: 0, // Gölgeyi kaldırır
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // Siyah geri oku
          onPressed: () {
            // Bir önceki sayfaya döner (Onboarding 1)
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        // İçeriğin, telefonun çentiği (notch) gibi alanlara girmesini engeller
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16.0),

                // 1. Üst Görsel
                // BURADA YENİ ClipRRect widget'ı ekliyoruz
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      140.0), // Kenar yuvarlama miktarı (deneyerek ayarlayabilirsiniz)
                  child: Image.asset(
                    'assets/images/onboarding2.png',
                    height: MediaQuery.of(context).size.height *
                        0.40, // Ekran yüksekliğinin %40'ı
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20.0),

                // 2. Sayfa Gösterge Noktaları (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),

                const SizedBox(height: 18.0),

                // 3. Başlık ve Metin
                const Text(
                  'Input your ingredients',
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
                  "Don't waste time wondering what to cook! List your ingredients in seconds and get instant recipes designed around what's already in your kitchen.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24.0), // Butonları aşağı itmek için

                // 4. Butonlar
                // Continue Butonu
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Yeni sayfanızı buraya yönlendiriyoruz
                        builder: (context) => Onboarding3Screen(),
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
                    side: const BorderSide(
                        color: primaryGreen, width: 2.0), // Yeşil çerçeve
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

                const SizedBox(height: 24.0), // Alt boşluk
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
      _buildDot(true), // Aktif sayfa (Yeşil)
      _buildDot(false), // Pasif sayfa (Açık gri)
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
