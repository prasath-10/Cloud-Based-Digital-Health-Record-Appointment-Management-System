import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF006A6A),
                      child: Icon(Icons.local_hospital, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, Migrant Health Worker', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Cloud Health Record Hub', style: TextStyle(color: Colors.grey)),
                      ],
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
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
