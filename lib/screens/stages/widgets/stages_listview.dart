import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/stages/widgets/stage_item.dart';
import 'package:flutter/material.dart';

class StagesListView extends StatelessWidget {
  const StagesListView({
    super.key,
    required this.stages,
  });

  final List<StageModel> stages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        final stage = stages[index];
        return StageItem(stage: stage);
      },
      itemCount: stages.length,
    );
  }
}
