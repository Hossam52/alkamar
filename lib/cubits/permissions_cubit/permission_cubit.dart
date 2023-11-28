import 'package:alqamar/models/auth/user_model.dart';
import 'package:alqamar/models/auth/user_role_enum.dart';
import 'package:alqamar/models/permissions/available_permissions_model.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/network/services/permission_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './permission_states.dart';

//Bloc builder and bloc consumer methods
typedef PermissionBlocBuilder = BlocBuilder<PermissionCubit, PermissionStates>;
typedef PermissionBlocConsumer
    = BlocConsumer<PermissionCubit, PermissionStates>;

//
class PermissionCubit extends Cubit<PermissionStates> {
  PermissionCubit() : super(IntitalPermissionState());
  static PermissionCubit instance(BuildContext context) =>
      BlocProvider.of<PermissionCubit>(context);

  AllUsersModel? _allUsersResponse;
  bool get errorUsers => _allUsersResponse == null;
  List<User> get allUsers => _allUsersResponse?.users ?? [];
  List<PermissionModel> get availablePermissions =>
      _allUsersResponse?.available_permissions ?? [];

  Future<void> getAllUsers() async {
    try {
      emit(GetAllUsersLoadingState());
      final response = await PermissionServices.instance.allUsers();
      _allUsersResponse = AllUsersModel.fromMap(response);
      emit(GetAllUsersSuccessState());
    } catch (e) {
      emit(GetAllUsersErrorState(error: e.toString()));
    }
  }

  Future<void> addUserPermissions(BuildContext context, User user,
      bool markAsAdmin, List<PermissionModel> permissions) async {
    try {
      emit(AddUserPermissionsLoadingState());
      await PermissionServices.instance.addUserPermission(
          user.id,
          markAsAdmin ? UserRoleEnum.admin : UserRoleEnum.assistant,
          permissions);
      // ignore: use_build_context_synchronously
      Methods.showSuccessSnackBar(context, 'تم تعديل الصلاحيات بنجاح');
      emit(AddUserPermissionsSuccessState());
    } catch (e) {
      emit(AddUserPermissionsErrorState(error: e.toString()));
    }
  }
}
