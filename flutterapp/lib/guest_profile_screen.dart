import 'package:flutter/material.dart';
import 'auth_screen.dart';

class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
     
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 100.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Guest Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 60,
                  color: Colors.grey[400],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Welcome Text
              Text(
                'Добро пожаловать!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Войдите в свой аккаунт, чтобы получить доступ к полному функционалу приложения',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Login Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Войти в аккаунт',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Guest Continue Button
              Container(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // Здесь можно добавить функционал для продолжения как гость
                    // Например, показать ограниченную версию приложения
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Функционал ограничен для гостей'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Продолжить как гость',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Features Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'После входа в аккаунт:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      icon: Icons.event_rounded,
                      text: 'Участие в событиях',
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureRow(
                      icon: Icons.workspace_premium_rounded,
                      text: 'Получение сертификатов',
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureRow(
                      icon: Icons.leaderboard_rounded,
                      text: 'Рейтинг и достижения',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureRow(
                      icon: Icons.notifications_rounded,
                      text: 'Уведомления о событиях',
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: color,
          size: 16,
        ),
      ],
    );
  }
}
