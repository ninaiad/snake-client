import 'package:bloc/bloc.dart';

class ScoreCubit extends Cubit<int> {
  ScoreCubit() : super(0);
  void increment() {
    emit(state + 1);
  }

  void restart() {
    emit(0);
  }
}
