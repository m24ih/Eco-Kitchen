import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/core/services/api_service.dart'; // API Servisi
import 'package:eco_kitchen/backend/fastapi.dart'; // FastAPI
import 'package:eco_kitchen/screens/leftover.dart';
import 'package:eco_kitchen/screens/waste.dart';
import 'package:eco_kitchen/screens/shopping_list.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/profile.dart'; // Menü Ekranı

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color fabColor = Color(0xFF9DB67B);

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _bottomNavIndex = 0; // Şu anda seçili olan sekme (Home)
  String _userName = "User"; // Varsayılan isim

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Uygulama açılınca ismi çek
  }

  // Kullanıcı ismini Backend'den çekme fonksiyonu
  Future<void> _loadUserName() async {
    try {
      final dio = ref.read(apiServiceProvider);
      final api = FastAPI(dio);

      // Kullanıcı bilgilerini iste
      final userData = await api.getUserProfile();

      if (mounted) {
        setState(() {
          // 1. Önce "full_name" var mı bak
          if (userData['full_name'] != null && userData['full_name'].toString().isNotEmpty) {
            _userName = userData['full_name'];
          }
          // 2. Yoksa email'in baş kısmını al (örn: melih@gmail.com -> Melih)
          else if (userData['email'] != null) {
            String email = userData['email'].toString();
            String rawName = email.split('@')[0];
            _userName = rawName[0].toUpperCase() + rawName.substring(1);
          }
        });
      }
    } catch (e) {
      print("Home User Load Error: $e");
      // Hata olursa varsayılan "User" kalır
    }
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AiChefScreen()),
        );
      },
      backgroundColor: fabColor,
      shape: const CircleBorder(),
      elevation: 4.0,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildRowButton(
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Text(text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

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
          // DİNAMİK İSİM BURAYA GELİYOR
          Text(
            'Welcome, $_userName!',
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
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        return; // Zaten Home'dayız
      case 1:
        page = SearchRecipeScreen();
        break;
      case 2:
        page = FavoritesScreen();
        break;
      case 3:
        page = ProfileScreen(); // Menüye gider
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        backgroundColor: secondaryGreen,
        activeColor: primaryGreen,
        inactiveColor: primaryGreen.withOpacity(0.6),
        splashSpeedInMilliseconds: 300,
        notchMargin: 8,
        onTap: _onNavigationTap,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeaderCard(context),
              const SizedBox(height: 40.0),
              _buildRowButton(
                  icon: Icons.restaurant_rounded,
                  text: 'Leftover Ingredient Inventory',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeftoverScreen()),
                    );
                  }),
              const SizedBox(height: 30.0),
              _buildRowButton(
                  icon: Icons.autorenew_outlined,
                  text: 'Kitchen Waste Utilization',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WasteScreen()),
                    );
                  }),
              const SizedBox(height: 30.0),
              _buildRowButton(
                  icon: Icons.shopping_bag,
                  text: 'Shopping List Integration',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingListScreen()),
                    );
                  }),
              const SizedBox(height: 30.0),
              _buildRowButton(
                  icon: Icons.favorite,
                  text: 'Favorites',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoritesScreen()),
                    );
                  }),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}