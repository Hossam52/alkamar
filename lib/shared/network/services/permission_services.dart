import 'package:alqamar/models/auth/user_role_enum.dart';
import 'package:alqamar/models/permissions/available_permissions_model.dart';
import 'package:alqamar/shared/network/endpoints.dart';
import 'package:alqamar/shared/network/local/cache_helper.dart';
import 'package:alqamar/shared/network/remote/app_dio_helper.dart';

class PermissionServices {
  PermissionServices._();
  static PermissionServices? _instance;
  static PermissionServices get instance {
    _instance ??= PermissionServices._();
    return _instance!;
  }

  Future<Map<String, dynamic>> allUsers() async {
    try {
      final response = await AppDioHelper.getData(
          url: EndPoints.allUsers, token: await CacheHelper.getToken);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addUserPermission(int userId,
      UserRoleEnum userRole, List<PermissionModel> permissions) async {
    try {
      final response = await AppDioHelper.postData(
          url: EndPoints.addPermission,
          data: {
            'user_id': userId,
            'role': userRole.name,
            'permissions': permissions.map((e) => e.toMap()).toList(),
          },
          token: await CacheHelper.getToken);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> availablePermissions() async {
    try {
      final response =
          await AppDioHelper.getData(url: EndPoints.availablePermissions);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
