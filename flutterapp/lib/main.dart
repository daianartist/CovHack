import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoventryUniversityApp());
}

class CoventryUniversityApp extends StatelessWidget {
  const CoventryUniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coventry University',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/auth': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final initialTab = (args is Map && args.containsKey('initialTab')) ? args['initialTab'] as int : 0;
          return AuthScreen(initialTab: initialTab);
        },
        '/main': (context) => const MainScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Map && args.containsKey('email')) {
            return ResetPasswordScreen(email: args['email'], code: args['code']);
          }
          return const ForgotPasswordScreen();
        },
      },
    );
  }
}


class MainScreen extends StatefulWidget {
  final int initialTab;
  
  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navBarIndex = 0;
  int _screenIndex = 0;

  @override
  void initState() {
    super.initState();
    // Устанавливаем начальную вкладку
    _navBarIndex = widget.initialTab;
    _screenIndex = widget.initialTab > 2 ? widget.initialTab - 1 : widget.initialTab;
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(), // Clubs
    ScheduleScreen(),
    ProfileScreen(),
  ];

  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: 360,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          children: const [
            _MenuItem(icon: Icons.checklist_rtl, label: 'Technological\nTask', iconColor: Color(0xFFAC5A4A)),
            _MenuItem(icon: Icons.calendar_today_outlined, label: 'Schedule', iconColor: Color(0xFFE57373)),
            _MenuItem(icon: Icons.chat_bubble_outline, label: 'Survey', iconColor: Color(0xFF64B5F6)),
            _MenuItem(icon: Icons.qr_code_scanner, label: 'QR scanning', iconColor: Color(0xFF42A5F5)),
            _MenuItem(icon: Icons.groups_outlined, label: 'Clubs', iconColor: Color(0xFF1E88E5)),
            _MenuItem(icon: Icons.storefront_outlined, label: 'Marketplace', iconColor: Color(0xFF1565C0)),
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() {
        if (_navBarIndex == 2) {
           _navBarIndex = _screenIndex <= 1 ? _screenIndex : _screenIndex + 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _navBarIndex,
        onTap: (index) {
          if (index == 2) { 
            setState(() {
              _navBarIndex = index;
            });
            _showMenuSheet(context);
          } else {
            setState(() {
              _navBarIndex = index;
              _screenIndex = index > 2 ? index - 1 : index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Clubs'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 36, color: iconColor),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
