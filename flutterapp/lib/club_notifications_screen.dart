import 'package:flutter/material.dart';
import 'screens/webview_screen.dart';

class ClubNotificationsScreen extends StatefulWidget {
  const ClubNotificationsScreen({super.key});

  @override
  State<ClubNotificationsScreen> createState() => _ClubNotificationsScreenState();
}

class _ClubNotificationsScreenState extends State<ClubNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock data for applicants
  final List<Map<String, dynamic>> applicants = [
    {
      'name': 'Arapbekova Daiana',
      'timeAgo': '34 Minutes ago',
      'avatar': 'AD',
      'status': 'pending',
      'message': 'Hi! I\'m really passionate about basketball and would love to join your club. I have 3 years of experience playing in school teams.',
    },
    {
      'name': 'Aigerim Kenzhebekova',
      'timeAgo': '15 Minutes ago',
      'avatar': 'AK',
      'status': 'pending',
      'message': 'Hello! I\'m interested in joining the basketball club. I play regularly and am excited to be part of a team.',
    },
    {
      'name': 'Aidar Zhumagulov',
      'timeAgo': '52 Minutes ago',
      'avatar': 'AZ',
      'status': 'pending',
      'message': 'I would like to join your basketball club. I have been playing for 2 years and am very dedicated.',
    },
    {
      'name': 'Gulmira Tursynbaeva',
      'timeAgo': '35 Minutes ago',
      'avatar': 'GT',
      'status': 'pending',
      'message': 'Hi! I\'m a beginner but very enthusiastic about learning basketball. Hope to join your team!',
    },
    {
      'name': 'Nurlan Abilkhanov',
      'timeAgo': '24 Minutes ago',
      'avatar': 'NA',
      'status': 'pending',
      'message': 'Hello! I have experience playing basketball in high school and would love to continue playing in university.',
    },
  ];

  // Mock data for general notifications
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Event: Basketball Tournament',
      'message': 'Your tournament has been approved and published',
      'timeAgo': '1 hour ago',
      'type': 'event',
      'icon': Icons.emoji_events_rounded,
      'color': Colors.amber,
    },
    {
      'title': 'Post Liked',
      'message': 'Your post about training session received 15 new likes',
      'timeAgo': '2 hours ago',
      'type': 'like',
      'icon': Icons.favorite_rounded,
      'color': Colors.red,
    },
    {
      'title': 'New Member Joined',
      'message': 'Sarah Johnson has joined your club',
      'timeAgo': '3 hours ago',
      'type': 'member',
      'icon': Icons.person_add_rounded,
      'color': Colors.green,
    },
    {
      'title': 'Event Reminder',
      'message': 'Training Session starts in 2 hours',
      'timeAgo': '4 hours ago',
      'type': 'reminder',
      'icon': Icons.schedule_rounded,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Mark all as read
              _markAllAsRead();
            },
            icon: const Icon(Icons.done_all_rounded, color: Colors.grey),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF3B82F6),
          indicatorWeight: 3,
          labelColor: const Color(0xFF3B82F6),
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Applications'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${applicants.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApplicationsTab(),
          _buildAllNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applicants.length,
      itemBuilder: (context, index) {
        final applicant = applicants[index];
        return _buildApplicationCard(applicant, index);
      },
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> applicant, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      applicant['avatar'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        applicant['timeAgo'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Application message preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                applicant['message'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                // Reject button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _rejectApplication(index);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    label: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Accept button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _acceptApplication(index);
                    },
                    icon: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // View details button
                GestureDetector(
                  onTap: () {
                    _viewApplicationDetails(applicant);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.visibility_rounded,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification['timeAgo'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: notification['color'],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _acceptApplication(int index) {
    setState(() {
      applicants.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Application accepted!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _rejectApplication(int index) {
    setState(() {
      applicants.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Application rejected'),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _viewApplicationDetails(Map<String, dynamic> applicant) {
    // Открываем WebViewScreen с ответами на Google форму
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewScreen(
          url: 'https://docs.google.com/forms/d/e/1FAIpQLSdoUw7-EYhFe2skW15Wdtlyx8cDfQZtccYiRz4yfB7l3CUJzQ/viewanalytics',
          title: 'Ответы на форму',
        ),
      ),
    );
    // Если нужно оставить старый bottom sheet, закомментируй этот блок и раскомментируй ниже
    // showModalBottomSheet(...)
  }

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
