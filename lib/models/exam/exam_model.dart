class ExamModel {
  int id;
  int stageId;
  String title;
  int maxGrade;
  String examDate;
  DateTime date = DateTime.now();
  bool withoutInteract;

  ExamModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.maxGrade,
    required this.examDate,
    this.withoutInteract = false,
  }) : date = DateTime.tryParse(examDate) ?? DateTime.now();

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      stageId: json['stage_id'],
      title: json['title'],
      maxGrade: json['max_grade'],
      examDate: json['exam_date'],
    );
  }
}
