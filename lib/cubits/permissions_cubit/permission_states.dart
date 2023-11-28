//
abstract class PermissionStates {}

class IntitalPermissionState extends PermissionStates {}
//

//GetAllUsers online fetch data
class GetAllUsersLoadingState extends PermissionStates {}

class GetAllUsersSuccessState extends PermissionStates {}

class GetAllUsersErrorState extends PermissionStates {
  final String error;
  GetAllUsersErrorState({required this.error});
}

//AddUserPermissions online fetch data
class AddUserPermissionsLoadingState extends PermissionStates {}

class AddUserPermissionsSuccessState extends PermissionStates {}

class AddUserPermissionsErrorState extends PermissionStates {
  final String error;
  AddUserPermissionsErrorState({required this.error});
}
