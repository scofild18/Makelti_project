import 'package:Makelti/logic/cubit/addMeal/add_meal_state.dart' show AddMealState;
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMealCubit extends Cubit<AddMealState> {
  AddMealCubit() : super(AddMealState());

  void setName(String value) => emit(state.copyWith(name: value));
  void setDescription(String value) => emit(state.copyWith(description: value));
  void setIngredients(String value) => emit(state.copyWith(ingredients: value));
  void setPrice(String value) => emit(state.copyWith(price: value));
  void setLocation(String value) => emit(state.copyWith(location: value));

  void toggleCategory(String category) {
    final updated = List<String>.from(state.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    emit(state.copyWith(selectedCategories: updated));
  }

  void setImage(String url) => emit(state.copyWith(uploadedImageUrl: url));

  Future<void> submitMeal() async {
    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(seconds: 2));

    emit(AddMealState()); 
  }
}