import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import 'widgets/dashboard_header_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Extract role from backend payload (default to PATIENT)
    final userMap = authState.patientProfile?['user'] as Map<String, dynamic>?;
    final role = (userMap?['role'] ?? authState.patientProfile?['role'] ?? 'PATIENT')
        .toString()
        .toUpperCase();

    final rawName = authState.patientProfile?['name']?.toString() ?? 'User';
    final healthId = authState.patientProfile?['health_id']?.toString() ?? 'MWH-PENDING';

    // Header parameters configured by role
    String headerTitle = rawName;
    String headerBadge = 'Health ID: $healthId';
    IconData headerIcon = Icons.person;

    if (role == 'DOCTOR') {
      headerTitle = rawName.startsWith('Dr.') ? rawName : 'Dr. $rawName';
      headerBadge = 'Clinical Practitioner';
      headerIcon = Icons.medical_services;
    } else if (role == 'ADMIN') {
      headerTitle = rawName;
      headerBadge = 'System Administrator';
      headerIcon = Icons.admin_panel_settings;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getRoleAppBarTitle(role)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref, headerTitle, role, headerBadge),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task 4 & 1: Reusable & Adaptable Header Card
            DashboardHeaderCard(
              title: headerTitle,
              badgeText: headerBadge,
              icon: headerIcon,
              role: role,
            ),
            const SizedBox(height: 24),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    role,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tasks 1 & 2: Role-aware Quick Actions wired to real go_router routes
            ..._buildRoleQuickActions(context, role),

            const SizedBox(height: 20),

            // Quick Stats / Info Banner
            _buildInfoCard(role),
          ],
        ),
      ),
      // Task 3: Bottom Navigation Bar for quick tab switching
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xFF006A6A),
        unselectedItemColor: Colors.grey.shade600,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          if (index == 1) {
            context.push('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getRoleAppBarTitle(String role) {
    switch (role) {
      case 'DOCTOR':
        return 'Doctor Portal';
      case 'ADMIN':
        return 'Admin Console';
      case 'PATIENT':
      default:
        return 'Clinic Health Hub';
    }
  }

  List<Widget> _buildRoleQuickActions(BuildContext context, String role) {
    if (role == 'DOCTOR') {
      return [
        _buildActionTile(
          context: context,
          icon: Icons.calendar_today_outlined,
          title: "Today's Appointments",
          subtitle: 'View queue and scheduled consultations',
          route: '/doctor/today-appointments',
          color: const Color(0xFF006D77),
        ),
        const SizedBox(height: 8),
        _buildActionTile(
          context: context,
          icon: Icons.post_add_outlined,
          title: 'Add Visit Record',
          subtitle: 'Log diagnoses, prescriptions & lab results',
          route: '/doctor/add-record',
          color: const Color(0xFF006D77),
        ),
        const SizedBox(height: 8),
        _buildActionTile(
          context: context,
          icon: Icons.folder_shared_outlined,
          title: 'Patient Health Records',
          subtitle: 'Lookup patient clinical history',
          route: '/records',
          color: const Color(0xFF006D77),
        ),
      ];
    } else if (role == 'ADMIN') {
      return [
        _buildActionTile(
          context: context,
          icon: Icons.medical_services_outlined,
          title: 'Manage Doctors',
          subtitle: 'Onboard clinicians and assign specializations',
          route: '/admin/doctors',
          color: const Color(0xFF8338EC),
        ),
        const SizedBox(height: 8),
        _buildActionTile(
          context: context,
          icon: Icons.apartment_outlined,
          title: 'Manage Clinics',
          subtitle: 'Configure clinics, branches and schedules',
          route: '/admin/clinics',
          color: const Color(0xFF8338EC),
        ),
        const SizedBox(height: 8),
        _buildActionTile(
          context: context,
          icon: Icons.folder_open_outlined,
          title: 'System Health Records',
          subtitle: 'Audit and review all clinic health data',
          route: '/records',
          color: const Color(0xFF8338EC),
        ),
      ];
    }

    // Default: PATIENT
    return [
      _buildActionTile(
        context: context,
        icon: Icons.folder_shared_outlined,
        title: 'Health Records',
        subtitle: 'View digital records, prescriptions & lab files',
        route: '/records',
        color: const Color(0xFF006A6A),
      ),
      const SizedBox(height: 8),
      _buildActionTile(
        context: context,
        icon: Icons.calendar_month_outlined,
        title: 'My Appointments',
        subtitle: 'Check scheduled and upcoming visits',
        route: '/appointments',
        color: const Color(0xFF006A6A),
      ),
      const SizedBox(height: 8),
      _buildActionTile(
        context: context,
        icon: Icons.add_task_outlined,
        title: 'Book Appointment',
        subtitle: 'Schedule a visit at your nearest clinic',
        route: '/book-appointment',
        color: const Color(0xFF006A6A),
      ),
    ];
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 0.8,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: () => context.push(route),
      ),
    );
  }

  Widget _buildInfoCard(String role) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF006A6A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF006A6A).withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF006A6A), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cloud Health Sync Active',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  role == 'PATIENT'
                      ? 'Your medical history is securely synchronized across all participating migrant worker clinics.'
                      : 'Logged in with role: $role. Operations are audited and logged.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    String name,
    String role,
    String badge,
  ) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF006A6A), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 36, color: Color(0xFF006A6A)),
            ),
            accountName: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(badge),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
