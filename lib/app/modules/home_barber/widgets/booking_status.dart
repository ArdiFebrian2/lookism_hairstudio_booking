import 'package:flutter/material.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_utils.dart';

class BookingStatus extends StatelessWidget {
  final String status;

  const BookingStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: BookingUtils.getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                BookingUtils.getStatusIcon(status),
                size: 14,
                color: BookingUtils.getStatusColor(status),
              ),
              const SizedBox(width: 6),
              Text(
                '${status[0].toUpperCase()}${status.substring(1)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: BookingUtils.getStatusColor(status),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
