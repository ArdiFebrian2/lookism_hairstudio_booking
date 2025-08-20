import 'package:get/get.dart';

import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/home_barber/bindings/home_barber_binding.dart';
import '../modules/home_barber/views/home_barber_view.dart';
import '../modules/home_customer/bindings/home_customer_binding.dart';
import '../modules/home_customer/views/home_customer_view.dart';
import '../modules/jadwal_baberman/bindings/jadwal_baberman_binding.dart';
import '../modules/jadwal_baberman/views/jadwal_baberman_view.dart';
import '../modules/kelola_baberman/bindings/kelola_baberman_binding.dart';
import '../modules/kelola_baberman/views/kelola_baberman_view.dart';
import '../modules/kelola_layanan/bindings/kelola_layanan_binding.dart';
import '../modules/kelola_layanan/views/kelola_layanan_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar_admin/bindings/navbar_admin_binding.dart';
import '../modules/navbar_admin/views/navbar_admin_view.dart';
import '../modules/navbar_baberman/bindings/navbar_baberman_binding.dart';
import '../modules/navbar_baberman/views/navbar_baberman_view.dart';
import '../modules/navbar_customer/bindings/navbar_customer_binding.dart';
import '../modules/navbar_customer/views/navbar_customer_view.dart';
import '../modules/pending_customer/bindings/pending_customer_binding.dart';
import '../modules/pending_customer/views/pending_customer_view.dart';
import '../modules/profile_admin/bindings/profile_admin_binding.dart';
import '../modules/profile_admin/views/profile_admin_view.dart';
import '../modules/profile_baberman/bindings/profile_baberman_binding.dart';
import '../modules/profile_baberman/views/profile_baberman_view.dart';
import '../modules/profile_customer/bindings/profile_customer_binding.dart';
import '../modules/profile_customer/views/profile_customer_view.dart';
import '../modules/rating_customer/bindings/rating_customer_binding.dart';
import '../modules/rating_customer/views/rating_customer_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../modules/review_customer/bindings/review_customer_binding.dart';
import '../modules/review_customer/views/review_customer_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/riwayat_baberman/bindings/riwayat_baberman_binding.dart';
import '../modules/riwayat_baberman/views/riwayat_baberman_view.dart';
import '../modules/schedules/bindings/schedules_binding.dart';
import '../modules/schedules/controllers/schedules_controller.dart';
import '../modules/schedules/views/schedules_view.dart';
import '../modules/service/bindings/service_binding.dart';
import '../modules/service/views/service_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME_CUSTOMER,
      page: () => const HomeCustomerView(),
      binding: HomeCustomerBinding(),
    ),
    GetPage(
      name: _Paths.HOME_BARBER,
      page: () => const HomeBarberView(),
      binding: HomeBarberBinding(),
    ),
    GetPage(
      name: _Paths.HOME_ADMIN,
      page: () => const HomeAdminView(),
      binding: HomeAdminBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR_ADMIN,
      page: () => NavbarAdminView(),
      binding: NavbarAdminBinding(),
    ),

    GetPage(
      name: _Paths.LAPORAN,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR_CUSTOMER,
      page: () => const NavbarCustomerView(),
      binding: NavbarCustomerBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_CUSTOMER,
      page: () => const ProfileCustomerView(),
      binding: ProfileCustomerBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_ADMIN,
      page: () => const ProfileAdminView(),
      binding: ProfileAdminBinding(),
    ),
    GetPage(
      name: _Paths.KELOLA_BABERMAN,
      page: () => const KelolaBabermanView(),
      binding: KelolaBabermanBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL_BABERMAN,
      page: () => const JadwalBabermanView(),
      binding: JadwalBabermanBinding(),
    ),
    GetPage(
      name: _Paths.KELOLA_LAYANAN,
      page: () => const KelolaLayananView(),
      binding: KelolaLayananBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR_BABERMAN,
      page: () => const NavbarBabermanView(),
      binding: NavbarBabermanBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_BABERMAN,
      page: () => const ProfileBabermanView(),
      binding: ProfileBabermanBinding(),
    ),

    GetPage(
      name: _Paths.SERVICE,
      page: () => ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.RATING_CUSTOMER,
      page: () => const RatingCustomerView(),
      binding: RatingCustomerBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_CUSTOMER,
      page: () => const ReviewCustomerView(),
      binding: ReviewCustomerBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_BABERMAN,
      page: () => RiwayatBabermanView(),
      binding: RiwayatBabermanBinding(),
    ),
    GetPage(
      name: '/schedules',
      page:
          () => SchedulesView(barberId: 'uid_barberman'), // inject sesuai login
      binding: BindingsBuilder(() {
        Get.put(SchedulesController());
      }),
    ),
    GetPage(
      name: _Paths.PENDING_CUSTOMER,
      page: () => PendingCustomerView(),
      binding: PendingCustomerBinding(),
    ),
  ];
}
