import 'package:flutter/material.dart';
import 'screens/webview_screen.dart';
import 'services/api_service.dart';

class EventAccountScreen extends StatefulWidget {
  final Map<String, dynamic> club;
  const EventAccountScreen({super.key, required this.club});

  @override
  State<EventAccountScreen> createState() => _EventAccountScreenState();
}

class _EventAccountScreenState extends State<EventAccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isJoined = false;
  List<dynamic> clubPosts = [];
  List<dynamic> clubEvents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchClubData();
  }

  Future<void> _fetchClubData() async {
    try {
      final api = ApiService();
      final posts = await api.getClubPosts(widget.club['id']);
      final events = await api.getClubEvents(widget.club['id']);
      setState(() {
        clubPosts = posts;
        clubEvents = events;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = (widget.club['name'] ?? 'Club').toString();
    final String desc = (widget.club['description'] ?? 'No description available').toString();
    final int members = int.tryParse('${widget.club['members'] ?? 0}') ?? 0;
    final int postsCount = clubPosts.length;
    final String? formUrl = widget.club['form_url'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo_covuni.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _buildStat(postsCount.toString(), 'Posts'),
                                    const SizedBox(width: 16),
                                    _buildStat(members.toString(), 'Members'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, height: 1.5)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (formUrl != null && formUrl.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WebViewScreen(
                                        url: formUrl, title: 'Join $name'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Форма не указана для этого клуба'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.group_add, color: Colors.white),
                            label: const Text(
                              'Join Club',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF3B82F6),
                      labelColor: const Color(0xFF3B82F6),
                      unselectedLabelColor: Colors.grey[600],
                      tabs: const [Tab(text: 'Posts'), Tab(text: 'Events')],
                    ),
                  ),
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

  Widget _buildStat(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildPostsTab() {
    if (clubPosts.isEmpty) {
      return const Center(child: Text('No posts yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubPosts.length,
      itemBuilder: (context, index) {
        final post = clubPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.group, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.club['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  Text(post['timeAgo'] ?? 'just now',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(post['title'] ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
              const SizedBox(height: 6),
              Text(post['description'] ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsTab() {
    if (clubEvents.isEmpty) {
      return const Center(child: Text('No events yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubEvents.length,
      itemBuilder: (context, index) {
        final event = clubEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
              const SizedBox(height: 6),
              Text(event['description'] ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
        );
      },
    );
  }
}