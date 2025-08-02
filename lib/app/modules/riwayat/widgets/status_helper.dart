// utils/status_helper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusHelper {
  static Widget buildStatusChip(String status) {
    final statusData = _getStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusData['color'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusData['icon'], color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            statusData['text'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'color': const Color(0xFFF59E0B), // Amber
          'icon': Icons.hourglass_empty_rounded,
          'text': 'Menunggu',
        };
      case 'accepted':
        return {
          'color': const Color(0xFF3B82F6), // Blue
          'icon': Icons.check_circle_outline_rounded,
          'text': 'Diterima',
        };
      case 'selesai':
      case 'done':
        return {
          'color': const Color(0xFF10B981), // Green
          'icon': Icons.check_circle_rounded,
          'text': 'Selesai',
        };
      case 'rejected':
      case 'cancelled':
        return {
          'color': const Color(0xFFEF4444), // Red
          'icon': Icons.cancel_rounded,
          'text': 'Dibatalkan',
        };
      case 'in_progress':
        return {
          'color': const Color(0xFF8B5CF6), // Purple
          'icon': Icons.refresh_rounded,
          'text': 'Berlangsung',
        };
      default:
        return {
          'color': const Color(0xFF6B7280), // Gray
          'icon': Icons.info_outline_rounded,
          'text': status.capitalizeFirst ?? 'Unknown',
        };
    }
  }

  static Color getStatusColor(String status) {
    return _getStatusData(status)['color'];
  }

  static IconData getStatusIcon(String status) {
    return _getStatusData(status)['icon'];
  }

  static String getStatusText(String status) {
    return _getStatusData(status)['text'];
  }
}
