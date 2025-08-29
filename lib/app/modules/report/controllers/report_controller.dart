import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final reports = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Variabel untuk menyimpan filter yang sedang aktif
  String? selectedMonth;
  int? selectedYear;
  DateTime? selectedDate;

  // Tambahan data analytics
  final analytics = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  void fetchReports({String? month, int? year, DateTime? date}) async {
    isLoading.value = true;

    try {
      // Update filter variables ketika method dipanggil
      selectedMonth = month;
      selectedYear = year;
      selectedDate = date;

      Query query = FirebaseFirestore.instance.collection('reports');

      if (date != null) {
        // Filter berdasarkan tanggal spesifik
        final start = DateTime(date.year, date.month, date.day);
        final end = start.add(const Duration(days: 1));
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: start)
            .where('createdAt', isLessThan: end);
      } else if (month != null && year != null) {
        final m = int.parse(month);
        final startDate = DateTime(year, m, 1);
        final endDate =
            (m == 12)
                ? DateTime(
                  year + 1,
                  1,
                  1,
                ) // kalau Desember, ke Januari tahun berikutnya
                : DateTime(year, m + 1, 1);

        query = query
            .where('createdAt', isGreaterThanOrEqualTo: startDate)
            .where('createdAt', isLessThan: endDate);
      } else if (year != null) {
        // Filter berdasarkan tahun saja menggunakan createdAt
        final startDate = DateTime(year, 1, 1);
        final endDate = DateTime(year + 1, 1, 1);
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: startDate)
            .where('createdAt', isLessThan: endDate);
      }

      // Urutkan berdasarkan createdAt
      final snapshot = await query.orderBy('createdAt', descending: true).get();

      print('🔍 Query result: ${snapshot.docs.length} documents found');
      print('🔍 Filter applied - Month: $month, Year: $year, Date: $date');

      List<Map<String, dynamic>> tempReports = [];

      // Ambil semua user baberman dan layanan
      final barberSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'baberman')
              .get();

      final servicesSnapshot =
          await FirebaseFirestore.instance.collection('services').get();

      final barberMap = {
        for (var doc in barberSnapshot.docs)
          doc.id: (doc.data() as Map<String, dynamic>)['nama'] ?? '-',
      };

      final serviceMap = {
        for (var doc in servicesSnapshot.docs)
          doc.id: doc.data() as Map<String, dynamic>,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Debug: print document data
        print('📄 Document ID: ${doc.id}');
        print('📄 Document data: ${data.keys}');

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
          data['time'] = DateFormat(
            'HH:mm',
            'id_ID',
          ).format(createdDate); // Tambahan waktu
          data['fullDateTime'] = createdDate;

          print('📅 CreatedAt: $createdDate');
        } else if (data['createdAt'] is DateTime) {
          data['day'] = DateFormat.EEEE('id_ID').format(data['createdAt']);
          data['date'] = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(data['createdAt']);
          data['time'] = DateFormat('HH:mm', 'id_ID').format(data['createdAt']);
          data['fullDateTime'] = data['createdAt'];
        } else {
          data['day'] = '-';
          data['date'] = '-';
          data['time'] = '-';
          print('⚠️ CreatedAt field missing or invalid format');
        }

        tempReports.add(data);
      }

      reports.value = tempReports;

      // Hitung analytics setelah data ter-load
      calculateAnalytics();

      print('✅ Total reports loaded: ${tempReports.length}');
    } catch (e, st) {
      print('❌ Error di fetchReports: $e');
      print(st);
      Get.snackbar('Error', 'Gagal mengambil data laporan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk menghitung analytics
  void calculateAnalytics() {
    if (reports.isEmpty) {
      analytics.value = {};
      return;
    }

    final totalRevenue = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
    );

    final totalBookings = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalBookings'] ?? 0) as int),
    );

    // Rata-rata pendapatan per hari
    final averageRevenuePerDay =
        reports.isNotEmpty ? totalRevenue / reports.length : 0;

    // Rata-rata booking per hari
    final averageBookingsPerDay =
        reports.isNotEmpty ? totalBookings / reports.length : 0;

    // Hari terbaik (pendapatan tertinggi)
    Map<String, dynamic>? bestDay;
    int maxRevenue = 0;
    for (var report in reports) {
      final revenue = (report['totalRevenue'] ?? 0) as int;
      if (revenue > maxRevenue) {
        maxRevenue = revenue;
        bestDay = report;
      }
    }

    // Performance per baberman
    Map<String, Map<String, dynamic>> barberPerformance = {};
    for (var report in reports) {
      final barberName = report['barbermanName'] ?? 'Unknown';
      if (!barberPerformance.containsKey(barberName)) {
        barberPerformance[barberName] = {
          'totalRevenue': 0,
          'totalBookings': 0,
          'days': 0,
        };
      }
      barberPerformance[barberName]!['totalRevenue'] +=
          (report['totalRevenue'] ?? 0) as int;
      barberPerformance[barberName]!['totalBookings'] +=
          (report['totalBookings'] ?? 0) as int;
      barberPerformance[barberName]!['days']++;
    }

    // Top performer
    String topBarber = '';
    int topBarberRevenue = 0;
    barberPerformance.forEach((name, data) {
      if (data['totalRevenue'] > topBarberRevenue) {
        topBarberRevenue = data['totalRevenue'];
        topBarber = name;
      }
    });

    // Performance per hari dalam seminggu
    Map<String, Map<String, dynamic>> dayPerformance = {};
    for (var report in reports) {
      final day = report['day'] ?? 'Unknown';
      if (!dayPerformance.containsKey(day)) {
        dayPerformance[day] = {
          'totalRevenue': 0,
          'totalBookings': 0,
          'count': 0,
        };
      }
      dayPerformance[day]!['totalRevenue'] +=
          (report['totalRevenue'] ?? 0) as int;
      dayPerformance[day]!['totalBookings'] +=
          (report['totalBookings'] ?? 0) as int;
      dayPerformance[day]!['count']++;
    }

    // Trend analysis (jika ada data lebih dari 1)
    String trend = 'Stabil';
    if (reports.length > 1) {
      final sortedReports = List<Map<String, dynamic>>.from(reports);
      sortedReports.sort((a, b) {
        if (a['fullDateTime'] != null && b['fullDateTime'] != null) {
          return (a['fullDateTime'] as DateTime).compareTo(
            b['fullDateTime'] as DateTime,
          );
        }
        return 0;
      });

      final firstHalf = sortedReports.take(sortedReports.length ~/ 2);
      final secondHalf = sortedReports.skip(sortedReports.length ~/ 2);

      final firstHalfRevenue = firstHalf.fold<int>(
        0,
        (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
      );
      final secondHalfRevenue = secondHalf.fold<int>(
        0,
        (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
      );

      if (secondHalfRevenue > firstHalfRevenue * 1.1) {
        trend = 'Meningkat';
      } else if (secondHalfRevenue < firstHalfRevenue * 0.9) {
        trend = 'Menurun';
      }
    }

    analytics.value = {
      'totalRevenue': totalRevenue,
      'totalBookings': totalBookings,
      'averageRevenuePerDay': averageRevenuePerDay,
      'averageBookingsPerDay': averageBookingsPerDay,
      'bestDay': bestDay,
      'barberPerformance': barberPerformance,
      'topBarber': topBarber,
      'topBarberRevenue': topBarberRevenue,
      'dayPerformance': dayPerformance,
      'trend': trend,
      'totalDays': reports.length,
    };
  }

  // Method untuk reset filter
  void resetFilter() {
    selectedMonth = null;
    selectedYear = null;
    selectedDate = null;
    fetchReports();
  }

  // Method untuk mendapatkan range tanggal yang lebih akurat
  String getDateRangeText() {
    if (selectedDate != null) {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate!);
    } else if (selectedMonth != null || selectedYear != null) {
      if (selectedMonth != null && selectedYear != null) {
        final monthName = DateFormat(
          'MMMM',
          'id_ID',
        ).format(DateTime(selectedYear!, int.parse(selectedMonth!)));
        return '$monthName $selectedYear';
      } else if (selectedMonth != null) {
        final monthName = DateFormat(
          'MMMM',
          'id_ID',
        ).format(DateTime(DateTime.now().year, int.parse(selectedMonth!)));
        return monthName;
      } else if (selectedYear != null) {
        return selectedYear.toString();
      }
    }
    return 'Semua Data';
  }

  Future<void> generatePdf() async {
    print('🔄 Starting PDF generation...');
    print('📊 Current reports count: ${reports.length}');
    print(
      '🗓️ Selected filters - Month: $selectedMonth, Year: $selectedYear, Date: $selectedDate',
    );

    // Pastikan ada data untuk dicetak
    if (reports.isEmpty) {
      print('❌ No reports data available');
      Get.snackbar(
        'Info',
        'Tidak ada data untuk dicetak. Pastikan filter yang dipilih memiliki data.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );
      return;
    }

    final pdf = pw.Document();
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final analyticsData = analytics.value;
    final totalRevenue = analyticsData['totalRevenue'] ?? 0;
    final totalBookings = analyticsData['totalBookings'] ?? 0;
    final averageRevenuePerDay = analyticsData['averageRevenuePerDay'] ?? 0.0;
    final averageBookingsPerDay = analyticsData['averageBookingsPerDay'] ?? 0.0;

    // Get date range for report menggunakan method yang sudah diperbaiki
    final dateRange = getDateRangeText();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
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
                    'Laporan Pendapatan & Analisis Bisnis',
                    style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Periode: $dateRange',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Summary Section (4 cards)
            pw.Row(
              children: [
                // Total Bookings Card
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
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
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          '$totalBookings',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange900,
                          ),
                        ),
                        pw.Text(
                          'transaksi',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.orange700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 10),

                // Total Revenue Card
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
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
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          currency.format(totalRevenue),
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 10),

                // Average Revenue Card
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.purple50,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColors.purple200,
                        width: 1,
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'RATA-RATA/HARI',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.purple800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          currency.format(averageRevenuePerDay.toInt()),
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.purple900,
                          ),
                        ),
                        pw.Text(
                          '${averageBookingsPerDay.toStringAsFixed(1)} booking',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.purple700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 10),

                // Trend Card
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.cyan50,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: PdfColors.cyan200, width: 1),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TREN BISNIS',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.cyan800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          analyticsData['trend'] ?? 'Stabil',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.cyan900,
                          ),
                        ),
                        pw.Text(
                          '${analyticsData['totalDays'] ?? 0} hari',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.cyan700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Performance Analysis Section
            if (analyticsData['barberPerformance'] != null) ...[
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
                  'ANALISIS PERFORMA BABERMAN',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),

              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1),
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
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(2.5),
                    3: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Nama Baberman',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Total Booking',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Total Pendapatan',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Rata-rata/Hari',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Data rows
                    ...((analyticsData['barberPerformance']
                                    as Map<String, Map<String, dynamic>>?)
                                ?.entries
                                .toList() ??
                            [])
                        .map((entry) {
                          final name = entry.key;
                          final data = entry.value;
                          final avgPerDay =
                              data['days'] > 0
                                  ? data['totalRevenue'] / data['days']
                                  : 0;

                          return pw.TableRow(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  name,
                                  style: pw.TextStyle(fontSize: 9),
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  '${data['totalBookings']}',
                                  style: pw.TextStyle(fontSize: 9),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  currency.format(data['totalRevenue']),
                                  style: pw.TextStyle(fontSize: 9),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  currency.format(avgPerDay.toInt()),
                                  style: pw.TextStyle(fontSize: 9),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        })
                        .toList(),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),
            ],

            // Best Performance Highlight
            if (analyticsData['bestDay'] != null) ...[
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.yellow50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.yellow300, width: 1),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '🏆 PERFORMA TERBAIK',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.orange800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'Tanggal: ${analyticsData['bestDay']['date']} (${analyticsData['bestDay']['day']})',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            'Pendapatan: ${currency.format(analyticsData['bestDay']['totalRevenue'])}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green700,
                            ),
                          ),
                          pw.Text(
                            'Booking: ${analyticsData['bestDay']['totalBookings']} transaksi',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '👑 TOP PERFORMER',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.purple800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'Baberman: ${analyticsData['topBarber']}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.Text(
                            'Total Pendapatan: ${currency.format(analyticsData['topBarberRevenue'])}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.purple700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),
            ],

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
                'DETAIL LAPORAN HARIAN (${reports.length} data)',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),

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
                  0: const pw.FlexColumnWidth(2), // Tanggal
                  1: const pw.FlexColumnWidth(1.2), // Hari
                  2: const pw.FlexColumnWidth(1), // Waktu
                  3: const pw.FlexColumnWidth(2.5), // Nama Baberman
                  4: const pw.FlexColumnWidth(1.2), // Total Booking
                  5: const pw.FlexColumnWidth(2), // Total Pendapatan
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Tanggal',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Hari',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Waktu',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Nama Baberman',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Booking',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Pendapatan',
                          style: pw.TextStyle(
                            fontSize: 10,
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
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item['date'] ?? '-',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey800,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item['day'] ?? '-',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item['time'] ?? '-',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item['barbermanName'] ?? '-',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey800,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item['totalBookings']?.toString() ?? '0',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.orange700,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            currency.format(item['totalRevenue'] ?? 0),
                            style: pw.TextStyle(
                              fontSize: 9,
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

            pw.SizedBox(height: 20),

            // Insights Section
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.blue200, width: 1),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '📊 RINGKASAN & REKOMENDASI',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 12),

                  if (analyticsData['dayPerformance'] != null) ...[
                    pw.Text(
                      'Performa Berdasarkan Hari:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 6),

                    ...((analyticsData['dayPerformance']
                                    as Map<String, Map<String, dynamic>>?)
                                ?.entries
                                .toList() ??
                            [])
                        .take(3)
                        .map((entry) {
                          final dayName = entry.key;
                          final dayData = entry.value;
                          final avgRevenue =
                              dayData['count'] > 0
                                  ? dayData['totalRevenue'] / dayData['count']
                                  : 0;

                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2),
                            child: pw.Text(
                              '• $dayName: Rata-rata ${currency.format(avgRevenue.toInt())}/hari (${dayData['count']} hari kerja)',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColors.grey700,
                              ),
                            ),
                          );
                        })
                        .toList(),

                    pw.SizedBox(height: 10),
                  ],

                  // Rekomendasi otomatis berdasarkan trend
                  pw.Text(
                    'Rekomendasi:',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 6),

                  if (analyticsData['trend'] == 'Meningkat') ...[
                    pw.Text(
                      '• Tren bisnis menunjukkan peningkatan yang baik. Pertahankan kualitas layanan dan pertimbangkan untuk menambah kapasitas.',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.green700,
                      ),
                    ),
                  ] else if (analyticsData['trend'] == 'Menurun') ...[
                    pw.Text(
                      '• Tren bisnis mengalami penurunan. Evaluasi strategi marketing dan kualitas layanan untuk meningkatkan customer retention.',
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.red700),
                    ),
                  ] else ...[
                    pw.Text(
                      '• Bisnis dalam kondisi stabil. Fokus pada inovasi layanan dan ekspansi customer base untuk pertumbuhan lebih lanjut.',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.blue700,
                      ),
                    ),
                  ],

                  pw.SizedBox(height: 4),

                  if (averageRevenuePerDay > 0) ...[
                    pw.Text(
                      '• Target harian optimal: ${currency.format((averageRevenuePerDay * 1.2).toInt())} (20% di atas rata-rata saat ini)',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],

                  if (analyticsData['topBarber'] != null &&
                      analyticsData['topBarber'] != '') ...[
                    pw.Text(
                      '• ${analyticsData['topBarber']} menunjukkan performa terbaik. Pertimbangkan untuk berbagi best practices ke baberman lain.',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
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
                    'Laporan ini dibuat secara otomatis oleh sistem | Confidential Business Report',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    try {
      print('📄 Generating enhanced PDF...');
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      print('✅ Enhanced PDF generated successfully');
      Get.snackbar(
        'Success',
        'Laporan lengkap berhasil dibuat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );
    } catch (e) {
      print('❌ Error generate PDF: $e');
      Get.snackbar(
        'Error',
        'Gagal membuat PDF: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    }
  }

  // Method tambahan untuk export data ke CSV
  Future<void> exportToCsv() async {
    if (reports.isEmpty) {
      Get.snackbar(
        'Info',
        'Tidak ada data untuk di-export',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final csv = StringBuffer();

      // Header CSV
      csv.writeln(
        'Tanggal,Hari,Waktu,Nama Baberman,Total Booking,Total Pendapatan',
      );

      // Data rows
      for (var report in reports) {
        csv.writeln(
          '${report['date'] ?? '-'},'
          '${report['day'] ?? '-'},'
          '${report['time'] ?? '-'},'
          '${report['barbermanName'] ?? '-'},'
          '${report['totalBookings'] ?? 0},'
          '${report['totalRevenue'] ?? 0}',
        );
      }

      // Untuk implementasi lengkap, Anda perlu menambahkan package seperti path_provider
      // dan implementasi file saving sesuai platform

      print('📊 CSV data ready: ${csv.length} characters');
      Get.snackbar(
        'Info',
        'Fitur export CSV akan segera tersedia',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('❌ Error export CSV: $e');
      Get.snackbar(
        'Error',
        'Gagal export CSV: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Method untuk mendapatkan summary analytics yang bisa digunakan di UI
  Map<String, dynamic> getSummaryAnalytics() {
    return analytics.value;
  }

  // Method untuk mendapatkan top performers
  List<Map<String, dynamic>> getTopPerformers({int limit = 5}) {
    final barberPerformance =
        analytics.value['barberPerformance']
            as Map<String, Map<String, dynamic>>? ??
        {};

    final performers =
        barberPerformance.entries.map((entry) {
          return {
            'name': entry.key,
            'totalRevenue': entry.value['totalRevenue'],
            'totalBookings': entry.value['totalBookings'],
            'days': entry.value['days'],
            'averagePerDay':
                entry.value['days'] > 0
                    ? entry.value['totalRevenue'] / entry.value['days']
                    : 0,
          };
        }).toList();

    performers.sort(
      (a, b) => (b['totalRevenue'] as int).compareTo(a['totalRevenue'] as int),
    );

    return performers.take(limit).toList();
  }

  // Method untuk mendapatkan performance by day of week
  Map<String, Map<String, dynamic>> getDayOfWeekPerformance() {
    return (analytics.value['dayPerformance']
            as Map<String, Map<String, dynamic>>?) ??
        {};
  }
}
