import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit3 extends Cubit<int> {
  CounterCubit3() : super(0);

  void increment() => emit(state + 1);
}
