import 'package:flutter/material.dart';
import '../widgets/add_meal_screen/image_upload_box.dart';
import '../widgets/add_meal_screen/custom_text_field.dart';
import '../widgets/add_meal_screen/category_chip.dart';
import '../widgets/add_meal_screen/submit_button.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State
  String? _uploadedImageUrl;
  final List<String> _selectedCategories = [];
  bool _isSubmitting = false;

  // Dummy data for categories
  final List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
    'Vegan',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _handleImageUpload() {
    // TODO: Implement image picker
    setState(() {
      _uploadedImageUrl = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800';
    });
  }

  void _handleSubmit() {
    // TODO: Implement form validation and submission
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _nameController.clear();
      _descriptionController.clear();
      _ingredientsController.clear();
      _priceController.clear();
      _locationController.clear();
      setState(() {
        _uploadedImageUrl = null;
        _selectedCategories.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBackPressed ?? () {
                      // Fallback if no callback provided
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Add New Meal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Photo
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
                      imageUrl: _uploadedImageUrl,
                      onTap: _handleImageUpload,
                    ),
                    const SizedBox(height: 24),

                    // Meal Name
                    CustomTextField(
                      label: 'Meal Name',
                      hint: 'e.g., Homemade Pasta Carbonara',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),

                    // Description
                    CustomTextField(
                      label: 'Description',
                      hint: 'Tell customers about your delicious meal...',
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // Ingredients
                    CustomTextField(
                      label: 'Ingredients',
                      hint: 'List the main ingredients (e.g., Fresh pasta, eggs, bacon, parmesan)',
                      controller: _ingredientsController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Price
                    CustomTextField(
                      label: 'Price',
                      hint: 'DZD 0.00',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                    ),
                    const SizedBox(height: 20),

                    // Pickup Location
                    CustomTextField(
                      label: 'Pickup Location',
                      hint: 'Downtown, City Center',
                      controller: _locationController,
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 24),

                    // Category
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
                          isSelected: _selectedCategories.contains(category),
                          onTap: () => _toggleCategory(category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SubmitButton(
                      text: 'Post Meal',
                      onPressed: _handleSubmit,
                      isLoading: _isSubmitting,
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
  }
}