import 'package:flutter/material.dart';

class AdminManageDoctorsScreen extends StatelessWidget {
  const AdminManageDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Doctors')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services_outlined, size: 64, color: Color(0xFF8338EC)),
            SizedBox(height: 16),
            Text(
              'Doctor Directory & Onboarding',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Register doctors, assign clinics, and configure schedules.'),
          ],
        ),
      ),
    );
  }
}

class AdminManageClinicsScreen extends StatelessWidget {
  const AdminManageClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Clinics')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment, size: 64, color: Color(0xFF8338EC)),
            SizedBox(height: 16),
            Text(
              'Clinic Locations & Facilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('View clinic branches, capacity, and operational hours.'),
          ],
        ),
      ),
    );
  }
}
