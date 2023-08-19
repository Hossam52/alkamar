//

abstract class AppStates {}

class IntitalAppState extends AppStates {}

//
class ChangeAppBottomState extends AppStates {
  final int bottomIndex;

  ChangeAppBottomState(this.bottomIndex);
}

class UpdateUserState extends AppStates {}

//GetUser online fetch data
class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;
  GetUserErrorState({required this.error});
}

//GetHomeData online fetch data
class GetHomeDataLoadingState extends AppStates {}

class GetHomeDataSuccessState extends AppStates {}

class GetHomeDataErrorState extends AppStates {
  final String error;
  GetHomeDataErrorState({required this.error});
}
