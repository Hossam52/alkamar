import 'dart:developer';

import 'package:alqamar/models/auth/permission_model.dart';
import 'package:alqamar/models/auth/user_role_enum.dart';
import 'package:alqamar/models/permissions/available_permissions_model.dart';
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
  AllPermissionsModel? get permissions => _user?.permissions;

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
      final userModel = AuthUserModel.fromMap(response);
      _user = userModel.user;
      emit(GetUserSuccessState());
    } catch (e) {
      emit(GetUserErrorState(error: e.toString()));
    }
  }
}

extension LoggedInUser on BuildContext {
  User? get currentUser => AppCubit.instance(this).user;
  AllPermissionsModel? get loggedInPermissions => currentUser?.permissions;
  List<PermissionModel> get currentUserPermissionsList =>
      currentUser?.allUserPermissions ?? [];
  bool canPerformAction(PermissionModel? permission,
      {bool view = false,
      bool create = false,
      bool update = false,
      bool delete = false}) {
    if (currentUser != null && currentUser!.roleEnum.isAdmin) return true;
    if (permission == null) return false;
    if (view) return permission.view;
    if (create) return permission.create;
    if (update) return permission.update;
    if (delete) return permission.delete;
    return false;
  }
}
