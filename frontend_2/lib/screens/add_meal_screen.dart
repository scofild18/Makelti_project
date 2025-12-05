import 'package:Makelti/logic/cubit/addMeal/add_meal_cubit.dart';
import 'package:Makelti/logic/cubit/addMeal/add_meal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/add_meal_screen/image_upload_box.dart';
import '../widgets/add_meal_screen/custom_text_field.dart';
import '../widgets/add_meal_screen/category_chip.dart';
import '../widgets/add_meal_screen/submit_button.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
    'Vegan',
  ];

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AddMealCubit>();

    _nameController.addListener(() {
      cubit.setName(_nameController.text);
    });
    _descriptionController.addListener(() {
      cubit.setDescription(_descriptionController.text);
    });
    _ingredientsController.addListener(() {
      cubit.setIngredients(_ingredientsController.text);
    });
    _priceController.addListener(() {
      cubit.setPrice(_priceController.text);
    });
    _locationController.addListener(() {
      cubit.setLocation(_locationController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMealCubit, AddMealState>(
      builder: (context, state) {
        final cubit = context.read<AddMealCubit>();

        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                context.pop() ; 
              },
              child: const Icon(Icons.arrow_back, color: Colors.black,)),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Add New Meal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meal Photo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ImageUploadBox(
                          imageUrl: state.uploadedImageUrl,
                          onTap: () => cubit.setImage(
                              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800'),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: 'Meal Name',
                          hint: 'e.g., Homemade Pasta Carbonara',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Description',
                          hint: 'Tell customers about your delicious meal...',
                          controller: _descriptionController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Ingredients',
                          hint:
                              'List main ingredients (e.g., Fresh pasta, eggs, bacon)',
                          controller: _ingredientsController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Price',
                          hint: 'DZD 0.00',
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.attach_money,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Pickup Location',
                          hint: 'Downtown, City Center',
                          controller: _locationController,
                          prefixIcon: Icons.location_on,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Category (Optional)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((category) {
                            return CategoryChip(
                              label: category,
                              isSelected:
                                  state.selectedCategories.contains(category),
                              onTap: () => cubit.toggleCategory(category),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        SubmitButton(
                          text: 'Post Meal',
                          isLoading: state.isSubmitting,
                          onPressed: state.isSubmitting 
                              ? null
                              : ()  async {
                                  await cubit.submitMeal();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Meal posted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  _nameController.clear();
                                  _descriptionController.clear();
                                  _ingredientsController.clear();
                                  _priceController.clear();
                                  _locationController.clear();
                                },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}