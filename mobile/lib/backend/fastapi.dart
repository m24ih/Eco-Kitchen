import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FastAPI {
  final Dio _dio;

  FastAPI(this._dio);

  // --- AUTH ---
  Future<dynamic> register(String email, String password, String fullName) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      // FastAPI OAuth2PasswordRequestForm form-data bekler
      final formData = FormData.fromMap({
        'username': email,
        'password': password,
      });

      final response = await _dio.post('/auth/login', data: formData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> getUserProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // Token'ı sil
  }


  // --- INVENTORY (STOK) FONKSİYONLARI ---

  // 1. Listeleme
  Future<List<dynamic>> getInventory() async {
    try {
      final response = await _dio.get('/inventory/');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 2. Ekleme
  Future<dynamic> addInventoryItem(String name, double quantity, String unit) async {
    try {
      final response = await _dio.post('/inventory/', data: {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 3. Silme
  Future<void> deleteInventoryItem(int id) async {
    try {
      await _dio.delete('/inventory/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- HATA YÖNETİMİ ---
  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Backend'den gelen hata mesajını al
        final detail = error.response?.data['detail'];
        if (detail != null) return detail.toString();
      }
      return "Sunucu bağlantı hatası: ${error.message}";
    }
    return "Beklenmeyen bir hata oluştu.";
  }
}