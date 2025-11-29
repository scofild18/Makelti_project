import 'package:Makelti/logic/cubit/meals/meal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealCubit extends Cubit<MealState> {
  MealCubit() : super(MealState(quantity: 1, isFavorite: false));

  void increment() => emit(state.copyWith(quantity: state.quantity + 1));

  void decrement() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void toggleFavorite() =>
      emit(state.copyWith(isFavorite: !state.isFavorite));
}