import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'goal.dart';
// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color darkGreen = Color(0xFF38463B);
const Color needleColor = Colors.black; // İbre rengi

class SportScreen extends StatefulWidget {
  @override
  _SportScreenState createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
  // Aktivite seviyesi (0.0: En Soldan, 1.0: En Sağa)
  double _activityLevel = 0.8;

  // İbreyi Çizen ve Hareket Ettiren Widget (SON HASSAS REVİZYON)
  Widget _buildGaugeNeedle(double size, double level) {
    // Görseldeki minimum ve maksimum ibre açısı.
    double minAngle = -135;
    double maxAngle = 135;
    double currentAngleInDegrees = minAngle + (maxAngle - minAngle) * level;

    // İbre uzunluğu (gösterge yarıçapına yakın olmalı)
    final double needleLength = size * 0.45;

    return Transform.rotate(
      // Bu, bütün ibre sistemini döndürür
      angle: currentAngleInDegrees * (math.pi / 180),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // İbre Çizgisi (Merkezden yukarı doğru uzar)
            Positioned(
              // İbrenin kökünü göstergenin alt merkezine hizala
              // (size * 0.5) tam merkezdir, buraya 2 piksel aşağıya kaydırıyoruz.
              bottom: size * 0.5 - 2,
              child: Container(
                width: 4, // Kalınlık
                height: needleLength, // İbre uzunluğu
                decoration: BoxDecoration(
                  color: needleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                // İbrenin döndürülme merkezi kendi alt merkezinde
                transformAlignment: Alignment.bottomCenter,
              ),
            ),

            // Merkezi Daire (Düğme) - Tam merkezde kalmalı
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: needleColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double gaugeSize = 300;

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
            onPressed: () { /* Skip */ },
            child: const Text('Skip', style: TextStyle(color: Colors.grey, fontSize: 16)),
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

            // 1. Başlık Metni
            const Text(
              'What is your ',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: darkGreen),
            ),
            Text(
              'activity level?',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
            ),

            const SizedBox(height: 8.0),

            // 2. Açıklama Metni
            const Text(
              'We will use this data to give you a better diet type for you',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 48.0),

            // 3. Renkli Gösterge (Gauge) Alanı
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // GÖRSEL: Renkli Yarım Daire Arkaplanı
                  Image.asset(
                    'assets/images/gauge_background.png', // Lütfen bu görseli ekleyin.
                    width: gaugeSize,
                    fit: BoxFit.contain,
                  ),

                  // İbre (Düzgün Konumlandırılmış)
                  _buildGaugeNeedle(gaugeSize, _activityLevel),

                  // İbreyi Dokunarak Ayarlamak İçin Şeffaf Slider
                  Container(
                    width: gaugeSize * 0.9,
                    height: gaugeSize * 0.5,
                    alignment: Alignment.bottomCenter,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 1.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                      ),
                      child: Slider(
                        value: _activityLevel,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (newValue) {
                          setState(() {
                            _activityLevel = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Next Butonu
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoalScreen(), // Yeni sayfanızın adı
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