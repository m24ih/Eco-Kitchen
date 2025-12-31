import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod ekle
import 'package:eco_kitchen/core/providers/onboarding_provider.dart'; // 2. Provider'ı ekle
import 'package:eco_kitchen/screens/tall.dart';

// Ana renk kodlarımız
const Color primaryGreen = Color(0xFF9DB67B);
const Color lightGrey = Color(0xFFEFEFEF);
const Color darkGreen = Color(0xFF38463B);

class BirthDayScreen extends ConsumerStatefulWidget {
  @override
  _BirthDayScreenState createState() => _BirthDayScreenState();
}

class _BirthDayScreenState extends ConsumerState<BirthDayScreen> {
  // Varsayılan olarak bugünün tarihini alabiliriz.
  DateTime? _selectedDate;

  // Kullanıcının yaşını hesaplamak için
  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    // Eğer doğum günü henüz geçmediyse, yaşı 1 azalt
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Tarih seçiciyi açan fonksiyon
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000), // Başlangıç tarihi
      firstDate: DateTime(1900), // Seçilebilecek en eski tarih
      lastDate: DateTime.now(), // Seçilebilecek en yeni tarih (bugün)
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen, // Başlık ve seçili gün rengi
              onPrimary: Colors.white,
              surface: Colors.white, // Takvim arka planı
              onSurface: Colors.black, // Takvim metin rengi
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Yaş hesaplaması, eğer tarih seçilmişse
    final int? age = _selectedDate != null ? _calculateAge(_selectedDate!) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Sol Geri Butonu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // Sağ Skip Butonu
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // TODO: Kayıt akışını atlama
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32.0),

            // 1. Başlık Metni
            Row(
              children: [
                const Text(
                  'Your ',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: darkGreen),
                ),
                Text(
                  'date of birth',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // 2. Açıklama Metni
            const Text(
              'We will use this data to give you a better diet type for you',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 48.0),

            // 3. Büyük Yaş Kartı (Eğer tarih seçilmişse yaşı gösterir, yoksa boş)
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(15.0),
              ),
              alignment: Alignment.center,
              child: Text(
                age != null ? age.toString() : '—', // Yaş varsa göster, yoksa tire
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // 4. Tarih Seçme Alanı
            GestureDetector(
              onTap: () => _selectDate(context), // Tıklandığında tarih seçici açılır
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? 'February / 20 / 1999' // Varsayılan yer tutucu metin
                          : '${_selectedDate!.month.toString().padLeft(2, '0')} / ${_selectedDate!.day.toString().padLeft(2, '0')} / ${_selectedDate!.year}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: primaryGreen),
                  ],
                ),
              ),
            ),

            const Spacer(), // İleri butonunu en alta iter

            // 5. Next Butonu
            ElevatedButton(
              onPressed: age != null ? () {
                if (_selectedDate != null) {
                 ref.read(onboardingProvider.notifier).setBirthDate(_selectedDate!);
                   }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Yeni sayfanızı buraya yönlendiriyoruz
                    builder: (context) => TallScreen(),
                  ),
                );
              } : null, // Yaş seçilmemişse butonu devre dışı bırakır (null)
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