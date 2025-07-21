import 'package:flutter/material.dart';

class UniversityLogo extends StatelessWidget {
  final double size;
  
  const UniversityLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wings icon (simplified representation)
        Container(
          width: size * 0.8,
          height: size * 0.4,
          decoration: const BoxDecoration(
            color: Color(0xFF4A90E2),
          ),
          child: CustomPaint(
            painter: WingsPainter(),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // University text
        Column(
          children: [
            Text(
              'Coventry',
              style: TextStyle(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A90E2),
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'University',
              style: TextStyle(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A90E2),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..style = PaintingStyle.fill;

    // Draw simplified wings shape
    final path = Path();
    
    // Left wing
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.2, 0,
      size.width * 0.45, size.height * 0.6,
    );
    
    // Right wing
    path.moveTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.8, 0,
      size.width * 0.55, size.height * 0.6,
    );
    
    // Center connection
    path.moveTo(size.width * 0.45, size.height * 0.6);
    path.lineTo(size.width * 0.55, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.9);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}