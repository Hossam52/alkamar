import 'dart:developer';

import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/stage/stage_type_model.dart';
import 'package:alqamar/models/stage/stages_response.dart';

import '../../models/auth/user_model.dart';
import '../../shared/network/services/app_services.dart';
import '../../shared/network/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'app_states.dart';

//Bloc builder and bloc consumer methods
typedef AppBlocBuilder = BlocBuilder<AppCubit, AppStates>;
typedef AppBlocConsumer = BlocConsumer<AppCubit, AppStates>;

//
class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(IntitalAppState());
  static AppCubit instance(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);
  User? _user;
  User? get user => _user;

  //All stages model
  StagesResponse? _stages;
  bool get notLoadedStages => _stages == null;
  List<StageTypeModel> get stageTypes => _stages?.stageTypes ?? [];
  List<StageModel> stagesByStageType(int index) =>
      index > stageTypes.length ? [] : stageTypes[index].stages;

  int _selectedBottomIndex = 1;
  int get getSelectedBottomIndex => _selectedBottomIndex;
  set selectedBottomIndex(int index) {
    _selectedBottomIndex = index;
    emit(ChangeAppBottomState(index));
  }

  void navigateToSearchGlobal() {
    selectedBottomIndex = 0;
    emit(ChangeAppBottomState(0));
  }

  bool get userError => user == null;
  void updateCurrentUser(User user) {
    _user = user;
    emit(UpdateUserState());
  }

  User get currentUser {
    if (userError) {
      // final user = await getUser();
      throw 'Undifined user';
    } else {
      return user!;
    }
  }

  Future<void> getStages() async {
    if (!notLoadedStages) return;
    try {
      emit(GetHomeDataLoadingState());
      final res = await AppServices.getStages();
      _stages = StagesResponse.fromJson(res);
      emit(GetHomeDataSuccessState());
    } catch (e) {
      emit(GetHomeDataErrorState(error: e.toString()));
    }
  }

  Future<void> getUser() async {
    if (!userError) return;
    try {
      emit(GetUserLoadingState());
      final response = await AuthServices.profile();
      log(response.toString());
      _user = User.fromMap(response);
      emit(GetUserSuccessState());
    } catch (e) {
      emit(GetUserErrorState(error: e.toString()));
    }
  }
}
