import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final patientName = authState.patientProfile?['name'] ?? 'Migrant Worker';
    final healthId = authState.patientProfile?['health_id'] ?? 'MWH-PENDING';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF006A6A),
                      child: Icon(Icons.local_hospital, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF006A6A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ID: $healthId',
                              style: const TextStyle(
                                color: Color(0xFF006A6A),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.folder_shared, color: Color(0xFF006A6A)),
              title: const Text('Health Records'),
              subtitle: const Text('View patient history & diagnoses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/records'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF006A6A)),
              title: const Text('My Appointments'),
              subtitle: const Text('Check scheduled clinic visits'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/appointments'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_task, color: Color(0xFF006A6A)),
              title: const Text('Book Appointment'),
              subtitle: const Text('Schedule a new doctor visit'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/book-appointment'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
