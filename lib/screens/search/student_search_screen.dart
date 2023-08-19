import 'package:alqamar/cubits/search_cubit/search_states.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alqamar/cubits/search_cubit/search_cubit.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/widgets/text_widget.dart';

class StudentSearchScreen extends StatelessWidget {
  const StudentSearchScreen({super.key, this.stage});
  final StageModel? stage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: TextWidget(
                label:
                    'بحث عن طالب ${stage == null ? '' : 'في ${stage?.title}'}')),
        body: BlocProvider(
          create: (_) => SearchCubit(stage: stage),
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [_SerachTextField(), Expanded(child: _StudentList())],
            ),
          )),
        ),
      ),
    );
  }
}

class _StudentList extends StatelessWidget {
  const _StudentList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBlocBuilder(builder: (context, state) {
      if (state is SerachStudentLoadingState) {
        return const Center(child: DefaultLoader());
      }
      final students = SearchCubit.instance(context).studentResults;
      return ListView.builder(
        itemBuilder: (_, index) => ListTile(
          onTap: () {
            Methods.navigateTo(
                context,
                StudentProfileScreen(
                  stageModel: SearchCubit.instance(context).stage,
                  studentId: students[index].id,
                ));
          },
          title: TextWidget(
              label:
                  '${students[index].generateCodeWithName} - ${students[index].stage}'),
        ),
        shrinkWrap: true,
        itemCount: students.length,
      );
    });
  }
}

abstract class SearchTerm {
  String searchTerm;
  String title;
  Future<void> Function()? onSearch;

  SearchTerm({
    required this.searchTerm,
    required this.title,
    this.onSearch,
  });
  TextInputType get getTextInputType;
}

class NameSearchTerm extends SearchTerm {
  NameSearchTerm({super.onSearch})
      : super(searchTerm: 'بحث بالاسم', title: 'الاسم');

  @override
  TextInputType get getTextInputType => TextInputType.name;
}

class CodeSearchTerm extends SearchTerm {
  CodeSearchTerm({super.onSearch})
      : super(searchTerm: 'بحث بالكود', title: 'الكود');

  @override
  TextInputType get getTextInputType => TextInputType.number;
}

class _SerachTextField extends StatefulWidget {
  const _SerachTextField({super.key});

  @override
  State<_SerachTextField> createState() => _SerachTextFieldState();
}

class _SerachTextFieldState extends State<_SerachTextField> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  SearchTerm? searchBy;
  late final NameSearchTerm searchByName =
      NameSearchTerm(onSearch: onSearchName);
  late final CodeSearchTerm searchByCode =
      CodeSearchTerm(onSearch: onSearchCode);

  Future<void> onSearchName() async {
    SearchCubit.instance(context).serachStudentByName(controller.text);
  }

  Future<void> onSearchCode() async {
    SearchCubit.instance(context).serachStudentByCode(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AuthTextField(
                    controller: controller,
                    label: searchBy?.title ?? '',
                    hint: searchBy?.searchTerm ?? '',
                    inputType: searchBy?.getTextInputType ?? TextInputType.name,
                    validationRules: const []),
              ),
              SizedBox(width: 15.w),
              CustomButton(
                text: 'بحث',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (searchBy != null && searchBy!.onSearch != null) {
                      searchBy!.onSearch!();
                    }
                  }
                },
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _customRadio(searchByName),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _customRadio(searchByCode),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _customRadio(SearchTerm? searchTerm) {
    return RadioListTile(
        visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: searchTerm,
        contentPadding: EdgeInsets.zero,
        dense: true,
        groupValue: searchBy,
        title: TextWidget(label: searchTerm?.searchTerm ?? ''),
        onChanged: (val) {
          setState(() {
            searchBy = val;
          });
        });
  }
}
