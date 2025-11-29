class MealState {
  final int quantity;
  final bool isFavorite;

  MealState({
    required this.quantity,
    required this.isFavorite,
  });

  MealState copyWith({
    int? quantity,
    bool? isFavorite,
  }) {
    return MealState(
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}