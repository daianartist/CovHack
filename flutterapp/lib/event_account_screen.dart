import 'package:flutter/material.dart';

class EventAccountScreen extends StatefulWidget {
  const EventAccountScreen({super.key});

  @override
  State<EventAccountScreen> createState() => _EventAccountScreenState();
}

class _EventAccountScreenState extends State<EventAccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // только Posts и Events
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
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
             
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
                                // Profile Image (слева)
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
                                          colors: [Color(0xFF8B7CB6), Color(0xFF6B5B95)],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Club Name and Description (по центру слева)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Debate Club',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Public speaking & debates',
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
                                        _buildCompactStatColumn('342', 'Members'),
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
              padding: const EdgeInsets.all(20),
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
                    'Debate Club is a place for students to improve their public speaking, argumentation, and critical thinking skills. Join us for weekly debates and workshops!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isJoined = !_isJoined;
                            });
                          },
                          icon: Icon(
                            _isJoined ? Icons.check_rounded : Icons.group_add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            _isJoined ? 'Joined' : 'Join Club',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isJoined ? Colors.green : const Color(0xFF3B82F6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      
                    ],
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
          title: 'Meet Diana Valente Barker',
          content: 'Meet Diana Valente Barker, a passionate Brazilian music lover and nutrition student! 💫🎶 Her vibrant spirit shines through her love for dance, calm melodies, and creating lasting memories.',
          hasImage: true,
        ),
        const SizedBox(height: 12),
        
        // Пост с опросом
        _buildPollPost(),
      ],
    );
  }

  Widget _buildEventsTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          _buildEventCard(
            title: 'Debate Championship 2025',
            date: 'March 15, 2025',
            time: '10:00 AM',
            location: 'Main Auditorium',
            participants: 45,
            category: 'tournament',
            status: 'upcoming',
          ),
          const SizedBox(height: 12),
          _buildEventCard(
            title: 'Public Speaking Workshop',
            date: 'March 8, 2025',
            time: '2:00 PM',
            location: 'Room 204',
            participants: 25,
            category: 'workshop',
            status: 'upcoming',
          ),
          const SizedBox(height: 12),
          _buildEventCard(
            title: 'Debate Practice Session',
            date: 'February 28, 2025',
            time: '4:00 PM',
            location: 'Conference Room',
            participants: 18,
            category: 'practice',
            status: 'past',
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
                    Icons.auto_awesome_rounded,
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
                        'Debate Club',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (hasImage)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/event_post.png'),
                  fit: BoxFit.cover,
                ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
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

  Widget _buildPollPost() {
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
                    Icons.auto_awesome_rounded,
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
                        'Debate Club',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '3h',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Which debate topic interests you most?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Poll options
                _buildPollOption('Technology Ethics', 45, 100),
                const SizedBox(height: 8),
                _buildPollOption('Climate Change', 35, 100),
                const SizedBox(height: 8),
                _buildPollOption('Social Media Impact', 20, 100),
                
                const SizedBox(height: 16),
                Text(
                  '32 votes • Poll ends in 2 days',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollOption(String option, int votes, int totalVotes) {
    final percentage = (votes / totalVotes * 100).round();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
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
      'workshop': {
        'color': Colors.blue,
        'icon': Icons.school_rounded,
        'label': 'Workshop',
      },
      'practice': {
        'color': Colors.green,
        'icon': Icons.fitness_center_rounded,
        'label': 'Practice',
      },
    };

    final categoryInfo = categoryData[category] ?? categoryData['practice']!;
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryInfo['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    categoryInfo['label'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: categoryInfo['color'],
                    ),
                  ),
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
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
          
          // Action Button (only for upcoming events)
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Join event
                  },
                  icon: const Icon(
                    Icons.event_available_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Join Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          
          if (!isUpcoming)
            const SizedBox(height: 16),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

} 