import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:blood_sos/utils/functions.dart'; // ✅ import yolunu güncelledim

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Küçük geçiş efekti

    if (!mounted) return;

    final hasConnection = await hasInternetConnection();

    FlutterNativeSplash.remove();

    if (hasConnection) {
      authNavigate(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No Internet Connection'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // Kullanıcıya yükleniyor hissi verir
      ),
    );
  }
}
