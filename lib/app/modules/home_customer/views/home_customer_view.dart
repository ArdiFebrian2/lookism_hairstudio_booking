import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class HomeCustomerView extends GetView<ServiceController> {
  const HomeCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController());
    controller.fetchServices(showInactive: false);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 50,
            floating: true,
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Lookism Hairstudio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Services Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.purple.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang! 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih layanan terbaik untuk penampilan sempurna Anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Services Header
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Layanan Tersedia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Services List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return SliverToBoxAdapter(child: _buildLoadingState());
              }

              if (controller.services.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState());
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final service = controller.services[index];
                  return _buildServiceCard(context, service, index);
                }, childCount: controller.services.length),
              );
            }),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat layanan...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.content_cut_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Layanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Layanan tersedia akan muncul di sini',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ServiceModel service,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child:
                service.image != null
                    ? Image.network(
                      service.image!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.content_cut,
                            size: 60,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade200,
                            Colors.deepPurple.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.content_cut,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
          ),

          // Service Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Name
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Service Description
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Price and Booking Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(service.price)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () => showBookingDialog(context, service),
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: const Text('Book Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showBookingDialog(BuildContext context, ServiceModel service) {
    final selectedBarberman = Rxn<String>();
    final selectedDate = Rxn<DateTime>();
    final selectedTime = Rxn<TimeOfDay>();
    final isSubmitting = RxBool(false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: MediaQuery.of(
              context,
            ).viewInsets.add(const EdgeInsets.all(24)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.deepPurple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book Appointment',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              service.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Service Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              service.image != null
                                  ? Image.network(
                                    service.image!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.content_cut,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.content_cut,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(service.price)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Barberman Selection
                  const Text(
                    'Pilih Barberman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'baberman')
                            .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Memuat barberman...'),
                            ],
                          ),
                        );
                      }

                      final barbers = snapshot.data!.docs;

                      return Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedBarberman.value,
                            items:
                                barbers.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return DropdownMenuItem<String>(
                                    value: doc.id,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.deepPurple,
                                          child: Text(
                                            (data['nama'] ?? 'B')[0]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(data['nama'] ?? 'Barberman'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) => selectedBarberman.value = val,
                            decoration: const InputDecoration(
                              hintText: 'Pilih barberman favorit Anda',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Date Selection
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          selectedDate.value == null
                              ? 'Pilih tanggal appointment'
                              : DateFormat(
                                'EEEE, dd MMMM yyyy',
                                'id_ID',
                              ).format(selectedDate.value!),
                          style: TextStyle(
                            color:
                                selectedDate.value == null
                                    ? Colors.grey[600]
                                    : Colors.black87,
                            fontWeight:
                                selectedDate.value == null
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.deepPurple,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) selectedDate.value = picked;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Time Selection
                  const Text(
                    'Pilih Waktu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.access_time,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          selectedTime.value == null
                              ? 'Pilih jam appointment'
                              : selectedTime.value!.format(context),
                          style: TextStyle(
                            color:
                                selectedTime.value == null
                                    ? Colors.grey[600]
                                    : Colors.black87,
                            fontWeight:
                                selectedTime.value == null
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.deepPurple,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) selectedTime.value = picked;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            isSubmitting.value
                                ? null
                                : () async {
                                  if (selectedBarberman.value == null ||
                                      selectedDate.value == null ||
                                      selectedTime.value == null) {
                                    Get.snackbar(
                                      'Oops!',
                                      'Mohon lengkapi semua data booking',
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }

                                  isSubmitting.value = true;

                                  try {
                                    final bookingDateTime = DateTime(
                                      selectedDate.value!.year,
                                      selectedDate.value!.month,
                                      selectedDate.value!.day,
                                      selectedTime.value!.hour,
                                      selectedTime.value!.minute,
                                    );

                                    await FirebaseFirestore.instance
                                        .collection('bookings')
                                        .add({
                                          'serviceId': service.id,
                                          'serviceName': service.name,
                                          'barbermanId':
                                              selectedBarberman.value,
                                          'datetime':
                                              bookingDateTime.toIso8601String(),
                                          'status': 'pending',
                                          'createdAt':
                                              DateTime.now().toIso8601String(),
                                        });

                                    Navigator.pop(context);
                                    Get.snackbar(
                                      'Berhasil! 🎉',
                                      'Booking berhasil dibuat. Menunggu konfirmasi.',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Terjadi kesalahan. Silakan coba lagi.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } finally {
                                    isSubmitting.value = false;
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child:
                            isSubmitting.value
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Konfirmasi Booking',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
