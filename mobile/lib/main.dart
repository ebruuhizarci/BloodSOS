import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:blood_sos/provider/global_state.dart';
import 'package:blood_sos/screens/auth/auth_screen.dart';
import 'package:blood_sos/screens/home/home_screen.dart';
import 'package:blood_sos/screens/auth/change_password_screen.dart';
import 'package:blood_sos/screens/home/request_detail_screen.dart';
import 'package:blood_sos/screens/profile/public_profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood SOS',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/request-detail': (context) => const RequestDetailScreen(),
        '/public-profile': (context) => const PublicProfileScreen(),
      },
    );
  }
}
