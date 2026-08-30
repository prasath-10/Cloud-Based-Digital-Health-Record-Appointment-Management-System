import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class RecordService {
  final Dio _dio;

  RecordService({Dio? dio})
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

  /// Fetch full medical history for a patient via GET /api/records/patient/:patientId
  Future<List<Map<String, dynamic>>> getPatientRecords({
    required String idToken,
    required String patientId,
  }) async {
    try {
      final response = await _dio.get(
        '/records/patient/$patientId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        return dataList.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Failed to load medical records.';
      throw Exception(errorMsg);
    }
  }

  /// Fetch a single medical record detail via GET /api/records/:id
  Future<Map<String, dynamic>> getRecordById({
    required String idToken,
    required String recordId,
  }) async {
    try {
      final response = await _dio.get(
        '/records/$recordId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception('Record not found.');
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Failed to load record details.';
      throw Exception(errorMsg);
    }
  }

  /// Create a new medical record with nested prescriptions via POST /api/records
  Future<Map<String, dynamic>> createMedicalRecord({
    required String idToken,
    required String patientId,
    String? doctorId,
    String? appointmentId,
    String? visitDate,
    required String diagnosis,
    String? notes,
    List<Map<String, String>>? prescriptions,
  }) async {
    try {
      final payload = <String, dynamic>{
        'patient_id': patientId,
        'diagnosis': diagnosis,
        if (doctorId != null && doctorId.isNotEmpty) 'doctor_id': doctorId,
        if (appointmentId != null && appointmentId.isNotEmpty) 'appointment_id': appointmentId,
        if (visitDate != null && visitDate.isNotEmpty) 'visit_date': visitDate,
        if (notes != null) 'notes': notes,
        if (prescriptions != null && prescriptions.isNotEmpty) 'prescriptions': prescriptions,
      };

      final response = await _dio.post(
        '/records',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to create medical record.');
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Failed to create medical record.';
      throw Exception(errorMsg);
    }
  }
}

