import 'package:alqamar/cubits/permissions_cubit/permission_cubit.dart';
import 'package:alqamar/cubits/permissions_cubit/permission_states.dart';
import 'package:alqamar/models/auth/user_model.dart';
import 'package:alqamar/models/auth/user_role_enum.dart';
import 'package:alqamar/models/permissions/available_permissions_model.dart';
import 'package:alqamar/screens/auth/edit/change_password_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPermissionsScreen extends StatefulWidget {
  const UsersPermissionsScreen({super.key});

  @override
  State<UsersPermissionsScreen> createState() => _UsersPermissionsScreenState();
}

class _UsersPermissionsScreenState extends State<UsersPermissionsScreen> {
  User? selectedUser;
  List<PermissionModel> _userPermissions = [];
  bool _markAsAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TextWidget(label: 'صلاحيات المستخدمين'),
        ),
        body: BlocProvider(
          create: (_) => PermissionCubit()..getAllUsers(),
          child: PermissionBlocConsumer(
              listener: (BuildContext context, PermissionStates state) {
            if (state is GetAllUsersErrorState) {
              Methods.showSnackBar(context, state.error);
            }
          }, builder: (context, state) {
            final cubit = PermissionCubit.instance(context);
            if (state is GetAllUsersLoadingState) return const DefaultLoader();
            if (state is GetAllUsersErrorState || cubit.errorUsers) {
              return CustomErrorWidget(onPressed: () {
                cubit.getAllUsers();
              });
            }
            final users = cubit.allUsers;
            final availablePermissions = cubit.availablePermissions;
            return Column(
              children: [
                _usersDropDown(users),
                if (selectedUser != null) ...[
                  // ListTile(
                  //   onTap: () {
                  //     setState(() {
                  //       _markAsAdmin = !_markAsAdmin;
                  //     });
                  //   },
                  //   leading: Checkbox(
                  //     value: _markAsAdmin,
                  //     onChanged: (val) {
                  //       setState(() {
                  //         _markAsAdmin = !_markAsAdmin;
                  //       });
                  //     },
                  //   ),
                  //   title: TextWidget(label: 'تعيين ك مدير نظام (Admin)'),
                  // ),
                  Expanded(
                    child: Table(
                      columnWidths: const {0: FlexColumnWidth(2)},
                      children: [
                        const TableRow(children: [
                          Center(child: TextWidget(label: 'الميزة')),
                          Center(child: TextWidget(label: 'عرض')),
                          Center(child: TextWidget(label: 'اضافة')),
                          Center(child: TextWidget(label: 'تعديل')),
                          Center(child: TextWidget(label: 'حذف')),
                        ]),
                        ...availablePermissions.map(
                          (e) {
                            final currentPermissions = _userPermissions
                                .where((element) => element.id == e.id)
                                .firstOrNull;
                            return TableRow(children: [
                              Center(child: TextWidget(label: e.module)),
                              _permissionCheckbox(e.view,
                                  currentVal: currentPermissions?.view,
                                  onChanged: (val) {
                                final index = _changeSelectedValue(e);
                                _userPermissions[index].view =
                                    !(_userPermissions[index].view);
                              }),
                              _permissionCheckbox(e.create,
                                  currentVal: currentPermissions?.create,
                                  onChanged: (val) {
                                final index = _changeSelectedValue(e);
                                _userPermissions[index].create =
                                    !(_userPermissions[index].create);
                              }),
                              _permissionCheckbox(e.update,
                                  currentVal: currentPermissions?.update,
                                  onChanged: (val) {
                                final index = _changeSelectedValue(e);
                                _userPermissions[index].update =
                                    !(_userPermissions[index].update);
                              }),
                              _permissionCheckbox(e.delete,
                                  currentVal: currentPermissions?.delete,
                                  onChanged: (val) {
                                final index = _changeSelectedValue(e);
                                _userPermissions[index].delete =
                                    !(_userPermissions[index].delete);
                              }),
                            ]);
                          },
                        ).toList()
                      ],
                    ),
                    // _Permissions(availablePermissions: availablePermissions),
                  ),
                  // Spacer(),
                  if (state is AddUserPermissionsLoadingState)
                    const DefaultLoader()
                  else
                    CustomButton(
                        text: 'حفظ',
                        onPressed: () {
                          cubit.addUserPermissions(context, selectedUser!,
                              _markAsAdmin, _userPermissions);
                        })
                ],
              ],
            );
          }),
        ));
  }

  int _changeSelectedValue(PermissionModel e) {
    if (_userPermissions.where((element) => element.id == e.id).isEmpty) {
      _userPermissions.add(PermissionModel(id: e.id, module: e.module));
    }
    final index = _userPermissions.indexWhere((element) => element.id == e.id);
    return index;
  }

  CustomAuthField _usersDropDown(List<User> users) {
    return CustomAuthField.customTextField(
      controller: TextEditingController(),
      label: 'المستخدم',
      textField: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: const TextWidget(
            label: 'اختر المستخدم',
            color: Colors.grey,
          ),
          alignment: AlignmentDirectional.center,
          dropdownColor: ColorManager.primary,
          iconEnabledColor: ColorManager.accentColor,
          focusColor: ColorManager.accentColor,
          borderRadius: BorderRadius.circular(10),
          value: selectedUser,
          onChanged: (value) {
            setState(() {
              selectedUser = value;
              if (value != null) {
                _userPermissions = value.allUserPermissions;
                _markAsAdmin = selectedUser!.roleEnum.isAdmin;
              }
            });
          },
          items: users
              .map((user) => DropdownMenuItem<User>(
                    alignment: AlignmentDirectional.center,
                    value: user,
                    child: TextWidget(label: user.name),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _permissionCheckbox(bool displayBlock,
      {bool? currentVal, void Function(bool?)? onChanged}) {
    return Visibility(
      visible: displayBlock,
      child: Checkbox(
          visualDensity: VisualDensity.comfortable,
          value: currentVal ?? false,
          onChanged: (val) {
            onChanged!(val);
            setState(() {});
          }),
    );
  }
}
