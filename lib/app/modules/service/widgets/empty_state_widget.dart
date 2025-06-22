import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final String? title;
  final String? subtitle;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.onAddPressed,
    this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon ?? Icons.content_cut_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title ?? 'Belum Ada Layanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle ?? 'Tambahkan layanan pertama untuk salon Anda',
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Layanan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
