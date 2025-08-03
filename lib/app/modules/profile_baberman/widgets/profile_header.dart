// TODO Implement this library.
// lib/app/modules/profile_baberman/widgets/profile_header.dart
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeader({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildUserInfo(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final String name = userData["nama"] ?? "";
    final String initials = _getInitials(name);

    return Hero(
      tag: 'profile-avatar',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 56,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 52,
            backgroundColor: const Color(0xFF4F46E5),
            child:
                initials.isNotEmpty
                    ? Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.person, size: 48, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          userData["nama"] ?? "Nama tidak tersedia",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _formatRole(userData["role"]),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatRole(dynamic role) {
    if (role == null) return "USER";
    return role.toString().toUpperCase();
  }
}
