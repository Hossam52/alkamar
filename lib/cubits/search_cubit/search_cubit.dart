import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './search_states.dart';

//Bloc builder and bloc consumer methods
typedef SearchBlocBuilder = BlocBuilder<SearchCubit, SearchStates>;
typedef SearchBlocConsumer = BlocConsumer<SearchCubit, SearchStates>;

//
class SearchCubit extends Cubit<SearchStates> {
  SearchCubit({this.stage}) : super(IntitalSearchState());
  static SearchCubit instance(BuildContext context) =>
      BlocProvider.of<SearchCubit>(context);
  StageModel? stage;

  StudentListResponseModel? _searchRes;
  bool get hasError => _searchRes == null;
  List<StudentModel> get studentResults => _searchRes?.students ?? [];

  Future<void> serachStudentByName(String name) async {
    try {
      emit(SerachStudentLoadingState());
      final res =
          await AppServices.searchStudent(stage_id: stage?.id, name: name);
      _searchRes = StudentListResponseModel.fromMap(res);
      emit(SerachStudentSuccessState());
    } catch (e) {
      emit(SerachStudentErrorState(error: e.toString()));
    }
  }

  Future<void> serachStudentByCode(String code) async {
    try {
      emit(SerachStudentLoadingState());
      final res =
          await AppServices.searchStudent(stage_id: stage?.id, code: code);
      _searchRes = StudentListResponseModel.fromMap(res);
      emit(SerachStudentSuccessState());
    } catch (e) {
      emit(SerachStudentErrorState(error: e.toString()));
    }
  }
}
