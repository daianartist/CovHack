import 'package:flutter/material.dart';
import 'services/api_service.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isRegistered = false;
  bool _isLoading = true;
  Map<String, dynamic>? eventData;

  // Mock participants
  final List<Map<String, dynamic>> participants = [
    {'name': 'Alice Johnson', 'avatar': 'A', 'role': 'Moderator', 'color': Color(0xFF3B82F6)},
    {'name': 'Bob Smith', 'avatar': 'B', 'role': 'Participant', 'color': Color(0xFF10B981)},
    {'name': 'Carol Davis', 'avatar': 'C', 'role': 'Participant', 'color': Color(0xFFF59E0B)},
    {'name': 'David Wilson', 'avatar': 'D', 'role': 'Participant', 'color': Color(0xFFEF4444)},
    {'name': 'Emma Brown', 'avatar': 'E', 'role': 'Participant', 'color': Color(0xFF8B5CF6)},
    {'name': 'Frank Miller', 'avatar': 'F', 'role': 'Participant', 'color': Color(0xFF06B6D4)},
  ];

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final data = await ApiService().getEventDetails(widget.eventId);
      setState(() {
        eventData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки ивента: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
        ),
      );
    }

    if (eventData == null) {
      return Scaffold(
        body: Center(child: Text('Не удалось загрузить данные ивента')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.black),
              onPressed: _shareEvent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: 280,
              child: Stack(
                children: [
                  if (eventData!['image_url'] != null)
                    Image.network(
                      eventData!['image_url'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.event, size: 64, color: Colors.grey[600]),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Card
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventData!['name'] ?? 'Event',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Color(0xFF6B7280)),
                        SizedBox(width: 6),
                        Text(
                          _formatDate(eventData!['date']),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    Text(
                      'About',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      eventData!['description'] ?? 'No description available.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4B5563), height: 1.6),
                    ),

                    SizedBox(height: 24),
                    _buildEventDetails(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _toggleRegistration,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRegistered ? Color(0xFF10B981) : Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: Icon(isRegistered ? Icons.check : Icons.event_available, color: Colors.white),
            label: Text(
              isRegistered ? 'Registered' : 'Register',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(Icons.location_on, 'Location', eventData!['location'] ?? 'Not specified'),
        SizedBox(height: 12),
        _buildDetailItem(Icons.calendar_today, 'Date', _formatDate(eventData!['date'])),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF3B82F6), size: 20),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  void _shareEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event link copied to clipboard!')),
    );
  }

  void _toggleRegistration() {
    setState(() {
      isRegistered = !isRegistered;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isRegistered ? 'Registered for event!' : 'Registration cancelled')),
    );
  }
}