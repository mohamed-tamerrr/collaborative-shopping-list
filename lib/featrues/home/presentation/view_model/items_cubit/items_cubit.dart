import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());
}
