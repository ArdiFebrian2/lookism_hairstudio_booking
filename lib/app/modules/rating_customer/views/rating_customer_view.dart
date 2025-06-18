import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/rating_customer/controllers/rating_customer_controller.dart';

class RatingCustomerView extends GetView<RatingCustomerController> {
  const RatingCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RatingCustomerController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Beri Review',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bagikan Pengalaman Anda',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bantu kami memberikan pelayanan terbaik dengan memberikan review',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    const Text(
                      'Nama Anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.nameC,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama Anda',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rating Section
                    const Text(
                      'Berikan Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final idx = i + 1;
                                return GestureDetector(
                                  onTap:
                                      () =>
                                          controller.rating.value =
                                              idx.toDouble(),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      controller.rating.value >= idx
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color:
                                          controller.rating.value >= idx
                                              ? Colors.amber[600]
                                              : Colors.grey[400],
                                      size: 36,
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                          const SizedBox(height: 8),
                          Obx(() {
                            final ratingTexts = [
                              '',
                              'Sangat Buruk',
                              'Buruk',
                              'Cukup',
                              'Baik',
                              'Sangat Baik',
                            ];
                            return Text(
                              controller.rating.value > 0
                                  ? ratingTexts[controller.rating.value.toInt()]
                                  : 'Tap untuk memberikan rating',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    controller.rating.value > 0
                                        ? Colors.amber[700]
                                        : Colors.grey[600],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Comment Field
                    const Text(
                      'Komentar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.commentC,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Ceritakan pengalaman Anda...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.submitReview(),
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
                        controller.isLoading.value
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
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Kirim Review',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
