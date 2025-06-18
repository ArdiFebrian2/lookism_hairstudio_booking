import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingCustomerController extends GetxController {
  final nameC = TextEditingController();
  final commentC = TextEditingController();
  final rating = 0.0.obs;
  final isLoading = false.obs;

  void submitReview() async {
    if (nameC.text.isEmpty || commentC.text.isEmpty || rating.value == 0.0) {
      Get.snackbar('Error', 'Isi semua data dan berikan rating!');
      return;
    }

    isLoading.value = true;

    await FirebaseFirestore.instance.collection('reviews').add({
      'customerName': nameC.text,
      'comment': commentC.text,
      'rating': rating.value,
      'createdAt': Timestamp.now(),
    });

    isLoading.value = false;
    Get.snackbar('Berhasil', 'Review berhasil dikirim');
    nameC.clear();
    commentC.clear();
    rating.value = 0.0;
  }
}
