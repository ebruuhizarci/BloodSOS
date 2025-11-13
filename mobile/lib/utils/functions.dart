import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:blood_sos/provider/global_state.dart';
import 'package:blood_sos/services/auth.dart';

/// Capitalize first letter of a word
String titleCase(String arg) {
  if (arg.isEmpty) return arg;
  return arg[0].toUpperCase() + arg.substring(1);
}

/// Check whether device has active internet connection
Future<bool> hasInternetConnection() async {
  return await InternetConnectionChecker().hasConnection;
}

/// Navigates to the right destination based on current authentication state
Future<void> authNavigate(BuildContext context) async {
  try {
    final userResponse = await AuthService.getMe();
    if (!context.mounted) return;

    context.read<GlobalState>().setUserResponse(userResponse);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.sendTimeout && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot Connect To Server')),
      );
    }
  } catch (_) {
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
  }
}

/// Fetches the current location of the user and returns coordinates with human-readable address
Future<(Position, String)?> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (!context.mounted) return null;
      _showLocationDialog(context, 'Lütfen konum iznine izin verin.');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if (!context.mounted) return null;
    _showLocationDialog(context, 'Ayarlar > Uygulamalar > Konum izinlerini etkinleştirin.');
    return null;
  }

  final position = await Geolocator.getCurrentPosition();
  final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  String geoCodedLocation = '';
  if (placemarks.isNotEmpty) {
    final place = placemarks[0];
    geoCodedLocation =
        '${place.street ?? ''} ${place.subLocality ?? ''} ${place.locality ?? ''} ${place.postalCode ?? ''} ${place.country ?? ''}';
  }

  return (position, geoCodedLocation.trim());
}

/// Show alert dialog with a given message
void _showLocationDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Konum Gerekli'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
}
