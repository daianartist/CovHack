import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> rankedUsers = [];
  bool isLoading = true;
  late AnimationController _podiumAnimationController;
  late AnimationController _userAnimationController;
  late Animation<double> _podiumAnimation;
  late Animation<double> _userAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _podiumAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _userAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Initialize animations
    _podiumAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _podiumAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _userAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _userAnimationController,
      curve: Curves.bounceOut,
    ));
    
    loadRankingData();
  }

  @override
  void dispose() {
    _podiumAnimationController.dispose();
    _userAnimationController.dispose();
    super.dispose();
  }

  Future<void> loadRankingData() async {
    try {
      // Load leaderboard data
      final leaderboardString = await rootBundle.loadString('assets/data/leaderboard.json');
      final leaderboardData = json.decode(leaderboardString);
      
      // Load users data
      final usersString = await rootBundle.loadString('assets/data/users.json');
      final usersData = json.decode(usersString);
      
      // Create a map of users for quick lookup
      Map<String, dynamic> usersMap = {};
      for (var user in usersData['users']) {
        usersMap[user['id']] = user;
      }
      
      // Combine leaderboard and user data
      List<Map<String, dynamic>> combinedData = [];
      for (var ranking in leaderboardData['leaderboard']['rankings']) {
        var user = usersMap[ranking['userId']];
        if (user != null) {
          combinedData.add({
            'rank': ranking['rank'],
            'name': user['name'],
            'points': ranking['points'],
            'change': ranking['change'],
            'achievements': ranking['achievements'],
            'avatar': user['avatar'],
            'country': user['country'],
            'countryFlag': user['countryFlag'] ?? _getCountryFlag(user['country']),
            'avatarColor': user['avatarColor'] ?? _getRandomColor(),
          });
        }
      }
      
      setState(() {
        rankedUsers = combinedData;
        isLoading = false;
      });
      
      // Start animations after data is loaded
      _podiumAnimationController.forward();
      Future.delayed(Duration(milliseconds: 500), () {
        _userAnimationController.forward();
      });
    } catch (e) {
      print('Error loading ranking data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getCountryFlag(String countryCode) {
    Map<String, String> flags = {
      'PT': '🇵🇹',
      'FR': '🇫🇷', 
      'CA': '🇨🇦',
      'IN': '🇮🇳',
      'IT': '🇮🇹',
      'DE': '🇩🇪',
      'KZ': '🇰🇿',
      'BR': '🇧🇷',
    };
    return flags[countryCode] ?? '🌍';
  }

  Color _getRandomColor() {
    List<Color> colors = [
      Color(0xFFE91E63),
      Color(0xFF4CAF50), 
      Color(0xFF9C27B0),
      Color(0xFF2196F3),
      Color(0xFFFF9800),
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Rating',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<Map<String, dynamic>> topThree = rankedUsers.take(3).toList();
    List<Map<String, dynamic>> otherRanks = rankedUsers.skip(3).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rating',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            
            // Podium Section
            if (topThree.length >= 3)
              AnimatedBuilder(
                animation: _podiumAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _podiumAnimation.value,
                    child: Container(
                      height: 400,
                      child: Stack(
                        children: [
                          // Podium Base
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // 2nd Place Podium
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 800),
                                      curve: Curves.elasticOut,
                                      height: 120 * _podiumAnimation.value,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // 1st Place Podium
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.elasticOut,
                                      height: 160 * _podiumAnimation.value,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                            fontSize: 64,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // 3rd Place Podium
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 600),
                                      curve: Curves.elasticOut,
                                      height: 100 * _podiumAnimation.value,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF42A5F5), Color(0xFF2196F3)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // User Avatars and Info
                          ...topThree.map((user) => _buildPodiumUser(user, context)).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            
            SizedBox(height: 30),
            
            // Other Rankings
            if (otherRanks.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: otherRanks.map((user) => _buildRankingItem(user)).toList(),
                ),
              ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumUser(Map<String, dynamic> user, BuildContext context) {
    double leftPosition;
    double bottomPosition;
    
    switch (user['rank']) {
      case 1:
        leftPosition = MediaQuery.of(context).size.width / 2 - 40;
        bottomPosition = 200;
        break;
      case 2:
        leftPosition = MediaQuery.of(context).size.width / 6 - 40;
        bottomPosition = 160;
        break;
      case 3:
        leftPosition = MediaQuery.of(context).size.width * 5 / 6 - 40;
        bottomPosition = 140;
        break;
      default:
        leftPosition = 0;
        bottomPosition = 0;
    }

    return AnimatedBuilder(
      animation: _userAnimation,
      builder: (context, child) {
        return Positioned(
          left: leftPosition,
          bottom: bottomPosition + (50 * (1 - _userAnimation.value)),
          child: Transform.scale(
            scale: _userAnimation.value,
            child: Opacity(
              opacity: _userAnimation.value,
              child: Column(
                children: [
                  // Crown for 1st place
                  if (user['rank'] == 1)
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD700),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  
                  // User Avatar
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _parseColor(user['avatarColor']),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: user['avatar'] != null && user['avatar'].toString().startsWith('http')
                              ? Image.network(
                                  user['avatar'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildAvatarFallback(user['name']);
                                  },
                                )
                              : _buildAvatarFallback(user['name']),
                        ),
                      ),
                      
                      // Country Flag
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            user['countryFlag'] ?? '🌍',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  // User Name
                  Text(
                    user['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Points Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${user['points']} QP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankingItem(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${user['rank']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // User Avatar
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _parseColor(user['avatarColor']),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: user['avatar'] != null && user['avatar'].toString().startsWith('http')
                      ? Image.network(
                          user['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildAvatarFallback(user['name']);
                          },
                        )
                      : _buildAvatarFallback(user['name']),
                ),
              ),
              
              // Country Flag
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    user['countryFlag'] ?? '🌍',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(width: 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${user['points']} points',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Change indicator
          if (user['change'] != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user['change'].toString().startsWith('+') 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user['change'],
                style: TextStyle(
                  fontSize: 12,
                  color: user['change'].toString().startsWith('+') 
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return _getRandomColor();
    
    if (colorValue is String) {
      // Parse hex color string like "#5B9BD5"
      String colorString = colorValue.replaceAll('#', '');
      return Color(int.parse('FF$colorString', radix: 16));
    }
    
    return _getRandomColor();
  }
}