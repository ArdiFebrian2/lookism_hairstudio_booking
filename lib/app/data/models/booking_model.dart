class BookingModel {
  final String id;
  final String bookingDate;
  final String bookingTime;
  final String status;
  final String serviceName;
  final String day;

  BookingModel({
    required this.id,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.serviceName,
    required this.day,
  });

  factory BookingModel.fromMap(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      bookingDate: data['booking_date'] ?? '',
      bookingTime: data['booking_time'] ?? '',
      status: data['status'] ?? '',
      serviceName: data['service_name'] ?? '', // ← nama layanan
      day: data['day'] ?? '', // ← hari
    );
  }
}
