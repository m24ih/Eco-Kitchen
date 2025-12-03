import 'package:flutter/material.dart';

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color darkGreen = Color(0xFF38463B);
const Color unselectedGrey = Color(0xFFEFEFEF);

enum GoalType { loseWeight, gainWeight, stayHealthy }

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // Seçili olan hedefi tutar
  GoalType? _selectedGoal;

  // --- Yardımcı Widget'lar ---

  // Seçenek Kartlarını Oluşturan Widget
  Widget _buildGoalCard({
    required String title,
    required GoalType goal,
    required String assetPath, // İllüstrasyon görseli
  }) {
    final isSelected = _selectedGoal == goal;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = goal;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withOpacity(0.1) : unselectedGrey, // Seçili ise açık yeşil, değilse gri
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.transparent, // Seçili ise yeşil çerçeve
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sol Taraftaki Metin
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
            ),

            const SizedBox(width: 16.0),

            // Sağ Taraftaki İllüstrasyon Görseli
            Image.asset(
              assetPath, // Lütfen bu yolu kontrol edin
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
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
              'goal?',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
            ),

            const SizedBox(height: 8.0),

            // 2. Açıklama Metni
            const Text(
              'We will use this data to give you a better diet type for you',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 48.0),

            // 3. Seçenek Kartları
            _buildGoalCard(
              title: 'Lose weight',
              goal: GoalType.loseWeight,
              assetPath: 'assets/images/goal_lose.png', // Lütfen görselleri ekleyin
            ),
            _buildGoalCard(
              title: 'Gain weight',
              goal: GoalType.gainWeight,
              assetPath: 'assets/images/goal_gain.png', // Lütfen görselleri ekleyin
            ),
            _buildGoalCard(
              title: 'Stay healthy',
              goal: GoalType.stayHealthy,
              assetPath: 'assets/images/goal_stay.png', // Lütfen görselleri ekleyin
            ),

            const Spacer(), // Next butonunu en alta iter

            // 4. Next Butonu
            ElevatedButton(
              onPressed: _selectedGoal != null ? () {
                // TODO: Ana Sayfaya veya Kayıt Başarılı sayfasına yönlendirme
              } : null, // Seçim yapılmadıysa butonu devre dışı bırak
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