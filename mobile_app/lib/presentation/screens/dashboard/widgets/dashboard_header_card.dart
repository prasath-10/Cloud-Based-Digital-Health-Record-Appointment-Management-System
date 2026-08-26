import 'package:flutter/material.dart';

class DashboardHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final IconData icon;
  final String role;

  const DashboardHeaderCard({
    super.key,
    required this.title,
    required this.badgeText,
    this.icon = Icons.local_hospital,
    this.role = 'PATIENT',
  });

  Color _getRoleColor() {
    switch (role.toUpperCase()) {
      case 'DOCTOR':
        return const Color(0xFF006D77);
      case 'ADMIN':
        return const Color(0xFF8338EC);
      case 'PATIENT':
      default:
        return const Color(0xFF006A6A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getRoleColor();

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: themeColor.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: themeColor,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.w600,
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
    );
  }
}
