import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/controllers/home_customer_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class HomeCustomerBinding extends Bindings {
  @override
  void dependencies() {
    // Put ServiceController first since HomeCustomerController depends on it
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<HomeCustomerController>(() => HomeCustomerController());
  }
}
