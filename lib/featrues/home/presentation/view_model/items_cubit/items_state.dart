part of 'items_cubit.dart';

@immutable
sealed class ItemsState {}

final class ItemsInitial extends ItemsState {}

final class ItemsLoading extends ItemsState {}

final class ItemsEmpty extends ItemsState {}

final class ItemsSuccess extends ItemsState {
  final List<ItemModel> itemModel;
  ItemsSuccess({required this.itemModel});
}

final class ItemsFailure extends ItemsState {
  final String errMessage;
  ItemsFailure({required this.errMessage});
}
