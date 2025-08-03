// TODO Implement this library.
// lib/app/modules/profile_baberman/widgets/profile_info_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color iconColor;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:
              value != null && value!.isNotEmpty
                  ? () => _copyToClipboard(context)
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 16),
                Expanded(child: _buildContent()),
                if (value != null && value!.isNotEmpty) _buildCopyIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? "Tidak tersedia",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                value != null && value!.isNotEmpty
                    ? const Color(0xFF374151)
                    : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyIcon() {
    return Icon(Icons.copy_outlined, size: 16, color: Colors.grey[400]);
  }

  void _copyToClipboard(BuildContext context) {
    if (value != null && value!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: value!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label berhasil disalin'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
