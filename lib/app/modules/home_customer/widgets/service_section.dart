import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/controllers/home_customer_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/empty_state.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/loading_state.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/service_card.dart';

class ServicesSection extends GetView<HomeCustomerController> {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServicesHeader(),
          const SizedBox(height: 16),
          _buildServicesList(),
        ],
      ),
    );
  }

  Widget _buildServicesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan Tersedia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Pilih layanan yang sesuai dengan kebutuhan Anda',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return Obx(() {
      if (controller.serviceController.isLoading.value) {
        return const LoadingState();
      }

      if (controller.serviceController.services.isEmpty) {
        return const EmptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.serviceController.services.length,
        itemBuilder: (context, index) {
          final service = controller.serviceController.services[index];
          return ServiceCard(
            service: service,
            index: index,
            onBookPressed: () => controller.showBookingDialog(context, service),
          );
        },
      );
    });
  }
}
