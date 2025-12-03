import 'package:flutter/material.dart';
// Kütüphaneyi import ediyoruz
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color fabColor = Color(0xFF9DB67B); // FAB için de ana rengi kullanalım

class HomeScreen extends StatefulWidget {
  // StatefulWidget yapısını kullanıyoruz, çünkü Bottom Nav durumunu tutmamız gerekecek
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0; // Şu anda seçili olan sekme

  // Navigasyon ikonları (Tasarımınızdaki sıra ile)
  final iconList = <IconData>[
    Icons.home,          // Ev
    Icons.search,        // Ara
    Icons.favorite_border, // Favoriler
    Icons.person_outline, // Profil
  ];

  // Ortadaki Özel Floating Action Button (FAB)
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Ana işlev (Örneğin, yeni tarif oluşturma)
      },
      backgroundColor: fabColor,
      shape: const CircleBorder(),
      elevation: 4.0,
      child: Center(
        // İçteki ikon ve hafif beyaz arka plan (Şef şapkası/geri dönüşüm)
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.recycling,
            color: primaryGreen,
            size: 30,
          ),
        ),
      ),
    );
  }

  // Fonksiyonel Liste Butonları (Yardımcı Widget'lar aynı kalıyor)
  Widget _buildRowButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: primaryGreen, size: 40),
          const SizedBox(width: 16.0),
          Expanded(
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: primaryGreen.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Text(text, textAlign: TextAlign.left, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Hoş Geldiniz Kartı (Yardımcı Widget'lar aynı kalıyor)
  Widget _buildHeaderCard(BuildContext context) {
    // ... (Önceki kodunuzdaki _buildHeaderCard içeriği)
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // 1. FAB
      floatingActionButton: _buildFAB(),

      // 2. FAB Konumu (Kütüphane ile mükemmel çalışır)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. AnimatedBottomNavigationBar
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center, // Çentik ortada
        notchSmoothness: NotchSmoothness.smoothEdge, // Yumuşak kenarlı çentik
        leftCornerRadius: 25, // Sol köşe yuvarlak
        rightCornerRadius: 25, // Sağ köşe yuvarlak
        backgroundColor: secondaryGreen, // Açık yeşil arka plan
        activeColor: primaryGreen, // Aktif ikon rengi
        inactiveColor: primaryGreen.withOpacity(0.6), // Pasif ikon rengi
        splashSpeedInMilliseconds: 300,
        notchMargin: 8, // FAB ile çentik arasındaki boşluk
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeaderCard(context),
              const SizedBox(height: 40.0),
              _buildRowButton(icon: Icons.restaurant_rounded, text: 'Leftover Ingredient Inventory', onTap: () {}),
              const SizedBox(height: 30.0),
              _buildRowButton(icon: Icons.autorenew_outlined, text: 'Kitchen Waste Utilization', onTap: () {}),
              const SizedBox(height: 30.0),
              _buildRowButton(icon: Icons.shopping_bag, text: 'Shopping List Integration', onTap: () {}),
              const SizedBox(height: 30.0),
              _buildRowButton(icon: Icons.favorite, text: 'Favorites', onTap:() {

              }),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}