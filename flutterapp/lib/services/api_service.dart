import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  // Регистрация пользователя
  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      return data;
    } else {
      throw Exception('Ошибка регистрации: ${response.body}');
    }
  }

  // Логин пользователя
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      return data;
    } else {
      throw Exception('Ошибка входа: ${response.body}');
    }
  }

  // Получить список клубов (пример защищённого запроса)
  Future<List<dynamic>> getClubs() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/clubs/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка получения клубов: ${response.body}');
    }
  }

  // Запрос на сброс пароля (отправка кода)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка сброса пароля: ${response.body}');
    }
  }

  // Сброс пароля по коду
  Future<void> resetPassword(String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'new_password': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка сброса пароля: ${response.body}');
    }
  }

  // Получить текущего пользователя
  Future<Map<String, dynamic>> getMe() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка получения профиля: ${response.body}');
    }
  }

  // Сохранить токен в SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Получить токен из SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Выйти (удалить токен)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // Upload event image
  Future<String?> uploadEventImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/event-image'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['image_url'];
    } else {
      final errorData = await response.stream.bytesToString();
      throw Exception('Failed to upload image: $errorData');
    }
  }

  // Upload club image
  Future<String?> uploadClubImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/club-image'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['image_url'];
    } else {
      final errorData = await response.stream.bytesToString();
      throw Exception('Failed to upload image: $errorData');
    }
  }

  // Save image URL to event
  Future<bool> saveEventImage(int eventId, String imageUrl) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token');

    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId/image'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'image_url': imageUrl,
      }),
    );

    return response.statusCode == 200;
  }

  // Save image URL to club
  Future<bool> saveClubImage(int clubId, String imageUrl) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token');

    final response = await http.put(
      Uri.parse('$baseUrl/clubs/$clubId/image'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'image_url': imageUrl,
      }),
    );

    return response.statusCode == 200;
  }

  // Create event with image (combined endpoint)
  Future<Map<String, dynamic>> createEventWithImage(Map<String, dynamic> eventData, File? imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('No authentication token');

    // Upload image first if provided
    if (imageFile != null) {
      final imageUrl = await uploadEventImage(imageFile);
      if (imageUrl != null) {
        eventData['image_url'] = imageUrl;
      }
    }

    final response = await http.post(
      Uri.parse('$baseUrl/events/with-image'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(eventData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create event: ${response.body}');
    }
  }
}