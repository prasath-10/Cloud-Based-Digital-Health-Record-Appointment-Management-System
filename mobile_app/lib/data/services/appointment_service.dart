import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

/// Thrown when POST /api/appointments returns HTTP 409 Conflict,
/// meaning another patient has already booked that doctor + slot_time.
class SlotTakenException implements Exception {
  final String message;
  const SlotTakenException(
      [this.message = 'This slot is already taken by another patient.']);

  @override
  String toString() => message;
}

class AppointmentService {
  final Dio _dio;

  AppointmentService({Dio? dio})
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
  // GET /api/clinics
  // ---------------------------------------------------------------------------

  /// Returns every clinic the backend knows about.
  /// Each map will contain at least: id, name, location (and possibly address,
  /// phone, etc. depending on your seed data).
  Future<List<Map<String, dynamic>>> getClinics({
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
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to load clinics.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/doctors?clinic_id={clinicId}
  // ---------------------------------------------------------------------------

  /// Returns all doctors belonging to [clinicId].
  /// Each map will contain at least: id, name, specialization.
  Future<List<Map<String, dynamic>>> getDoctors({
    required String idToken,
    required String clinicId,
  }) async {
    try {
      final response = await _dio.get(
        '/doctors',
        queryParameters: {'clinic_id': clinicId},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to load doctors.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // POST /api/appointments
  // ---------------------------------------------------------------------------

  /// Books an appointment and returns the created appointment object.
  ///
  /// [slotTime] must be an ISO-8601 string, e.g. "2026-09-05T10:30:00.000Z".
  ///
  /// Throws [SlotTakenException] on HTTP 409 Conflict so callers can display
  /// a specific, actionable message instead of a generic error.
  Future<Map<String, dynamic>> bookAppointment({
    required String idToken,
    required String doctorId,
    required String clinicId,
    required String slotTime, // ISO-8601 formatted DateTime
  }) async {
    try {
      final response = await _dio.post(
        '/appointments',
        data: {
          'doctor_id': doctorId,
          'clinic_id': clinicId,
          'slot_time': slotTime,
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Booking failed.');
    } on DioException catch (e) {
      // 409 Conflict → the doctor+slot combination is already booked
      if (e.response?.statusCode == 409) {
        throw const SlotTakenException();
      }
      final msg = e.response?.data?['message'] ?? e.message ?? 'Booking request failed.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/appointments (Doctor & Admin view)
  // ---------------------------------------------------------------------------

  /// Returns appointments filtered by [doctorId], [date] (YYYY-MM-DD), and/or [status].
  Future<List<Map<String, dynamic>>> getDoctorAppointments({
    required String idToken,
    String? doctorId,
    String? clinicId,
    String? date,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (doctorId != null && doctorId.isNotEmpty) queryParams['doctor_id'] = doctorId;
      if (clinicId != null && clinicId.isNotEmpty) queryParams['clinic_id'] = clinicId;
      if (date != null && date.isNotEmpty) queryParams['date'] = date;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;

      final response = await _dio.get(
        '/appointments',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to load appointments.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/appointments/me
  // ---------------------------------------------------------------------------

  /// Returns all appointments for the authenticated patient.
  Future<List<Map<String, dynamic>>> getMyAppointments({
    required String idToken,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        '/appointments/me',
        queryParameters: status != null ? {'status': status} : null,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Failed to load appointments.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // PUT /api/appointments/:id (Reschedule)
  // ---------------------------------------------------------------------------

  /// Reschedules an appointment with a new [slotTime] (ISO-8601 string).
  ///
  /// Throws [SlotTakenException] on HTTP 409 Conflict if the doctor is booked for that slot.
  Future<Map<String, dynamic>> rescheduleAppointment({
    required String idToken,
    required String appointmentId,
    required String slotTime,
  }) async {
    try {
      final response = await _dio.put(
        '/appointments/$appointmentId',
        data: {
          'slot_time': slotTime,
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Reschedule failed.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const SlotTakenException();
      }
      final msg = e.response?.data?['message'] ?? e.message ?? 'Reschedule request failed.';
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/appointments/:id/cancel
  // ---------------------------------------------------------------------------

  /// Cancels an appointment (soft-cancel, status becomes 'cancelled').
  Future<Map<String, dynamic>> cancelAppointment({
    required String idToken,
    required String appointmentId,
  }) async {
    try {
      final response = await _dio.patch(
        '/appointments/$appointmentId/cancel',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Cancellation failed.');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Cancel request failed.';
      throw Exception(msg);
    }
  }
}
