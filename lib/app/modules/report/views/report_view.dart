// report_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/widgets/report_app_bar.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/widgets/report_content.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/widgets/report_filters.dart';
import '../controllers/report_controller.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReportAppBar(onGeneratePdf: controller.generatePdf),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            ReportFilters(controller: controller),
            const SizedBox(height: 8),
            Expanded(child: ReportContent(controller: controller)),
          ],
        ),
      ),
    );
  }
}
