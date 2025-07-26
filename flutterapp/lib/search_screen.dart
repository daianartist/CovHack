import 'package:flutter/material.dart';
import 'event_account_screen.dart';
import 'notifications_screen.dart';
import 'widgets/profile_switch_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Все';
  
  final List<String> _categories = [
    'Все',
    'Спорт',
    'Искусство',
    'Наука',
    'Технологии',
    'Музыка',
    'Дебаты',
    'Языки',
  ];

  final List<Map<String, dynamic>> _clubs = [
    {
      'name': 'Debate Club',
      'category': 'Дебаты',
      'members': 342,
      'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-SJUtoF2l3LlpUsvNH1srr25P0F8g2w.png',
      'color': Color(0xFF1E3A8A),
      'description': 'Клуб дебатов и публичных выступлений',
      'isJoined': false,
    },
    {
      'name': 'Tech Innovators',
      'category': 'Технологии',
      'members': 156,
      'image': null,
      'color': Color(0xFF059669),
      'description': 'Инновации и новые технологии',
      'isJoined': true,
    },
    {
      'name': 'Music Society',
      'category': 'Музыка',
      'members': 234,
      'image': null,
      'color': Color(0xFFDC2626),
      'description': 'Музыкальное общество университета',
      'isJoined': false,
    },
    {
      'name': 'Art & Design',
      'category': 'Искусство',
      'members': 189,
      'image': null,
      'color': Color(0xFF7C3AED),
      'description': 'Творчество и дизайн',
      'isJoined': false,
    },
    {
      'name': 'Sports Club',
      'category': 'Спорт',
      'members': 287,
      'image': null,
      'color': Color(0xFFEA580C),
      'description': 'Спортивные мероприятия',
      'isJoined': true,
    },
    {
      'name': 'Science Lab',
      'category': 'Наука',
      'members': 198,
      'image': null,
      'color': Color(0xFF0891B2),
      'description': 'Научные исследования',
      'isJoined': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredClubs {
    return _clubs.where((club) {
      final matchesSearch = club['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           club['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Все' || club['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Поиск клубов',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          const ProfileSwitchButton(),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск клубов...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600], size: 24),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, color: Colors.grey[600]),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      
                      return Container(
                        margin: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(0xFF3B82F6),
                          checkmarkColor: Colors.white,
                          elevation: 0,
                          pressElevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[300]!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Results Count
          if (_filteredClubs.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Найдено ${_filteredClubs.length} ${_getClubsText(_filteredClubs.length)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (_searchQuery.isNotEmpty || _selectedCategory != 'Все')
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'Все';
                        });
                      },
                      icon: const Icon(Icons.clear_all_rounded, size: 18),
                      label: const Text('Очистить'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                ],
              ),
            ),
          
          // Club List
          Expanded(
            child: _filteredClubs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredClubs.length,
                    itemBuilder: (context, index) {
                      final club = _filteredClubs[index];
                      return _buildClubCard(club, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getClubsText(int count) {
    if (count == 1) return 'клуб';
    if (count >= 2 && count <= 4) return 'клуба';
    return 'клубов';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Клубы не найдены'
                  : 'Выберите категорию',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Попробуйте изменить поисковый запрос'
                  : 'Используйте фильтры для поиска интересных клубов',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _selectedCategory != 'Все') ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'Все';
                  });
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Показать все клубы'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClubCard(Map<String, dynamic> club, int index) {
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
      child: InkWell(
        onTap: () {
          if (club['name'] == 'Debate Club') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventAccountScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Club Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: club['color'],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: club['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: club['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          club['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildClubAvatar(club);
                          },
                        ),
                      )
                    : _buildClubAvatar(club),
              ),
              
              const SizedBox(width: 16),
              
              // Club Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            club['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (club['isJoined'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Участник',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${club['members']} участников',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: club['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            club['category'],
                            style: TextStyle(
                              fontSize: 10,
                              color: club['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Action Button
              club['isJoined']
                  ? IconButton(
                      onPressed: () {
                        // Открыть клуб
                        if (club['name'] == 'Debate Club') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EventAccountScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.all(12),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          club['isJoined'] = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Вы присоединились к клубу "${club['name']}"'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Вступить',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClubAvatar(Map<String, dynamic> club) {
    final words = club['name'].split(' ');
    final initials = words.length >= 2 
        ? '${words[0][0]}${words[1][0]}'
        : club['name'].substring(0, 2);
    
    return Container(
      decoration: BoxDecoration(
        color: club['color'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}