class Reminder {
  final String id;
  final String title;
  final String message;
  final String dateTime;
  final String type; // e.g., medication, appointment, result
  final bool isRead;

  Reminder({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      dateTime:
          json['date_time']?.toString() ?? json['dateTime']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      isRead:
          json['is_read'] == 1 ||
          json['is_read'] == true ||
          json['isRead'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date_time': dateTime,
      'type': type,
      'is_read': isRead ? 1 : 0,
    };
  }
}
