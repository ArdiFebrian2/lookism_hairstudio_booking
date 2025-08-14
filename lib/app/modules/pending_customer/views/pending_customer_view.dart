import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/pending_customer/controllers/pending_customer_controller.dart';
import 'widgets/pending_customer_header.dart';
import 'widgets/pending_customer_empty_state.dart';
import 'widgets/pending_customer_loading_state.dart';
import 'widgets/pending_customer_list.dart';

class PendingCustomerView extends GetView<PendingCustomerController> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PendingCustomerController());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Persetujuan Customer',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return PendingCustomerLoadingState();
        }

        if (controller.pendingCustomers.isEmpty) {
          return PendingCustomerEmptyState();
        }

        return Column(
          children: [
            PendingCustomerHeader(
              customerCount: controller.pendingCustomers.length,
            ),
            Expanded(
              child: PendingCustomerList(
                pendingCustomers: controller.pendingCustomers,
                onRefresh: () async => controller.fetchPendingCustomers(),
                onApprove: (uid) => controller.approveCustomer(uid),
                onReject: (uid) => controller.rejectCustomer(uid),
              ),
            ),
          ],
        );
      }),
    );
  }
}
