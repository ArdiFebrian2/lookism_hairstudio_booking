import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final reports = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  String? selectedMonth;
  int? selectedYear;
  DateTime? selectedDate;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  void fetchReports({String? month, int? year, DateTime? date}) async {
    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance.collection('reports');

      if (date != null) {
        final start = DateTime(date.year, date.month, date.day);
        final end = start.add(const Duration(days: 1));
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: start)
            .where('createdAt', isLessThan: end);
      } else {
        if (month != null) {
          query = query.where('month', isEqualTo: month);
        }
        if (year != null) {
          query = query
              .where('month', isGreaterThanOrEqualTo: '$year-01')
              .where('month', isLessThanOrEqualTo: '$year-12');
        }
      }

      // Hindari orderBy error jika month bisa null → urutkan berdasarkan createdAt saja
      final snapshot = await query.orderBy('createdAt', descending: true).get();

      List<Map<String, dynamic>> tempReports = [];

      // Ambil semua user baberman
      final barberSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'baberman')
              .get();

      final barberMap = {
        for (var doc in barberSnapshot.docs)
          doc.id: (doc.data() as Map<String, dynamic>)['nama'] ?? '-',
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Fallback ambil ID baberman
        final babermanId = data['barbermanId'] ?? data['serviceId'];

        // Ambil nama baberman → kalau tidak ada di users, pakai yang tersimpan di reports
        data['barbermanName'] =
            barberMap[babermanId] ?? (data['barbermanName'] ?? '-');

        // Ambil hari & tanggal dari createdAt
        if (data['createdAt'] is Timestamp) {
          final createdDate = (data['createdAt'] as Timestamp).toDate();
          data['day'] = DateFormat.EEEE('id_ID').format(createdDate); // Senin
          data['date'] = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(createdDate); // 12 Agu 2025
        } else if (data['createdAt'] is DateTime) {
          data['day'] = DateFormat.EEEE('id_ID').format(data['createdAt']);
          data['date'] = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(data['createdAt']);
        } else {
          data['day'] = '-';
          data['date'] = '-';
        }

        tempReports.add(data);
      }

      reports.value = tempReports;
    } catch (e, st) {
      print('❌ Error di fetchReports: $e');
      print(st);
      Get.snackbar('Error', 'Gagal mengambil data laporan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final totalRevenue = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
    );

    final totalBookings = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalBookings'] ?? 0) as int),
    );

    // Get date range for report
    String dateRange = '';
    if (selectedDate != null) {
      dateRange = DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate!);
    } else if (selectedMonth != null || selectedYear != null) {
      if (selectedMonth != null && selectedYear != null) {
        final monthName = DateFormat(
          'MMMM',
          'id_ID',
        ).format(DateTime(selectedYear!, int.parse(selectedMonth!)));
        dateRange = '$monthName $selectedYear';
      } else if (selectedMonth != null) {
        final monthName = DateFormat(
          'MMMM',
          'id_ID',
        ).format(DateTime(DateTime.now().year, int.parse(selectedMonth!)));
        dateRange = monthName;
      } else if (selectedYear != null) {
        dateRange = selectedYear.toString();
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.blue200, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'LOOKISM HAIRSTUDIO',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Laporan Pendapatan',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    // pw.Text(
                    //   'Periode: $dateRange',
                    //   style: pw.TextStyle(
                    //     fontSize: 14,
                    //     color: PdfColors.grey600,
                    //   ),
                    // ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Summary Section
              pw.Row(
                children: [
                  // Total Bookings Card
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.orange50,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(
                          color: PdfColors.orange200,
                          width: 1,
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'TOTAL BOOKING',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.orange800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            '$totalBookings',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.orange900,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'transaksi',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.orange700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 20),

                  // Total Revenue Card
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green50,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(
                          color: PdfColors.green200,
                          width: 1,
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'TOTAL PENDAPATAN',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            currency.format(totalRevenue),
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Detail Section Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey800,
                  borderRadius: const pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(8),
                    topRight: pw.Radius.circular(8),
                  ),
                ),
                child: pw.Text(
                  'DETAIL LAPORAN (${reports.length} data)',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),

              pw.SizedBox(height: 10),

              // Table
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1),
                  borderRadius: const pw.BorderRadius.only(
                    bottomLeft: pw.Radius.circular(8),
                    bottomRight: pw.Radius.circular(8),
                  ),
                ),
                child: pw.Table(
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(
                      color: PdfColors.grey200,
                      width: 0.5,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.grey200,
                      width: 0.5,
                    ),
                  ),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2.5), // Tanggal
                    1: const pw.FlexColumnWidth(1.5), // Hari
                    2: const pw.FlexColumnWidth(3), // Nama Baberman
                    3: const pw.FlexColumnWidth(1.5), // Total Booking
                    4: const pw.FlexColumnWidth(2.5), // Total Pendapatan
                  },
                  children: [
                    // Header Row
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Tanggal',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Hari',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Nama Baberman',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Booking',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Pendapatan',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                    // Data Rows
                    ...reports.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isEven = index % 2 == 0;

                      return pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: isEven ? PdfColors.white : PdfColors.grey50,
                        ),
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              item['date'] ?? '-',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey800,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              item['day'] ?? '-',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              item['barbermanName'] ?? '-',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey800,
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              item['totalBookings']?.toString() ?? '0',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.orange700,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              currency.format(item['totalRevenue'] ?? 0),
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.green700,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.grey200, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Dicetak pada: ${DateFormat('dd MMMM yyyy - HH:mm', 'id_ID').format(DateTime.now())}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          'Lookism Hairstudio',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Laporan ini dibuat secara otomatis oleh sistem',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
