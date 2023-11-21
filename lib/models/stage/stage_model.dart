class StageModel {
  int id;
  int stageTypeId;
  String title;
  String stageType;

  StageModel({
    required this.id,
    required this.stageTypeId,
    required this.title,
    required this.stageType,
  });
  factory StageModel.empty() {
    return StageModel(id: 0, stageTypeId: 0, title: '', stageType: '');
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'] as int,
      stageTypeId: json['stage_type_id'] as int,
      title: json['title'] as String,
      stageType: json['stage_type'] as String,
    );
  }

  String get fullTitle => '$title ($stageType)';
}
