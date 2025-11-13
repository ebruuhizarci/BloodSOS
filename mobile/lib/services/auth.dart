import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/services/dio.dart';
import 'package:blood_sos/models/auth.dart';
import 'package:blood_sos/models/common.dart';

class AuthService {
  static Future<TokenResponse> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    return _postToken(
      endpoint: '/login',
      data: {
        'email': email,
        'password': password,
        'fcmToken': fcmToken,
      },
    );
  }

  static Future<TokenResponse> register({
    required String name,
    required String email,
    required String password,
    required String address,
    required List<double> coordinates,
    required String bloodType,
    required String phone,
    required String fcmToken,
  }) async {
    return _postToken(
      endpoint: '/register',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'bloodType': bloodType,
        'address': address,
        'coordinates': coordinates,
        'password': password,
        'fcmToken': fcmToken,
      },
    );
  }

  static Future<TokenResponse> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _postToken(
      endpoint: '/update-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  static Future<MessageResponse> logout() async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/logout';

    final response = await dio.get(url);
    _checkResponse(response);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);

    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> updateUserDetails({
    required String name,
    required String email,
    required String address,
    required List<double> coordinates,
    required String bloodType,
    required String phone,
  }) async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/update-details';

    final response = await dio.post(url, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'bloodType': bloodType,
      'address': address,
      'coordinates': coordinates,
    });

    _checkResponse(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> updateAvatar({
    required String localFilePath,
  }) async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/update-avatar';

    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(localFilePath),
    });

    final response = await dio.post(url, data: formData);
    _checkResponse(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> forgotPassword({required String email}) async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/forgot-password';

    final response = await dio.post(url, data: {'email': email});
    _checkResponse(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> resetPassword({
    required String token,
    required String password,
  }) async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/reset-password';

    final response = await dio.post(url, data: {
      'token': token,
      'password': password,
    });

    _checkResponse(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<UserResponse> getMe() async {
    final dio = await getDioClient();
    const url = '$apiUrl/api/v1/auth/me';

    final response = await dio.get(url);
    _checkResponse(response);

    return UserResponse.fromJson(response.data);
  }

  // 🧠 Yardımcı Fonksiyonlar
  static void _checkResponse(Response response) {
    if (response.statusCode != 200) {
      final error = ErrorResponse.fromJson(response.data);
      throw error.error;
    }
  }

  static Future<TokenResponse> _postToken({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    final dio = await getDioClient();
    final url = '$apiUrl/api/v1/auth$endpoint';

    final response = await dio.post(url, data: data);
    _checkResponse(response);

    final tokenResponse = TokenResponse.fromJson(response.data);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, tokenResponse.token);
    return tokenResponse;
  }
}
