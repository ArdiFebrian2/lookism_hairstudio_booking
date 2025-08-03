import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RiwayatBabermanController extends GetxController {
  var completedBookings = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedBookings();
  }

  void fetchCompletedBookings() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where('status', isEqualTo: 'selesai')
              .orderBy('datetime', descending: true)
              .get();

      final List<Map<String, dynamic>> bookingList = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        final String? userId = data['userId'];
        final String? serviceName = data['serviceName'];

        if (userId != null && userId.isNotEmpty) {
          try {
            final userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

            if (userDoc.exists) {
              final userData = userDoc.data();
              final bool isCustomer = (userData?['role'] == 'customer');

              if (isCustomer) {
                data['customerName'] = userData?['name'] ?? 'Tidak diketahui';
                data['customerEmail'] = userData?['email'] ?? '-';
                data['customerPhone'] = userData?['phone'] ?? '-';

                // 🔽 Ambil harga dari serviceName
                if (serviceName != null && serviceName.isNotEmpty) {
                  final serviceSnapshot =
                      await FirebaseFirestore.instance
                          .collection('services')
                          .where('name', isEqualTo: serviceName)
                          .limit(1)
                          .get();

                  if (serviceSnapshot.docs.isNotEmpty) {
                    data['price'] = serviceSnapshot.docs.first['price'];
                  } else {
                    data['price'] = 0; // atau default value
                  }
                }

                bookingList.add(data);
              }
            }
          } catch (e) {
            print('❌ Gagal ambil data user ($userId): $e');
          }
        }
      }

      completedBookings.value = bookingList;
    } catch (e) {
      print("Error fetching completed bookings: $e");
    }
  }
}
