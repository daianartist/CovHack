import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  print('Testing imports...');
  
  // Тест http
  try {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(uri);
    print('HTTP request successful: ${response.statusCode}');
  } catch (e) {
    print('HTTP error: $e');
  }
  
  // Тест shared_preferences
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('test', 'value');
    final value = prefs.getString('test');
    print('SharedPreferences successful: $value');
  } catch (e) {
    print('SharedPreferences error: $e');
  }
}
