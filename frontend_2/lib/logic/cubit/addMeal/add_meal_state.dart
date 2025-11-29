class AddMealState {
  final String? uploadedImageUrl;
  final List<String> selectedCategories;
  final bool isSubmitting;

  final String name;
  final String description;
  final String ingredients;
  final String price;
  final String location;

  AddMealState({
    this.uploadedImageUrl,
    List<String>? selectedCategories,
    this.isSubmitting = false,
    this.name = '',
    this.description = '',
    this.ingredients = '',
    this.price = '',
    this.location = '',
  }) : selectedCategories = selectedCategories ?? [];

  AddMealState copyWith({
    String? uploadedImageUrl,
    List<String>? selectedCategories,
    bool? isSubmitting,
    String? name,
    String? description,
    String? ingredients,
    String? price,
    String? location,
  }) {
    return AddMealState(
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      price: price ?? this.price,
      location: location ?? this.location,
    );
  }
}