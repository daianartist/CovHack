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
import 'qr_scanner_screen.dart';

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
          final initialTab = (args is Map && args.containsKey('initialTab'))
              ? args['initialTab'] as int
              : 0;
          return AuthScreen(initialTab: initialTab);
        },
        '/main': (context) => const MainScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Map && args.containsKey('email')) {
            return ResetPasswordScreen(
                email: args['email'], code: args['code']);
          }
          return const ForgotPasswordScreen();
        },
        '/qr-scanner': (context) => const QrScannerScreen(),
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
  late int _navBarIndex;
  late int _screenIndex;

  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navBarIndex = widget.initialTab;
    // Преобразуем начальный индекс для экранов
    if (widget.initialTab < 2) {
      _screenIndex = widget.initialTab;
    } else if (widget.initialTab == 2) {
      // Если по какой-то причине передали 2 (QR), показываем Home
      _screenIndex = 0;
      _navBarIndex = 0;
    } else {
      _screenIndex = widget.initialTab - 1;
    }
  }

  void _onTapNav(int index) {
    if (index == 2) {
      // QR-scanner tapped
      Navigator.pushNamed(context, '/qr-scanner');
      return;
    }
    int screenIdx;
    if (index < 2) {
      screenIdx = index;
    } else {
      screenIdx = index - 1; // 3->2, 4->3
    }
    
    setState(() {
      _navBarIndex = index;
      _screenIndex = screenIdx;
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
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
