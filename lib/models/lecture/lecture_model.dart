import 'package:alqamar/shared/methods.dart';

class LectureModel {
  int id;
  int stageId;
  String title;
  String lectureDate;
  DateTime date;
  LectureModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.lectureDate,
  }) : date = DateTime.parse(lectureDate);

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'],
      stageId: json['stage_id'],
      title: json['title'],
      lectureDate: json['lecture_date'],
    );
  }

  static List<LectureModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => LectureModel.fromJson(json)).toList();
  }

  String getContentReport({String name = ''}) {
    String text = '''
\t\t -  $name $title \t (${Methods.formatDate(date)})
''';

    return text;
  }
}
