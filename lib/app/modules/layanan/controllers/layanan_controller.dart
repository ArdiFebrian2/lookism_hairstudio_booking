import 'package:get/get.dart';

class LayananController extends GetxController {
  var isLoading = true.obs;
  var layananList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLayanan();
  }

  void fetchLayanan() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading

    // Simulasi data layanan
    layananList.value = [
      {
        'nama': 'Haircut Standard',
        'deskripsi': 'Potongan rambut standar dan rapi.',
        'harga': 35000,
      },
      {
        'nama': 'Haircut + Cukur Jenggot',
        'deskripsi': 'Potong rambut dan cukur jenggot.',
        'harga': 50000,
      },
      {
        'nama': 'Hair Spa',
        'deskripsi': 'Perawatan rambut agar lebih sehat.',
        'harga': 60000,
      },
    ];

    isLoading.value = false;
  }
}
