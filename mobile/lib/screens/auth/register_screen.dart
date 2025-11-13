import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Firestore için ekle
import 'package:blood_sos/screens/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback togglePage;

  const RegisterScreen({super.key, required this.togglePage});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String? _selectedBloodType;
  bool isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // Firebase Auth ile kullanıcı oluştur
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Firestore'a kullanıcı bilgilerini kaydet
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'bloodType': _selectedBloodType,
          'createdAt': Timestamp.now(),
        });

        if (!mounted) return;

        // Başarılıysa ana sayfaya geç
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarısız: ${e.message}')),
        );
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  color: Colors.redAccent,
                  child: const Center(
                    child: Text(
                      "Umut Ver, Hayat Ver. Kan Bağışla",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Hoş Geldiniz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("KAYIT OL", style: TextStyle(fontSize: 20, color: Colors.red)),
                const SizedBox(height: 24),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Ad Soyad", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kan Grubu", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: "A+", child: Text("A Positive (A+)")),
                    DropdownMenuItem(value: "A-", child: Text("A Negative (A-)")),
                    DropdownMenuItem(value: "B+", child: Text("B Positive (B+)")),
                    DropdownMenuItem(value: "B-", child: Text("B Negative (B-)")),
                    DropdownMenuItem(value: "O+", child: Text("O Positive (O+)")),
                    DropdownMenuItem(value: "O-", child: Text("O Negative (O-)")),
                    DropdownMenuItem(value: "AB+", child: Text("AB Positive (AB+)")),
                    DropdownMenuItem(value: "AB-", child: Text("AB Negative (AB-)")),
                  ],
                  value: _selectedBloodType,
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodType = value;
                    });
                  },
                  validator: (value) => value == null ? "Lütfen bir kan grubu seçin" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "E-posta", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Telefon", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Adres",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Şifre", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Şifre boş bırakılamaz";
                    if (value.length < 6) return "Şifre en az 6 karakter olmalı";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Şifre Tekrar", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Şifre tekrar boş bırakılamaz";
                    if (value != passwordController.text) return "Şifreler eşleşmiyor";
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Kayıt Ol", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: widget.togglePage,
                    child: const Text("Zaten bir hesabınız var mı? Giriş Yap"),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
