import 'package:get/get.dart';

import '../modules/admin_notifikasi/bindings/admin_notifikasi_binding.dart';
import '../modules/admin_notifikasi/views/admin_notifikasi_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/home_barber/bindings/home_barber_binding.dart';
import '../modules/home_barber/views/home_barber_view.dart';
import '../modules/home_customer/bindings/home_customer_binding.dart';
import '../modules/home_customer/views/home_customer_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/layanan/bindings/layanan_binding.dart';
import '../modules/layanan/views/layanan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/manajemen/bindings/manajemen_binding.dart';
import '../modules/manajemen/views/manajemen_view.dart';
import '../modules/navbar_admin/bindings/navbar_admin_binding.dart';
import '../modules/navbar_admin/views/navbar_admin_view.dart';
import '../modules/navbar_customer/bindings/navbar_customer_binding.dart';
import '../modules/navbar_customer/views/navbar_customer_view.dart';
import '../modules/pembayaran/bindings/pembayaran_binding.dart';
import '../modules/pembayaran/views/pembayaran_view.dart';
import '../modules/pemesanan/bindings/pemesanan_binding.dart';
import '../modules/pemesanan/views/pemesanan_view.dart';
import '../modules/profile_admin/bindings/profile_admin_binding.dart';
import '../modules/profile_admin/views/profile_admin_view.dart';
import '../modules/profile_customer/bindings/profile_customer_binding.dart';
import '../modules/profile_customer/views/profile_customer_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
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
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.MANAJEMEN,
      page: () => const ManajemenView(),
      binding: ManajemenBinding(),
    ),
    GetPage(
      name: _Paths.PEMESANAN,
      page: () => const PemesananView(),
      binding: PemesananBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_NOTIFIKASI,
      page: () => const AdminNotifikasiView(),
      binding: AdminNotifikasiBinding(),
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
      name: _Paths.LAYANAN,
      page: () => const LayananView(),
      binding: LayananBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.PEMBAYARAN,
      page: () => const PembayaranView(),
      binding: PembayaranBinding(),
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
  ];
}
