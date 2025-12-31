import 'package:dio/dio.dart';
import 'package:eco_kitchen/core/services/api_service.dart'; // Senin servis yolun
import 'package:eco_kitchen/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/core/providers/onboarding_provider.dart';

// Backend ile konuşacağı için ConsumerStatefulWidget kullanıyoruz
class RegisterScreen extends ConsumerStatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lütfen alanları doldurun")));
      return;
    }

    setState(() => _isLoading = true);

    // 1. Onboarding verilerini vagondan çek
    final onboardingData = ref.read(onboardingProvider);
    final dio = ref.read(apiServiceProvider);

    try {
      // 2. Verileri paketleyip API'ye gönder
      final response = await dio.post('/auth/register', data: {
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        // Backend'in beklediği formatta verileri ekliyoruz:
        "height": onboardingData.height ?? 170, // Varsayılan değerler (boşsa hata almamak için)
        "weight": onboardingData.weight ?? 70,
        "activity_level": onboardingData.activityLevel ?? 0.5,
        "goal": onboardingData.goal ?? "stay_healthy",
        "birth_date": onboardingData.birthDate?.toIso8601String(),
      });

      if (response.statusCode == 201) {
        // 3. Kayıt Başarılı!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kayıt Başarılı! Giriş yapılıyor...")));
          
          // İstersen burada otomatik /login isteği de atılabilir ama
          // şimdilik direkt Home'a alıyoruz.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        }
      }
    } on DioException catch (e) {
      String errorMessage = "Bir hata oluştu";
      if (e.response != null) {
        errorMessage = e.response?.data['detail']?.toString() ?? "Sunucu Hatası";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $errorMessage"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Oluştur", style: TextStyle(color: Colors.black)), 
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Son Adım!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
            SizedBox(height: 10),
            Text("Verilerinizi kaydetmek için hesap oluşturun.", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.email_outlined)
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Şifre", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.lock_outline)
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: Color(0xFF9DB67B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white) 
                  : Text("Kayıt Ol ve Başla", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
