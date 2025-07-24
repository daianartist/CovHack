import 'package:flutter/material.dart';

class ClubNotificationsScreen extends StatefulWidget {
  const ClubNotificationsScreen({super.key});

  @override
  State<ClubNotificationsScreen> createState() => _ClubNotificationsScreenState();
}

class _ClubNotificationsScreenState extends State<ClubNotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Event: AI Workshop',
      'message': 'Join us for an exciting AI workshop this weekend!',
      'time': '2 hours ago',
      'type': 'event',
      'isRead': false,
    },
    {
      'title': 'Membership Approved',
      'message': 'Your membership to Tech Club has been approved!',
      'time': '5 hours ago',
      'type': 'membership',
      'isRead': false,
    },
    {
      'title': 'Event Update: CovHack 2024',
      'message': 'Location changed for the hackathon event.',
      'time': '1 day ago',
      'type': 'update',
      'isRead': true,
    },
    {
      'title': 'New Post in Data Science Club',
      'message': 'Check out the latest research findings shared by Dr. Smith.',
      'time': '2 days ago',
      'type': 'post',
      'isRead': true,
    },
    {
      'title': 'Reminder: Meeting Tomorrow',
      'message': 'Don\'t forget about tomorrow\'s club meeting at 3 PM.',
      'time': '3 days ago',
      'type': 'reminder',
      'isRead': true,
    },
  ];

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
          'Club Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read, color: Colors.blue),
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification['isRead'] = true;
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification, index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    IconData getNotificationIcon(String type) {
      switch (type) {
        case 'event':
          return Icons.event;
        case 'membership':
          return Icons.group_add;
        case 'update':
          return Icons.update;
        case 'post':
          return Icons.article;
        case 'reminder':
          return Icons.notifications;
        default:
          return Icons.notifications;
      }
    }

    Color getNotificationColor(String type) {
      switch (type) {
        case 'event':
          return Colors.blue;
        case 'membership':
          return Colors.green;
        case 'update':
          return Colors.orange;
        case 'post':
          return Colors.purple;
        case 'reminder':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead'] ? Colors.grey[200]! : Colors.blue.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: getNotificationColor(notification['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            getNotificationIcon(notification['type']),
            color: getNotificationColor(notification['type']),
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'],
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: !notification['isRead']
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          setState(() {
            notification['isRead'] = true;
          });
          _showNotificationDetails(notification);
        },
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            notification['title'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['message'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (notification['type'] == 'event')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to event details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Event'),
              ),
          ],
        );
      },
    );
  }
}
