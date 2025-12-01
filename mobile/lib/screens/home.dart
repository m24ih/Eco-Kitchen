import 'package:flutter/material.dart';

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Alt navigasyon çubuğu
      bottomNavigationBar: _buildBottomNavBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Hoş Geldiniz Kartı (Header)
              _buildHeaderCard(context),

              const SizedBox(height: 40.0),

              // 2. Fonksiyonel Liste Butonları (İkon solda, buton sağda)
              _buildRowButton(
                icon: Icons.restaurant_rounded,
                text: 'Leftover Ingredient Inventory',
                onTap: () { /* Malzeme envanterine git */ },
              ),
              const SizedBox(height: 30.0),

              _buildRowButton(
                icon: Icons.autorenew_outlined,
                text: 'Kitchen Waste Utilization',
                onTap: () { /* Atık değerlendirmeye git */ },
              ),

              const SizedBox(height: 30.0),

              _buildRowButton(
                icon: Icons.shopping_bag,
                text: 'Shopping List Integration',
                onTap: () { /* Alışveriş listesine git */ },
              ),

              const SizedBox(height: 30.0),

              _buildRowButton(
                icon: Icons.favorite,
                text: 'Favorites',
                onTap: () { /* Favorilere git */ },
              ),

              // Alt navigasyon çubuğu için boşluk
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------
  // --- YARDIMCI WIDGET'LAR BAŞLANGIÇ ---
  // ------------------------------------

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Welcome, Sevval!',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Sağ Taraftaki İkon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: const Icon(
              Icons.recycling,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // İkon solda, Buton sağda (istediğiniz tasarım)
  Widget _buildRowButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Butonlar arası boşluk
      child: Row(
        children: [
          // 1. Sol Taraftaki İkon (Ayrı duran)
          Icon(
            icon,
            color: primaryGreen,
            size: 40, // İkon boyutu
          ),

          const SizedBox(width: 16.0), // İkon ile buton arasına boşluk

          // 2. Sağ Taraftaki Buton (Kalan tüm alanı kaplar)
          Expanded(
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: primaryGreen.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Yuvarlak köşeler
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Alt Navigasyon Çubuğu
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: secondaryGreen,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home, color: primaryGreen), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search, color: primaryGreen), onPressed: () {}),
            // Ortadaki özel buton/boşluk için yer
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.favorite_border, color: primaryGreen), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_outline, color: primaryGreen), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}