import 'package:flutter/material.dart';
import 'screens/webview_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final String name = (widget.club['name'] ?? 'Club').toString();
    final String desc = (widget.club['description'] ?? 'No description').toString();
    final int members = int.tryParse('${widget.club['members'] ?? 0}') ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo_covuni.png'),
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
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(Icons.auto_awesome_rounded,
                                    color: Colors.white, size: 35),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 4),
                                    Text(desc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.9))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  _buildCompactStatColumn(members.toString(), 'Members'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(desc, style: const TextStyle(fontSize: 16, height: 1.5)),
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

  Widget _buildCompactStatColumn(String number, String label) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: Colors.white.withOpacity(0.9))),
      ],
    );
  }

  Widget _buildPostsTab() => const Center(child: Text('Club posts here'));
  Widget _buildEventsTab() => const Center(child: Text('Club events here'));
}