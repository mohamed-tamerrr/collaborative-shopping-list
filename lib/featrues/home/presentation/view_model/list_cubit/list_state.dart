part of 'list_cubit.dart';

@immutable
sealed class ListState {}

final class ListInitial extends ListState {}

final class ListLoading extends ListState {}

final class ListFailure extends ListState {}

final class ListSuccess extends ListState {
  final List<ListModel> lists;
  final int listsLength;
  ListSuccess(this.lists, this.listsLength);
}
