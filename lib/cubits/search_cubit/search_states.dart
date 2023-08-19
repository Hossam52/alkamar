//
abstract class SearchStates {}

class IntitalSearchState extends SearchStates {}
//

//SerachStudent online fetch data
class SerachStudentLoadingState extends SearchStates {}

class SerachStudentSuccessState extends SearchStates {}

class SerachStudentErrorState extends SearchStates {
  final String error;
  SerachStudentErrorState({required this.error});
}
