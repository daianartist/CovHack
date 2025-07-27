import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                    // Header Image
        Container(
          width: double.infinity,
          height: 200,
          child: event.imageUrl != null && event.imageUrl!.isNotEmpty
            ? Image.network(
                'http://localhost:8000${event.imageUrl}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              )
            : Image.network(
                'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-SJUtoF2l3LlpUsvNH1srr25P0F8g2w.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(0xFF1E3A8A),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BE HEARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'DEBATE CLUB',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title and Details
                  Text(
                    'Debate Event',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monday 16:00',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8F9BB3),
                        ),
                      ),
                      Text(
                        'Points XP',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8F9BB3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Invite Friend Button
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1877F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Invite Friend',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // About Section
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Debate Club is an association of people who want to improve their public speaking, argumentation and critical thinking skills. Club members believe that at the beginning of a debate, they gradually expand on different points of view using logical arguments, facts and...',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF222B45),
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Read more', style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.w500)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  SizedBox(height: 80), // space for fixed button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1877F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}