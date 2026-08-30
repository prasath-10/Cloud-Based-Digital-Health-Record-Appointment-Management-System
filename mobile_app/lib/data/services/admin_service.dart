import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class AdminService {
  final Dio _dio;

  AdminService({Dio? dio})
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

  // ---------------------------------------------------------------------------
  // DOCTORS (GET /api/doctors, POST /api/doctors)
  // ---------------------------------------------------------------------------

  /// List all doctors with their assigned clinic details
  Future<List<Map<String, dynamic>>> getAllDoctors({
    required String idToken,
    String? clinicId,
  }) async {
    try {
      final response = await _dio.get(
        '/doctors',
        queryParameters: clinicId != null ? {'clinic_id': clinicId} : null,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to fetch doctors.';
      throw Exception(msg);
    }
  }

  /// Register a new doctor linked to a clinic via POST /api/doctors
  Future<Map<String, dynamic>> createDoctor({
    required String idToken,
    required String name,
    required String clinicId,
    required String specialization,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        '/doctors',
        data: {
          'name': name.trim(),
          'clinic_id': clinicId.trim(),
          'specialization': specialization.trim(),
          'phone': phone.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to register doctor.');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to register doctor.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // CLINICS (GET /api/clinics, PUT /api/clinics/:id)
  // ---------------------------------------------------------------------------

  /// Fetch all clinics
  Future<List<Map<String, dynamic>>> getAllClinics({
    required String idToken,
  }) async {
    try {
      final response = await _dio.get(
        '/clinics',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to fetch clinics.';
      throw Exception(msg);
    }
  }

  /// Update clinic details via PUT /api/clinics/:id
  Future<Map<String, dynamic>> updateClinic({
    required String idToken,
    required String clinicId,
    String? name,
    String? location,
    String? contactNumber,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (name != null && name.trim().isNotEmpty) payload['name'] = name.trim();
      if (location != null && location.trim().isNotEmpty) payload['location'] = location.trim();
      if (contactNumber != null && contactNumber.trim().isNotEmpty) {
        payload['contact_number'] = contactNumber.trim();
      }
      if (latitude != null) payload['latitude'] = latitude;
      if (longitude != null) payload['longitude'] = longitude;

      final response = await _dio.put(
        '/clinics/$clinicId',
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to update clinic.');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to update clinic.';
      throw Exception(msg);
    }
  }
}
