import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/report_model.dart';
import 'package:lookism_hairstudio_booking/app/data/services/report_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final reportService = ReportService();

  var reports = <ReportModel>[].obs;
  var selectedBarberId = ''.obs;
  var isLoading = false.obs;
  var daily = 0.0.obs;
  var weekly = 0.0.obs;
  var monthly = 0.0.obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  void fetchReportData() async {
    try {
      isLoading.value = true;
      final result = await reportService.fetchReports(
        barberId: selectedBarberId.value,
        start: selectedStartDate.value,
        end: selectedEndDate.value,
      );
      reports.value = result;
      calculateIncomes();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data laporan");
    } finally {
      isLoading.value = false;
    }
  }

  void createReportFromBooking(DocumentSnapshot bookingDoc) async {
    final data = bookingDoc.data() as Map<String, dynamic>;
    await FirebaseFirestore.instance.collection('reports').add({
      'barberman_id': data['barberman_id'],
      'barberman_name': data['barberman_name'],
      'customer_name': data['customer_name'],
      'service_name': data['service_name'],
      'service_price': data['service_price'],
      'booking_date': data['booking_date'],
      'payment_method': data['payment_method'],
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  void calculateIncomes() {
    final now = DateTime.now();
    daily.value = 0;
    weekly.value = 0;
    monthly.value = 0;

    for (var report in reports) {
      if (_isSameDay(report.createdAt, now)) {
        daily.value += report.amount;
      }
      if (_isSameWeek(report.createdAt, now)) {
        weekly.value += report.amount;
      }
      if (_isSameMonth(report.createdAt, now)) {
        monthly.value += report.amount;
      }
    }
  }

  void exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Laporan Transaksi", style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 16),
                ...reports.map(
                  (r) => pw.Text(
                    "${DateFormat('dd-MM-yyyy').format(r.createdAt)} - ${r.barberName} - ${r.serviceName} - Rp ${r.amount.toStringAsFixed(0)}",
                  ),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSameWeek(DateTime date, DateTime reference) {
    final monday = reference.subtract(Duration(days: reference.weekday - 1));
    final sunday = monday.add(Duration(days: 6));
    return date.isAfter(monday.subtract(Duration(seconds: 1))) &&
        date.isBefore(sunday.add(Duration(days: 1)));
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}
