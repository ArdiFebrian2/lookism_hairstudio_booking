import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/schedules_model.dart';
import '../controllers/schedules_controller.dart';
import '../widgets/schedule_form_widget.dart';
import '../widgets/schedule_list_widget.dart';

class SchedulesView extends StatelessWidget {
  final SchedulesController controller = Get.put(SchedulesController());
  final String barberId;

  SchedulesView({super.key, required this.barberId}) {
    controller.fetchSchedules(barberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              ScheduleFormWidget(barberId: barberId, controller: controller),
              const SizedBox(height: 32),
              _buildScheduleListHeader(),
              const SizedBox(height: 16),
              Expanded(child: ScheduleListWidget(controller: controller)),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Kelola Jadwal",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manajemen Jadwal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Kelola jadwal kerja Anda dengan mudah",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleListHeader() {
    return Row(
      children: [
        const Icon(Icons.list_alt, color: Colors.black87, size: 24),
        const SizedBox(width: 8),
        const Text(
          "Jadwal Tersedia",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${controller.schedules.length} jadwal",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
