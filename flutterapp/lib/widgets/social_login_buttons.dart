import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          icon: Icons.facebook,
          color: const Color(0xFF1877F2),
          onPressed: () {
            // Handle Facebook login
          },
        ),
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          color: const Color(0xFFDB4437),
          onPressed: () {
            // Handle Google login
          },
        ),
        _buildSocialButton(
          icon: Icons.apple,
          color: Colors.black,
          onPressed: () {
            // Handle Apple login
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}