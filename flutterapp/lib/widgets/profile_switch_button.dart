import 'package:flutter/material.dart';
import '../main.dart';
import '../profile_club_account.dart';
// import '../services/api_service.dart'; // Временно закомментировано

class ProfileSwitchButton extends StatefulWidget {
  const ProfileSwitchButton({super.key});

  @override
  State<ProfileSwitchButton> createState() => _ProfileSwitchButtonState();
}

class _ProfileSwitchButtonState extends State<ProfileSwitchButton> {
  bool _isOrganizer = false;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    // Временно всегда показываем кнопку для демонстрации
    if (mounted) {
      setState(() {
        _isOrganizer = true;
      });
    }
    
    // Закомментированный код для API проверки
    /*
    try {
      final user = await ApiService().getMe();
      if (mounted) {
        setState(() {
          _isOrganizer = user['role'] == 'organizer';
        });
      }
    } catch (e) {
      // If error, assume not an organizer
      if (mounted) {
        setState(() {
          _isOrganizer = false;
        });
      }
    }
    */
  }

  void _showProfileDropdown() {
    if (!_isOrganizer) return;

    final RenderBox buttonBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = buttonBox.localToGlobal(Offset.zero);
    final Size buttonSize = buttonBox.size;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 160, // Сдвигаем влево для лучшего позиционирования
        offset.dy + buttonSize.height + 5,
        offset.dx + buttonSize.width,
        offset.dy + buttonSize.height + 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'user',
          height: 65,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'User Profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Your personal profile',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'club',
          height: 65,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.business_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Club Profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Manage your club',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        if (value == 'user') {
          // Навигация на основной экран с открытой вкладкой профиля
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(initialTab: 4),
            ),
            (route) => false, // Удаляем все предыдущие экраны
          );
        } else if (value == 'club') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClubProfileScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOrganizer) {
      // Если не организатор, не показываем кнопку
      return const SizedBox.shrink();
    }

    return Container(
      key: _buttonKey,
      margin: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showProfileDropdown,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.account_circle_rounded,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
