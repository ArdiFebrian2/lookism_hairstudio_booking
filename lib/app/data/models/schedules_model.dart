class ScheduleModel {
  final String id;
  final String barberId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isBooked;

  ScheduleModel({
    required this.id,
    required this.barberId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory ScheduleModel.fromJson(String id, Map<String, dynamic> json) {
    return ScheduleModel(
      id: id,
      barberId: json['barberId'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['isBooked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "barberId": barberId,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "isBooked": isBooked,
    };
  }
}
