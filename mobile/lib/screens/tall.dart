import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod ekle
import 'package:eco_kitchen/core/providers/onboarding_provider.dart'; // 2. Provider'ı ekle
import 'package:eco_kitchen/screens/weight.dart';

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color lightGrey = Color(0xFFEFEFEF);
const Color darkGreen = Color(0xFF38463B);
const Color indicatorYellow = Color(0xFFF7C555); // Sarı/Turuncu ok rengi

class TallScreen extends ConsumerStatefulWidget {
  @override
  _TallScreenState createState() => _TallScreenState();
}

class _TallScreenState extends ConsumerState<TallScreen> {
  late PageController _pageController;
  int _currentPage = 175; // Seçili cm değeri
  final int _minHeight = 0;
  final int _maxHeight = 400;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage - _minHeight,
      viewportFraction: 0.25,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Seçili Kartı Büyüten ve Renklendiren Widget
  Widget _buildHeightCard(int height) {
    bool isSelected = height == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: isSelected
          ? const EdgeInsets.symmetric(horizontal: 5, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      width: 75,
      height: isSelected ? 130 : 110,
      decoration: BoxDecoration(
        color: isSelected ? lightGrey : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isSelected ? Border.all(color: lightGrey, width: 2) : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        height.toString(),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: isSelected ? 36 : 24,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? darkGreen : Colors.grey[400],
        ),
      ),
    );
  }

  // Dinamik Cetvel Çizen Widget
  Widget _buildRuler(int selectedHeight) {
    int startCm = (selectedHeight ~/ 10) * 10;
    int selectedPosition = selectedHeight % 10;

    return Column(
      children: [
        // Cetvel Çizgileri
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(11, (i) {
            bool isMajor = i % 5 == 0;

            Widget line = Container(
              width: i % 10 == 0 ? 2 : 1,
              height: i % 10 == 0 ? 12 : (isMajor ? 8 : 4),
              color: Colors.grey,
            );

            // Seçilen noktada kalın dikey çizgi (sadece 10'luk aralık içinde)
            if (i == selectedPosition && selectedPosition != 0) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: line,
                  ),
                  Container(
                    width: 3,
                    height: 20,
                    color: darkGreen,
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: line,
            );
          }),
        ),

        const SizedBox(height: 8),

        // Alt Sayılar (Başlangıç ve Bitiş)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startCm.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                (startCm + 10).toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {/* Skip */},
            child: const Text('Skip',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32.0),

            // Başlık Metni (Row içinde yan yana ve ortalanmış)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('How ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkGreen)),
                  Text('tall',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen)),
                  const Text(' are you?',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkGreen)),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Açıklama Metni
            const Center(
              child: Text(
                'We will use this data to give you a better diet type for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 14, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 48.0),

            // YENİ YERLEŞİM: Sarı Ok (Kartların hemen üstünde sabit)
            const Center(
              child: Icon(
                Icons.arrow_drop_down,
                color: indicatorYellow,
                size: 40,
              ),
            ),

            // Kaydırılabilir Boy Seçici
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _maxHeight - _minHeight + 1,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index + _minHeight;
                  });
                },
                itemBuilder: (context, index) {
                  int height = index + _minHeight;
                  return _buildHeightCard(height);
                },
              ),
            ),

            const SizedBox(height: 16.0),

            // Alt Ölçek Çizgisi ve Seçili İşaret
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildRuler(_currentPage),
            ),

            const Spacer(),

            // Next Butonu
            ElevatedButton(
              onPressed: () {
                // ref.read(onboardingProvider.notifier).setHeight(_currentPage);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightScreen(), // Yeni sayfanızın adı
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
                'Next',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
