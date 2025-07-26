import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRecentNotifications(),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last 7 days',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        // Notification about new event
        _buildNotificationItem(
          icon: Icons.event,
          iconColor: Colors.orange,
          title: 'New event available! 🎉',
          message: 'Join the Tech Innovation Workshop this Friday. Learn about AI and Machine Learning!',
          time: 'July 23, 18:05',
          hasMore: true,
        ),
        
        const SizedBox(height: 16),
        
        // Notification about club activity
        _buildNotificationItem(
          icon: Icons.group,
          iconColor: Colors.blue,
          title: 'Club activity update 📚',
          message: 'Debate Club has scheduled new practice sessions. Check your schedule for details!',
          time: 'July 22, 15:30',
          hasMore: true,
        ),
        
        const SizedBox(height: 16),
        
        // Notification about ranking
        _buildNotificationItem(
          icon: Icons.emoji_events,
          iconColor: Colors.amber,
          title: 'Ranking update! 🏆',
          message: 'You\'ve moved up 3 positions in the leaderboard! Keep attending events to climb higher.',
          time: 'July 21, 12:15',
          hasMore: true,
        ),
        
        const SizedBox(height: 16),
        
        // Notification about new follower
        _buildNotificationItem(
          icon: Icons.person_add,
          iconColor: Colors.green,
          title: 'New follower! 👋',
          message: 'Alex Johnson started following you after meeting at the Photography Club event.',
          time: 'July 20, 09:45',
          hasMore: false,
        ),
        
        const SizedBox(height: 16),
        
        // Notification about event reminder
        _buildNotificationItem(
          icon: Icons.access_time,
          iconColor: Colors.purple,
          title: 'Event reminder 🔔',
          message: 'Don\'t forget: Music Society concert tonight at 7 PM in the main auditorium.',
          time: 'July 19, 14:20',
          hasMore: true,
        ),
        
        const SizedBox(height: 16),
        
        // Notification about achievement
        _buildNotificationItem(
          icon: Icons.star,
          iconColor: Colors.orange,
          title: 'Achievement unlocked! ⭐',
          message: 'Congratulations! You\'ve attended 10 events this month and earned the "Event Explorer" badge.',
          time: 'July 18, 16:30',
          hasMore: false,
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool hasMore,
  }) {
    return Container(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasMore) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'More',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
