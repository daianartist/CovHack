import 'package:flutter/material.dart';
import 'widgets/profile_switch_button.dart';
import 'create_post_screen.dart';
import 'create_event_screen.dart';
import 'club_notifications_screen.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({super.key});

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180, // Уменьшенная высота
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                const ProfileSwitchButton(),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      // Уведомления
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClubNotificationsScreen(),
                        ),
                      );
                    },
                    icon: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        // Notification badge
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo_covuni.png'), // Фоновое изображение
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Image (слева) с возможностью редактирования
                                GestureDetector(
                                  onTap: _showEditPhotoDialog,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.sports_basketball_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Edit icon
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B82F6),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Club Name and Description (по центру слева)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Basketball Club',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Sports & Basketball',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Stats (справа)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        _buildCompactStatColumn('23', 'Posts'),
                                        const SizedBox(width: 20),
                                        _buildCompactStatColumn('6', 'Members'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Club Description and Actions Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showEditAboutDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Basketball Club brings together passionate players and fans. Join us for tournaments, training sessions, and exciting matches throughout the semester! 🏀',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Создать пост
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreatePostScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                          label: const Text(
                            'Create Post',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Управление клубом
                          },
                          icon: const Icon(Icons.settings_rounded, color: Color(0xFF3B82F6), size: 18),
                          label: const Text(
                            'Manage',
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // President Controls
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.08),
                          Colors.orange.withOpacity(0.03),
                        ],
                      ),
                      border: Border.all(color: Colors.orange.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Colors.orange[700],
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'President Controls',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Управление сертификатами
                          },
                          icon: Icon(Icons.verified_rounded, color: Colors.orange[700], size: 16),
                          label: Text(
                            'Certificates',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.orange[300]!, width: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF3B82F6),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: const Color(0xFF3B82F6),
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Events'),
                  Tab(text: 'Statistics'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsTab(),
                  _buildEventsTab(),
                  _buildStatisticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Пост о турнире
        _buildPostCard(
          timeAgo: '2h',
          title: 'Exciting Basketball Tournament Alert! 🏆',
          content: 'Get ready for an epic showdown! Our annual basketball tournament is just around the corner. Teams from across the university will compete for the championship title.',
          hasImage: false,
        ),
        const SizedBox(height: 12),
        // Пост с изображением турнира
        _buildPostCard(
          timeAgo: '1d',
          title: 'Street Ball Tournament',
          content: 'Get ready for the ultimate Street Ball Tournament! 🏀 Top teams from all over the world',
          hasImage: true,
          imageText: 'STREET\nBALL\nTOURNA\nMENT\n\nTop 20 teams from\nall over\nthe world\n\n01-14\nJULY\n2025',
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Create Event Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEventScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              label: const Text(
                'Create New Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          
          // Events List
          Expanded(
            child: ListView(
              children: [
                _buildEventCard(
                  title: 'Basketball Tournament',
                  date: 'March 15, 2025',
                  time: '10:00 AM',
                  location: 'Sports Complex',
                  participants: 32,
                  category: 'tournament',
                  status: 'upcoming',
                ),
                const SizedBox(height: 12),
                _buildEventCard(
                  title: 'Training Session',
                  date: 'March 8, 2025',
                  time: '6:00 PM',
                  location: 'Gym Hall A',
                  participants: 18,
                  category: 'training',
                  status: 'upcoming',
                ),
                const SizedBox(height: 12),
                _buildEventCard(
                  title: 'Team Meeting',
                  date: 'February 28, 2025',
                  time: '3:00 PM',
                  location: 'Conference Room',
                  participants: 12,
                  category: 'meeting',
                  status: 'past',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String time,
    required String location,
    required int participants,
    required String category,
    required String status,
  }) {
    // Define category colors and icons
    final Map<String, Map<String, dynamic>> categoryData = {
      'tournament': {
        'color': Colors.amber,
        'icon': Icons.emoji_events_rounded,
        'label': 'Tournament',
      },
      'training': {
        'color': Colors.blue,
        'icon': Icons.fitness_center_rounded,
        'label': 'Training',
      },
      'meeting': {
        'color': Colors.green,
        'icon': Icons.groups_rounded,
        'label': 'Meeting',
      },
      'social': {
        'color': Colors.purple,
        'icon': Icons.celebration_rounded,
        'label': 'Social',
      },
    };

    final categoryInfo = categoryData[category] ?? categoryData['meeting']!;
    final isUpcoming = status == 'upcoming';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUpcoming 
                        ? const Color(0xFF3B82F6).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUpcoming ? 'Upcoming' : 'Past',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUpcoming 
                          ? const Color(0xFF3B82F6)
                          : Colors.grey[600],
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
          
          // Event Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryInfo['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        categoryInfo['icon'],
                        color: categoryInfo['color'],
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryInfo['label'],
                            style: TextStyle(
                              fontSize: 12,
                              color: categoryInfo['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Event Details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.grey[500],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$date at $time',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.grey[500],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: Colors.grey[500],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$participants participants',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons (only for upcoming events)
          if (isUpcoming)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Edit event
                      },
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: Color(0xFF3B82F6),
                        size: 16,
                      ),
                      label: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF3B82F6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // View details
                      },
                      icon: const Icon(
                        Icons.visibility_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          if (!isUpcoming)
            const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Main Stats Row
          Row(
            children: [
              Expanded(child: _buildStatCard('Posts', '23', Icons.article_rounded, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Events', '12', Icons.event_rounded, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Members', '145', Icons.people_rounded, Colors.orange)),
            ],
          ),
          const SizedBox(height: 16),
          // Large Engagement Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 12),
                const Text(
                  '87%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Engagement Rate',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Great performance this month!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Activity Chart
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActivityItem('New member joined', '2 hours ago', Icons.person_add_rounded, Colors.green),
                _buildActivityItem('Post published', '1 day ago', Icons.article_rounded, Colors.blue),
                _buildActivityItem('Event created', '3 days ago', Icons.event_rounded, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String timeAgo,
    required String title,
    required String content,
    bool hasImage = false,
    String? imageText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.sports_basketball_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basketball Club',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.more_horiz_rounded, color: Colors.grey[600], size: 20),
                ),
              ],
            ),
          ),
          if (hasImage && imageText != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF87CEEB),
                    Color(0xFFE6F3FF),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      imageText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_basketball_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage) const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  void _showEditPhotoDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Club Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () => Navigator.pop(context),
                ),
                _buildPhotoOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () => Navigator.pop(context),
                ),
                _buildPhotoOption(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3B82F6),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditAboutDialog() {
    final TextEditingController controller = TextEditingController(
      text: 'Basketball Club brings together passionate players and fans. Join us for tournaments, training sessions, and exciting matches throughout the semester! 🏀',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit About',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your club...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Save the edited text
                setState(() {
                  // Update the about text
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
