import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  // User registration
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
      throw Exception('Registration error: ${response.body}');
    }
  }

  // User login
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
      throw Exception('Login error: ${response.body}');
    }
  }

  // Get clubs list (example of protected request)
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
      throw Exception('Error getting clubs: ${response.body}');
    }
  }

  // Get user's clubs where they are moderator
  Future<List<dynamic>> getUserClubs() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/clubs/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error getting user clubs: ${response.body}');
    }
  }

  // Get posts for a specific club
  Future<List<dynamic>> getClubPosts(int clubId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/clubs/$clubId/posts/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error getting club posts: ${response.body}');
    }
  }

  // Update club description
  Future<Map<String, dynamic>> updateClub(int clubId, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/clubs/$clubId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error updating club: ${response.body}');
    }
  }

  // Password reset request (send code)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Password reset error: ${response.body}');
    }
  }

  // Password reset by code
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
      throw Exception('Password reset error: ${response.body}');
    }
  }

  // Get current user
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
      throw Exception('Error getting profile: ${response.body}');
    }
  }

  // Получить список ивентов
  Future<List<dynamic>> getEvents() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/events/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка получения ивентов: ${response.body}');
    }
  }

  // Создать пост
  Future<void> createPost(int clubId, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/clubs/$clubId/posts/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка создания поста: ${response.body}');
    }
  }

  // Создать ивент
  Future<void> createEvent(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/events/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка создания ивента: ${response.body}');
    }
  }

  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Logout (remove token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}