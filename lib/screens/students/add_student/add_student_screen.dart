import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/cubits/stage_cubit/stage_states.dart';
import 'package:alqamar/models/gender_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student_status_enum.dart';
import 'package:alqamar/screens/auth/edit/change_phone_screen.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key, this.student}) : super(key: key);
  final StudentModel? student;
  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  GenderModel? selectedGender = genders[0];
  StudentStatus? selectedStudentStatus = StudentStatus.enabled;

  final codeController = TextEditingController();

  final nameController = TextEditingController();

  final schoolController = TextEditingController();

  final fatherPhoneController = TextEditingController();

  final motherPhoneController = TextEditingController();

  final studentPhoneController = TextEditingController();

  final whatsappController = TextEditingController();

  final addressController = TextEditingController();
  final problemsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _completeFatherPhone = '';
  String _completeMotherPhone = '';
  String _completeStudentPhone = '';
  String _completeWhatsPhone = '';

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      codeController.text = widget.student!.code.toString();
      nameController.text = widget.student!.name;
      schoolController.text = widget.student!.school;
      fatherPhoneController.text = replacePhone(widget.student!.fatherPhone);
      motherPhoneController.text = replacePhone(widget.student!.motherPhone);
      studentPhoneController.text = replacePhone(widget.student!.studentPhone);
      whatsappController.text = replacePhone(widget.student!.whatsapp);
      addressController.text = widget.student!.address;
      problemsController.text = widget.student!.problems;

      selectedStudentStatus = widget.student!.studentStatusEnum;

      _completeFatherPhone = widget.student!.fatherPhone;
      _completeMotherPhone = widget.student!.motherPhone;
      _completeStudentPhone = widget.student!.studentPhone;
      _completeWhatsPhone = widget.student!.whatsapp;
    }
  }

  String replacePhone(String phone) {
    return phone.characters.takeLast(10).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextWidget(
              label:
                  'تسجيل في ${StageCubit.instance(context).stage.fullTitle}')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  label: '*الكود',
                  hint: 'ادخل الكود',
                  validationRules: const [],
                  inputType: TextInputType.number,
                  controller: codeController,
                ),
                _space(),
                AuthTextField(
                  label: '*الاسم',
                  hint: 'ادخل الاسم',
                  validationRules: const [],
                  inputType: TextInputType.name,
                  controller: nameController,
                ),
                _space(),
                AuthTextField(
                  label: 'المدرسة',
                  hint: 'ادخل اسم المدرسة',
                  isRequired: false,
                  validationRules: const [],
                  inputType: TextInputType.text,
                  controller: schoolController,
                ),
                _space(),
                AuthTextField.customTextField(
                  isRequired: false,
                  textField: PhoneField(
                    controller: fatherPhoneController,
                    onChange: (phoneNumber) =>
                        _completeFatherPhone = phoneNumber,
                  ),
                  label: 'هاتف الاب',
                  controller: fatherPhoneController,
                ),
                _space(),
                AuthTextField.customTextField(
                  isRequired: false,
                  textField: PhoneField(
                    controller: motherPhoneController,
                    onChange: (phoneNumber) =>
                        _completeMotherPhone = phoneNumber,
                  ),
                  label: 'هاتف الام',
                  controller: motherPhoneController,
                ),
                _space(),
                AuthTextField.customTextField(
                  isRequired: false,
                  textField: PhoneField(
                    controller: studentPhoneController,
                    onChange: (phoneNumber) =>
                        _completeStudentPhone = phoneNumber,
                  ),
                  label: 'هاتف الطالب',
                  controller: studentPhoneController,
                ),
                _space(),
                AuthTextField.customTextField(
                  isRequired: false,
                  textField: PhoneField(
                    controller: whatsappController,
                    onChange: (phoneNumber) =>
                        _completeWhatsPhone = phoneNumber,
                  ),
                  label: 'رقم WhatsApp',
                  controller: whatsappController,
                ),
                _space(),
                AuthTextField(
                  label: 'العنوان',
                  hint: 'ادخل العنوان',
                  isRequired: false,
                  validationRules: const [],
                  inputType: TextInputType.text,
                  controller: addressController,
                ),
                AuthTextField(
                  label: 'مشاكل الطالب',
                  hint: '',
                  isRequired: false,
                  validationRules: const [],
                  inputType: TextInputType.text,
                  controller: problemsController,
                ),
                _space(),
                GenderRadioGroup(
                  label: 'النوع',
                  values: genders,
                  onSelected: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  selectedValue: selectedGender,
                ),
                _space(),
                StudentStatusRadioGroup(
                  label: 'حالة الطالب',
                  values: const [StudentStatus.disabled, StudentStatus.enabled],
                  onSelected: (value) {
                    setState(() {
                      selectedStudentStatus = value;
                    });
                  },
                  selectedValue: selectedStudentStatus,
                ),
                _space(),
                StageBlocConsumer(
                  listener: (context, state) {
                    if (state is CreateStudentErrorState) {
                      Methods.showSnackBar(context, state.error);
                    }
                    if (state is UpdateStudentErrorState) {
                      Methods.showSnackBar(context, state.error);
                    }
                    if (state is UpdateStudentSuccessState) {
                      Navigator.of(context).pop(state.student);
                    }
                    if (state is CreateStudentSuccessState) {
                      _clearContents();
                      return Methods.showSuccessSnackBar(
                          context, 'تم تسجيل الطالب بنجاح');
                    }
                  },
                  builder: (context, state) {
                    if (state is CreateStudentLoadingState ||
                        state is UpdateStudentLoadingState) {
                      return const DefaultLoader();
                    }
                    return CustomButton(
                      text: 'حفظ',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (selectedGender == null) {
                            return Methods.showSnackBar(
                                context, 'يجب اختيار النوع');
                          }
                          if (widget.student != null) {
                            await StageCubit.instance(context).updateStudent(
                                studentId: widget.student!.id,
                                code: codeController.text,
                                name: nameController.text,
                                school: schoolController.text,
                                fatherPhone: _completeFatherPhone,
                                motherPhone: _completeMotherPhone,
                                studentPhone: _completeStudentPhone,
                                whatsapp: _completeWhatsPhone,
                                address: addressController.text,
                                problems: problemsController.text,
                                studentStatus: selectedStudentStatus?.getIndex);
                            return;
                          }
                          await StageCubit.instance(context).createStudent(
                              code: codeController.text,
                              name: nameController.text,
                              school: schoolController.text,
                              fatherPhone: _completeFatherPhone,
                              motherPhone: _completeMotherPhone,
                              studentPhone: _completeStudentPhone,
                              whatsapp: _completeWhatsPhone,
                              address: addressController.text,
                              gender: selectedGender!.key,
                              problems: problemsController.text,
                              studentStatus: selectedStudentStatus?.getIndex);
                        }
                      },
                    );
                  },
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _clearContents() {
    codeController.clear();
    nameController.clear();
    schoolController.clear();
    fatherPhoneController.clear();
    motherPhoneController.clear();
    studentPhoneController.clear();
    whatsappController.clear();
    addressController.clear();
    problemsController.clear();

    _completeFatherPhone = '';
    _completeMotherPhone = '';
    _completeStudentPhone = '';
    _completeWhatsPhone = '';
  }

  Widget _space() {
    return const SizedBox(height: 16.0);
  }
}

class GenderRadioGroup extends StatelessWidget {
  final String label;
  final List<GenderModel> values;
  final Function(GenderModel?) onSelected;
  final GenderModel? selectedValue;

  const GenderRadioGroup({
    super.key,
    required this.label,
    required this.values,
    required this.onSelected,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget(
          label: label,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: values.map((gender) {
            return Expanded(
              child: RadioListTile(
                title: TextWidget(label: gender.value),
                value: gender,
                groupValue: selectedValue,
                onChanged: onSelected,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class StudentStatusRadioGroup extends StatelessWidget {
  final String label;
  final List<StudentStatus> values;
  final Function(StudentStatus?) onSelected;
  final StudentStatus? selectedValue;

  const StudentStatusRadioGroup({
    super.key,
    required this.label,
    required this.values,
    required this.onSelected,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget(
          label: label,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: values.map((status) {
            return Expanded(
              child: RadioListTile(
                title: TextWidget(label: status.getText),
                value: status,
                groupValue: selectedValue,
                onChanged: onSelected,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
