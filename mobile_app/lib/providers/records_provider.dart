import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/record_service.dart';
import 'auth_provider.dart';

final recordServiceProvider = Provider<RecordService>((ref) {
  return RecordService();
});

/// Fetches medical history for the currently logged-in patient
final patientRecordsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final token = authState.idToken;
  final patientId = authState.patientProfile?['id']?.toString() ??
      authState.patientProfile?['health_id']?.toString();

  if (token == null || patientId == null || patientId.isEmpty) {
    return [];
  }

  final recordService = ref.watch(recordServiceProvider);
  return await recordService.getPatientRecords(
    idToken: token,
    patientId: patientId,
  );
});

/// Fetches a single record by ID (if not passed in router extra)
final singleRecordProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, recordId) async {
  final authState = ref.watch(authNotifierProvider);
  final token = authState.idToken;

  if (token == null) {
    throw Exception('User is not authenticated.');
  }

  final recordService = ref.watch(recordServiceProvider);
  return await recordService.getRecordById(
    idToken: token,
    recordId: recordId,
  );
});
