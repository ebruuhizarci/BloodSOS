import 'package:dio/dio.dart';
import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/models/common.dart';
import 'package:blood_sos/models/user.dart';
import 'package:blood_sos/services/dio.dart';

class UserService {
  static void _check(Response response) {
    if (response.statusCode != 200) {
      throw ErrorResponse.fromJson(response.data).error;
    }
  }

  static Future<GetProfileResponse> getProfile({required String id}) async {
    final dio = await getDioClient();
    final response = await dio.get('$apiUrl/api/v1/user/$id');

    _check(response);
    return GetProfileResponse.fromJson(response.data);
  }
}
