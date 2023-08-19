import 'package:alqamar/models/stage/stage_type_model.dart';

class StagesResponse {
  bool status;
  String message;
  List<StageTypeModel> stageTypes;

  StagesResponse({
    required this.status,
    required this.message,
    required this.stageTypes,
  });

  factory StagesResponse.fromJson(Map<String, dynamic> json) {
    final stageTypesList = (json['stage_types'] as List<dynamic>)
        .map((stageTypeJson) => StageTypeModel.fromJson(stageTypeJson))
        .toList();

    return StagesResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      stageTypes: stageTypesList,
    );
  }
}
