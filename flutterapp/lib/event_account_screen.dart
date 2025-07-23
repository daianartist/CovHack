import 'package:flutter/material.dart';

class EventAccountScreen extends StatelessWidget {
  const EventAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Event Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF8B7CB6),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Debate Club',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Public club • 120 members',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Debate Club is a place for students to improve their public speaking, argumentation, and critical thinking skills. Join us for weekly debates and workshops!',
                style: TextStyle(fontSize: 15, color: Color(0xFF222B45)),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: Color(0xFF4A90E2)),
                  label: const Text('Share', style: TextStyle(color: Color(0xFF4A90E2))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A90E2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          
            // Posts Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            // Post 1: With images
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1h', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text(
                    'Meet Diana Valente Barker, a passionate Brazilian music lover and nutrition student! 💫🎶 Her vibrant spirit shines through her love for dance, calm melodies, and creating lasting memories. Follow her journey filled with music and inspiration! 💕🎵',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _PostImageCarousel(),
                  const SizedBox(height: 16),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Events name', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _PollPost(),
          ],
        ),
      ),
    );
  }
}

class _PostImageCarousel extends StatefulWidget {
  @override
  State<_PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<_PostImageCarousel> {
  int _currentPage = 0;
  final List<String> _images = [
    'assets/event_post.png',
    'assets/event_post.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: _images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (i) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == _currentPage ? Colors.blue : Colors.grey[300],
            ),
          )),
        ),
      ],
    );
  }
} 

class _PollPost extends StatefulWidget {
  @override
  State<_PollPost> createState() => _PollPostState();
}

class _PollPostState extends State<_PollPost> {
  int? _selected;
  bool _voted = false;
  final List<String> _options = ['zxc', 'zxc', 'dxc'];
  final List<int> _votes = [5, 5, 2];

  int get _totalVotes => _votes.reduce((a, b) => a + b);

  void _onVote(int i) {
    if (_voted) return;
    setState(() {
      _selected = i;
      _votes[i]++;
      _voted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('2h', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          const Text(
            'Просим вас пройти опрос на тему: какую одежду мне завтра надеть?',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('dsf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                for (int i = 0; i < _options.length; i++) ...[
                  GestureDetector(
                    onTap: !_voted ? () => _onVote(i) : null,
                    child: _buildPollOption(
                      _options[i],
                      _totalVotes == 0 ? 0 : _votes[i] / _totalVotes,
                      _selected == i,
                      _voted,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text('${_totalVotes} vote${_totalVotes == 1 ? '' : 's'}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPollOption(String text, double percent, bool isSelected, bool voted) {
  return Row(
    children: [
      Expanded(
        child: Stack(
          children: [
            Container(
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: voted ? percent : 0,
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (isSelected && voted)
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
    ],
  );
} 