class LectureStatisticsResponse {
  final bool status;
  final String message;
  final int total_attendance_count;
  final int attends_count;
  final int late_count;
  final int forgot_book_count;
  final int absence_count;
  final int students_count;
  final int disabled_count;
  LectureStatisticsResponse({
    required this.status,
    required this.message,
    required this.total_attendance_count,
    required this.attends_count,
    required this.late_count,
    required this.forgot_book_count,
    required this.absence_count,
    required this.students_count,
    required this.disabled_count,
  });
  factory LectureStatisticsResponse.fromMap(Map<String, dynamic> map) {
    return LectureStatisticsResponse(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      total_attendance_count: map['total_attendance_count']?.toInt() ?? 0,
      attends_count: map['attends_count']?.toInt() ?? 0,
      late_count: map['late_count']?.toInt() ?? 0,
      forgot_book_count: map['forgot_book_count']?.toInt() ?? 0,
      absence_count: map['absence_count']?.toInt() ?? 0,
      students_count: map['students_count']?.toInt() ?? 0,
      disabled_count: map['disabled_count']?.toInt() ?? 0,
    );
  }
}
