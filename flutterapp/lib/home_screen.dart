import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'widgets/profile_switch_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  
  // Track selected poll options for each post
  Map<String, String?> selectedPollOptions = {};

  // Mock data for posts
  final List<Map<String, dynamic>> posts = [
    {
      'clubName': 'Debate Club',
      'clubAvatar': Icons.mic_rounded,
      'timeAgo': '1d',
      'type': 'event',
      'title': 'Meet Diana Valente Barker',
      'description': 'Meet Diana Valente Barker, a passionate Brazilian music lover and nutrition student! 🎵🎶 Her vibrant spirit shines through her love for dance, calm melodies, and creating lasting memories.',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'eventDate': 'July 28, 2025',
      'eventTime': '18:30',
      'avatarColor': Color(0xFF3B82F6),
    },
    {
      'clubName': 'Basketball Club',
      'clubAvatar': Icons.sports_basketball_rounded,
      'timeAgo': '2h',
      'type': 'text',
      'title': 'Training Session This Friday!',
      'description': 'Don\'t miss our intensive basketball training session this Friday at 6 PM. We\'ll be working on defensive strategies and free throws. Bring your A-game! 🏀',
      'avatarColor': Color(0xFFFF6B35),
    },
    {
      'clubName': 'Photography Club',
      'clubAvatar': Icons.camera_alt_rounded,
      'timeAgo': '4h',
      'type': 'image',
      'title': 'Golden Hour Workshop',
      'description': 'Captured some amazing shots during our golden hour workshop last weekend. Check out these stunning landscapes! 📸',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'avatarColor': Color(0xFF10B981),
    },
    {
      'clubName': 'Music Society',
      'clubAvatar': Icons.music_note_rounded,
      'timeAgo': '6h',
      'type': 'poll',
      'title': 'What should be our next performance?',
      'description': 'Help us choose our next performance piece! Vote for your favorite option below.',
      'pollOptions': [
        {'option': 'Classical Symphony', 'votes': 42, 'percentage': 0.6},
        {'option': 'Jazz Ensemble', 'votes': 28, 'percentage': 0.4},
      ],
      'totalVotes': 70,
      'avatarColor': Color(0xFF8B5CF6),
    },
    {
      'clubName': 'Coding Club',
      'clubAvatar': Icons.code_rounded,
      'timeAgo': '8h',
      'type': 'text',
      'title': 'Hackathon Results',
      'description': 'Congratulations to all participants in our weekend hackathon! The creativity and technical skills demonstrated were incredible. Winners will be announced soon! 💻⚡',
      'avatarColor': Color(0xFFF59E0B),
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          const ProfileSwitchButton(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF3B82F6),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
           
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_isRefreshing && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    );
                  }
                  
                  final adjustedIndex = _isRefreshing ? index - 1 : index;
                  if (adjustedIndex >= posts.length) return null;
                  
                  final post = posts[adjustedIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _buildPostCard(post),
                  );
                },
                childCount: _isRefreshing ? posts.length + 1 : posts.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Space for bottom navigation
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildPostHeader(post),
          
          // Post Content
          if (post['type'] == 'event') _buildEventContent(post)
          else if (post['type'] == 'text') _buildTextContent(post)
          else if (post['type'] == 'image') _buildImageContent(post)
          else if (post['type'] == 'poll') _buildPollContent(post),
          
         
        ],
      ),
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: post['avatarColor'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              post['clubAvatar'],
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['clubName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  post['timeAgo'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventContent(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post['image'] != null)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(post['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post['description'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              if (post['eventDate'] != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${post['eventDate']} at ${post['eventTime']}',
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextContent(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['description'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildImageContent(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post['description'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(post['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPollContent(Map<String, dynamic> post) {
    final String postId = '${post['clubName']}_${post['title']}'; // Unique post identifier
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['description'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ...post['pollOptions'].map<Widget>((option) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: _buildPollOption(
                postId,
                option['option'],
                option['votes'],
                option['percentage'],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          Text(
            '${post['totalVotes']} votes',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPollOption(String postId, String option, int votes, double percentage) {
    final bool isSelected = selectedPollOptions[postId] == option;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPollOptions[postId] = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
            ? Border.all(color: const Color(0xFF3B82F6), width: 2)
            : null,
        ),
        child: Stack(
          children: [
            // Background progress bar
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF3B82F6).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            // Text overlay
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (isSelected) ...[
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF3B82F6) : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${(percentage * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}

