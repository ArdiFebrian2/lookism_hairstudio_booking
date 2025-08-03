// TODO Implement this library.
// lib/app/modules/profile_baberman/widgets/profile_info_section.dart
import 'package:flutter/material.dart';
import 'profile_info_card.dart';

class ProfileInfoSection extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileInfoSection({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Personal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCards(),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    final List<Map<String, dynamic>> infoItems = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email',
        'value': userData["email"],
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.phone_android_outlined,
        'label': 'Nomor Telepon',
        'value': userData["telepon"],
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.badge_outlined,
        'label': 'Role',
        'value': _formatRole(userData["role"]),
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return Column(
      children:
          infoItems
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProfileInfoCard(
                    icon: item['icon'],
                    label: item['label'],
                    value: item['value'],
                    iconColor: item['color'],
                  ),
                ),
              )
              .toList(),
    );
  }

  String _formatRole(dynamic role) {
    if (role == null) return "User";
    String roleStr = role.toString();
    return roleStr[0].toUpperCase() + roleStr.substring(1).toLowerCase();
  }
}
