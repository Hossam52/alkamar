import 'package:alqamar/cubits/app_cubit/app_cubit.dart';
import 'package:alqamar/cubits/app_cubit/app_states.dart';
import 'package:alqamar/models/stage/stage_type_model.dart';
import 'package:alqamar/screens/stages/widgets/stage_type_item.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/search_student_field.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StagesScreen extends StatefulWidget {
  const StagesScreen({Key? key}) : super(key: key);

  @override
  State<StagesScreen> createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.instance(context).getStages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
        label: 'القمر',
      )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8.w),
                child: SearchStudentField(
                  onPressed: () {
                    AppCubit.instance(context).navigateToSearchGlobal();
                  },
                ),
              ),
              Expanded(
                child: AppBlocBuilder(
                  builder: (context, state) {
                    final appCubit = AppCubit.instance(context);
                    final stageTypes = appCubit.stageTypes;
                    if (state is GetHomeDataLoadingState) {
                      return const Center(child: DefaultLoader());
                    }
                    if (appCubit.notLoadedStages) {
                      return CustomErrorWidget(
                        onPressed: () {
                          appCubit.getStages();
                        },
                      );
                    }
                    return _StageTypes(stageTypes: stageTypes);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StageTypes extends StatelessWidget {
  const _StageTypes({
    required this.stageTypes,
  });

  final List<StageTypeModel> stageTypes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      itemBuilder: (_, index) {
        final stageType = stageTypes[index];
        return StageTypeItem(stageType: stageType);
      },
      itemCount: stageTypes.length,
    );
  }
}
