// widgets/riwayat_app_bar.dart
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class RiwayatAppBar extends StatelessWidget {
  const RiwayatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Get.back(),
          //   child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: const Icon(
          //       Icons.arrow_back_ios_new,
          //       color: Colors.white,
          //       size: 20,
          //     ),
          //   ),
          // ),
          const Expanded(
            child: Text(
              'Riwayat Booking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
          // ),
        ],
      ),
    );
  }
}
