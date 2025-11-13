import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blood_sos/screens/home/dashboard_screen.dart';
import 'package:blood_sos/screens/home/feed_screen.dart';
import 'package:blood_sos/screens/home/notifications_screen.dart';
import 'package:blood_sos/screens/home/request_blood_screen.dart';
import 'package:blood_sos/screens/home/reviews_screen.dart';
import 'package:blood_sos/screens/auth/auth_screen.dart'; // Hatalı girişlerde yönlendirme için

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),
    DashboardScreen(),
    RequestBloodScreen(),
    NotificationsScreen(),
    ReviewsScreen(), // Bu profil gibi gösteriliyor
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcı giriş yapmamışsa AuthScreen'e yönlendir
    if (FirebaseAuth.instance.currentUser == null) {
      return const AuthScreen(); // togglePage parametresi burada yönetiliyor
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.bloodtype), label: 'İstek'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Bildirimler'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
