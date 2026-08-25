import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class PatientService {
  final Dio _dio;

  PatientService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.apiBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  /// Calls GET /api/patients/me with the Firebase ID token in Authorization header.
  /// Returns the patient data map if found, or null if 404 (needs registration).
  Future<Map<String, dynamic>?> getMyProfile(String idToken) async {
    try {
      final response = await _dio.get(
        '/patients/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Patient profile not yet created in the database
        return null;
      }
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Failed to fetch profile';
      throw Exception(errorMsg);
    }
  }

  /// Calls POST /api/patients to register a new patient profile.
  Future<Map<String, dynamic>> createPatient({
    required String idToken,
    required String name,
    required String dob, // Format: YYYY-MM-DD
    required String gender, // 'Male', 'Female', 'Other'
    required String languagePref,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        '/patients',
        data: {
          'name': name,
          'dob': dob,
          'gender': gender,
          'language_pref': languagePref,
          if (phone != null) 'phone': phone,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to register patient');
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Registration failed';
      throw Exception(errorMsg);
    }
  }
}
