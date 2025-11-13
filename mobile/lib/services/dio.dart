import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_sos/constants/constants.dart';

Future<Dio> getDioClient() async {
  final dio = Dio(BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null ? status < 500 : true,
  ));

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(tokenKey);

  dio.options.headers = {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  return dio;
}
