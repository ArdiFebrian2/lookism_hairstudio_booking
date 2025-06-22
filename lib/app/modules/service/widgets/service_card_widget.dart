import 'package:flutter/material.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),

            // Description
            if (service.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                service.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // Price and Duration
            _buildPriceAndDuration(),

            const SizedBox(height: 12),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: service.isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        service.isActive ? 'Aktif' : 'Nonaktif',
        style: TextStyle(
          color: service.isActive ? Colors.green.shade800 : Colors.red.shade800,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriceAndDuration() {
    return Row(
      children: [
        Icon(Icons.attach_money, size: 16, color: Colors.green.shade600),
        Text(
          'Rp ${service.price.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Icon(Icons.access_time, size: 16, color: Colors.blue.shade600),
        Text(
          '${service.duration} menit',
          style: TextStyle(
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, size: 16),
          label: const Text('Hapus'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
