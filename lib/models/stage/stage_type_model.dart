import 'package:alqamar/models/stage/stage_model.dart';

class StageTypeModel {
  int id;
  String name;
  List<StageModel> stages;

  StageTypeModel({
    required this.id,
    required this.name,
    required this.stages,
  });

  factory StageTypeModel.fromJson(Map<String, dynamic> json) {
    final stagesList = (json['stages'] as List<dynamic>)
        .map((stageJson) => StageModel.fromJson(stageJson))
        .toList();

    return StageTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      stages: stagesList,
    );
  }
}
