import 'package:blood_sos/constants/constants.dart';
import 'package:blood_sos/models/blood_request.dart';
import 'package:blood_sos/models/common.dart';
import 'package:blood_sos/services/dio.dart';
import 'package:dio/dio.dart';

class BloodRequestService {
  static final _base = '$apiUrl/api/v1/blood-request';

  static void _check(Response response) {
    if (response.statusCode != 200) {
      throw ErrorResponse.fromJson(response.data).error;
    }
  }

  static Future<GetAllBloodRequestResponse> getBloodRequests({
    required int page,
    required int limit,
  }) async {
    final dio = await getDioClient();
    final response = await dio.get(_base, queryParameters: {
      'page': page,
      'limit': limit,
    });
    _check(response);
    return GetAllBloodRequestResponse.fromJson(response.data);
  }

  static Future<GetBloodRequestResponse> getBloodRequest({required String id}) async {
    final dio = await getDioClient();
    final response = await dio.get('$_base/$id');
    _check(response);
    return GetBloodRequestResponse.fromJson(response.data);
  }

  static Future<GetNearbyBloodRequestResponse> getNearbyBloodRequests({
    required int requestRadius,
  }) async {
    final dio = await getDioClient();
    final response = await dio.get('$_base/nearby', queryParameters: {
      'requestRadius': requestRadius,
    });
    _check(response);
    return GetNearbyBloodRequestResponse.fromJson(response.data);
  }

  static Future<GetBloodRequestStatsResponse> getBloodRequestStats() async {
    final dio = await getDioClient();
    final response = await dio.get('$_base/stats');
    _check(response);
    return GetBloodRequestStatsResponse.fromJson(response.data);
  }

  static Future<MessageResponse> sendDonateRequest({required String id}) async {
    final dio = await getDioClient();
    final response = await dio.get('$_base/donate/$id');
    _check(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> replyToDonateRequest({
    required String id,
    required String notificationId,
    required bool accept,
  }) async {
    final dio = await getDioClient();
    final response = await dio.put('$_base/reply/$id', data: {
      'accept': accept,
      'notificationId': notificationId,
    });
    _check(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> markRequestCompleted({
    required String id,
    required List<double> coordinates,
  }) async {
    final dio = await getDioClient();
    final response = await dio.put('$_base/complete/$id', data: {
      'coordinates': coordinates,
    });
    _check(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> sendRating({
    required String id,
    required double rating,
    required String review,
    required String notificationId,
  }) async {
    final dio = await getDioClient();
    final response = await dio.post('$_base/rate/$id', data: {
      'rating': rating,
      'review': review,
      'notificationId': notificationId,
    });
    _check(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<CreateBloodRequestResponse> createBloodRequest({
    required String patientName,
    required String age,
    required String bloodType,
    required String location,
    required List<double> coordinates,
    required String contactNumber,
    required int unitsRequired,
    required String timeUntil,
    required String notes,
  }) async {
    final dio = await getDioClient();
    final response = await dio.post(_base, data: {
      'patientName': patientName,
      'age': age,
      'bloodType': bloodType,
      'location': location,
      'coordinates': coordinates,
      'contactNumber': contactNumber,
      'unitsRequired': unitsRequired,
      'timeUntil': timeUntil,
      'notes': notes,
    });
    _check(response);
    return CreateBloodRequestResponse.fromJson(response.data);
  }

  static Future<MessageResponse> updateBloodRequest({
    required String id,
    required String patientName,
    required String age,
    required String bloodType,
    required String location,
    required List<double> coordinates,
    required String contactNumber,
    required int unitsRequired,
    required String timeUntil,
    required String notes,
  }) async {
    final dio = await getDioClient();
    final response = await dio.put('$_base/$id', data: {
      'patientName': patientName,
      'age': age,
      'bloodType': bloodType,
      'location': location,
      'coordinates': coordinates,
      'contactNumber': contactNumber,
      'unitsRequired': unitsRequired,
      'timeUntil': timeUntil,
      'notes': notes,
    });
    _check(response);
    return MessageResponse.fromJson(response.data);
  }

  static Future<MessageResponse> deleteRequest({required String id}) async {
    final dio = await getDioClient();
    final response = await dio.delete('$_base/$id');
    _check(response);
    return MessageResponse.fromJson(response.data);
  }
}
