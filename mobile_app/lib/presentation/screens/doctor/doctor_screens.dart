import 'package:flutter/material.dart';

class DoctorTodayAppointmentsScreen extends StatelessWidget {
  const DoctorTodayAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Appointments")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: Color(0xFF006D77)),
            SizedBox(height: 16),
            Text(
              "Today's Patient Queue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Scheduled patient visits for today will be listed here.'),
          ],
        ),
      ),
    );
  }
}

class DoctorAddRecordScreen extends StatelessWidget {
  const DoctorAddRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Visit Record')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64, color: Color(0xFF006D77)),
            SizedBox(height: 16),
            Text(
              'Add Clinical Visit & Diagnosis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Form to enter diagnosis, prescriptions, and upload lab files.'),
          ],
        ),
      ),
    );
  }
}
