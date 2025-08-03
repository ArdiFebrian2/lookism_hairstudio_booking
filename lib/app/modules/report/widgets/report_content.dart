// widgets/report_content.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/controllers/report_controller.dart';
import 'summary_card.dart';
import 'report_list_item.dart';
import 'empty_state.dart';
import 'loading_state.dart';

class ReportContent extends StatelessWidget {
  final ReportController controller;

  const ReportContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingState();
      }

      if (controller.reports.isEmpty) {
        return const EmptyState();
      }

      return _buildReportList();
    });
  }

  Widget _buildReportList() {
    final totalRevenue = controller.reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
    );

    final totalBookings = controller.reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalBookings'] ?? 0) as int),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        SummaryCard(totalBookings: totalBookings, totalRevenue: totalRevenue),
        const SizedBox(height: 24),
        _buildSectionHeader(),
        const SizedBox(height: 12),
        _buildReportItems(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.teal.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Detail Laporan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItems() {
    return Column(
      children:
          controller.reports
              .asMap()
              .entries
              .map(
                (entry) => ReportListItem(item: entry.value, index: entry.key),
              )
              .toList(),
    );
  }
}
