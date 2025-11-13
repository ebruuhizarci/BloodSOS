import 'package:flutter/material.dart';
import 'package:blood_sos/services/auth.dart';
import 'package:blood_sos/theme/theme.dart' as theme;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tokenController = TextEditingController();

  bool showResetTextField = false;
  bool hidePassword = true;

  Future<void> sendForgotPasswordRequest() async {
    try {
      final res = await AuthService.forgotPassword(email: emailController.text);
      if (!mounted) return;

      _showSnackBar(res.message);
      setState(() => showResetTextField = true);
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> resetPassword() async {
    try {
      final res = await AuthService.resetPassword(
        token: tokenController.text,
        password: passwordController.text,
      );
      if (!mounted) return;

      _showSnackBar(res.message);
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Şifremi Unuttum')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.defaultPagePadding),
          child: Column(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-posta',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              Text(
                'Kayıtlı e-posta adresinizi girin. Size bir OTP (doğrulama kodu) göndereceğiz.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              if (showResetTextField)
                Column(
                  children: [
                    TextFormField(
                      controller: tokenController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'OTP Kodu',
                        hintText: 'Mailde gelen kodu girin',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Yeni Şifre',
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: showResetTextField
                    ? resetPassword
                    : sendForgotPasswordRequest,
                icon: const Icon(Icons.done),
                label: Text(showResetTextField ? 'Şifreyi Sıfırla' : 'Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
