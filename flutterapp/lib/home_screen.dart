import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'widgets/profile_switch_button.dart';
import 'services/api_service.dart';
import 'event_account_screen.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  bool _isLoading = true;

  List<dynamic> posts = [];
  List<dynamic> events = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    setState(() => _isLoading = true);
    try {
      final clubs = await _apiService.getClubs();
      List<dynamic> allPosts = [];

      for (var club in clubs) {
        final clubPosts = await _apiService.getClubPosts(club['id']);
        for (var post in clubPosts) {
          post['clubId'] = club['id'];
          post['clubName'] = club['name'];
          post['clubDescription'] = club['description'];
          post['clubMembers'] = club['members'];
          post['type'] = 'post';
        }
        allPosts.addAll(clubPosts);
      }

      final allEvents = await _apiService.getEvents();
      for (var ev in allEvents) {
        ev['type'] = 'event';
      }

      setState(() {
        posts = allPosts;
        events = allEvents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> combinedFeed = [...events, ...posts];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF3B82F6),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : combinedFeed.isEmpty
                ? const Center(child: Text('Нет постов и ивентов'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: combinedFeed.length,
                    itemBuilder: (context, index) {
                      final item = combinedFeed[index];
                      if (item['type'] == 'event') {
                        return _buildEventCard(item);
                      } else {
                        return _buildPostCard(item);
                      }
                    },
                  ),
      ),
    );
  }

  // ======== Посты ======== //
  Widget _buildPostCard(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventAccountScreen(
              club: {
                'id': post['clubId'],
                'name': post['clubName'],
                'description': post['clubDescription'],
                'members': post['clubMembers'],
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['clubName'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              post['title'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(post['description'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  // ======== Ивенты ======== //
  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: event['id'])),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['name'] ?? 'Event',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(event['description'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 6),
            Text(event['date'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}