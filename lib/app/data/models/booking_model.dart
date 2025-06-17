class BookingModel {
  final String id;
  final String bookingDate;
  final String bookingTime;
  final String status;

  BookingModel({
    required this.id,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
  });

  factory BookingModel.fromMap(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      bookingDate: data['booking_date'] ?? '',
      bookingTime: data['booking_time'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
