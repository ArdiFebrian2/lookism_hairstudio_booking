import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/review_model.dart';

class ReviewCustomerController extends GetxController {
  final reviews = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  void fetchReviews() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('reviews')
              .orderBy('createdAt', descending: true)
              .get();

      final reviewList =
          snapshot.docs
              .map((doc) => ReviewModel.fromDocumentSnapshot(doc))
              .toList();

      reviews.assignAll(reviewList);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil review: $e');
    }
  }
}
