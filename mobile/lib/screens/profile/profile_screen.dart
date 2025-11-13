import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/models/auth.dart';
import 'package:blood_sos/provider/global_state.dart';
import 'package:blood_sos/services/auth.dart';
import 'package:blood_sos/theme/theme.dart';
import 'package:blood_sos/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String selectedBloodType = bloodTypes.first;
  List<double> coordinates = [0, 0];
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    final user = context.read<GlobalState>().user;

    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    addressController.text = user?.address ?? '';
    selectedBloodType = user?.bloodType ?? bloodTypes.first;
  }

  Future<void> fetchLocation() async {
    addressController.text = 'Konum alınıyor...';
    final location = await getCurrentLocation(context);
    coordinates = [location?.$1.latitude ?? 0, location?.$1.longitude ?? 0];
    addressController.text = location?.$2 ?? '';
  }

  Future<void> onAvatarChange() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Fotoğrafı Kırp',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile == null) return;

    try {
      final res = await AuthService.updateAvatar(localFilePath: croppedFile.path);
      imageBytes = await croppedFile.readAsBytes();
      setState(() {});
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> updateUserDetails() async {
    try {
      final res = await AuthService.updateUserDetails(
        name: nameController.text,
        email: emailController.text,
        address: addressController.text,
        coordinates: coordinates,
        bloodType: selectedBloodType,
        phone: phoneController.text,
      );

      final userResponse = await AuthService.getMe();
      context.read<GlobalState>().setUserResponse(userResponse);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          TextButton(onPressed: logoutUser, child: const Text("Çıkış")),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    try {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalState>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(onPressed: showLogoutDialog, icon: const Icon(Icons.logout)),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPagePadding),
            child: Column(
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onAvatarChange,
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : NetworkImage('$apiUrl/avatar/${user?.avatar}') as ImageProvider,
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "İsim", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedBloodType,
                  items: bloodTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) => setState(() => selectedBloodType = value!),
                  decoration: const InputDecoration(labelText: "Kan Grubu", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "E-posta", border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Telefon", border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Adres",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(icon: const Icon(Icons.location_on), onPressed: fetchLocation),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.update),
                  label: const Text("Bilgileri Güncelle"),
                  onPressed: updateUserDetails,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.key),
                  label: const Text("Şifre Değiştir"),
                  onPressed: () => Navigator.pushNamed(context, '/change-password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
