import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/stage_data/stage_data_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StageItem extends StatelessWidget {
  const StageItem({
    super.key,
    required this.stage,
  });

  final StageModel stage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Methods.navigateTo(context, StageDataScreen(stage: stage));
      },
      child: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 10.w, top: 8.h, bottom: 10.h),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward,
              color: ColorManager.white,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Colors.amber,
                  title: TextWidget(
                    label: stage.fullTitle,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
