import 'package:dio/dio.dart';
import 'package:blood_sos/services/dio.dart';
import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/models/common.dart';
import 'package:blood_sos/models/notification.dart';

class NotificationService {
  static const _baseUrl = '$apiUrl/api/v1/notification';

  static void _check(Response response) {
    if (response.statusCode != 200) {
      throw ErrorResponse.fromJson(response.data).error;
    }
  }

  static Future<GetAllNotificationResponse> getNotifications({
    required int page,
    required int limit,
  }) async {
    final dio = await getDioClient();
    final response = await dio.get(
      _baseUrl,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    _check(response);
    return GetAllNotificationResponse.fromJson(response.data);
  }

  static Future<NotificationCountResponse> getUnreadCount() async {
    final dio = await getDioClient();
    final response = await dio.get('$_baseUrl/count');
    _check(response);
    return NotificationCountResponse.fromJson(response.data);
  }
}
