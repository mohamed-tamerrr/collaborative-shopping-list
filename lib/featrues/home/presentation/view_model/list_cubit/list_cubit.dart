import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());
}
