import 'package:flutter/material.dart';

import '../widgets/meal_screen/food_image_header.dart';
import '../widgets/meal_screen/ingredient_chip.dart';
import '../widgets/meal_screen/seller_info_card.dart';

class CookMealScreen extends StatefulWidget {
  const CookMealScreen({super.key});

  @override
  State<CookMealScreen> createState() => _CookMealScreenState();
}

class _CookMealScreenState extends State<CookMealScreen> {
  bool isEditing = false;

  Map<String, dynamic> foodData = {
    'title': 'Fresh Garden Salad Bowl',
    'price': 250.0,
    'rating': 4.9,
    'reviewCount': 124,
    'prepTime': '30-45 min',
    'description':
        'A delicious homemade fresh garden salad bowl made with fresh, locally sourced ingredients.',
    'imageUrl':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    'ingredients': ['Fresh', 'Organic', 'Gluten-Free', 'Dairy'],
    'seller': {'name': 'Green Eats', 'distance': '1.2 km'},
  };

  // Controllers for editing
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController prepTimeController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: foodData['title']);
    priceController = TextEditingController(text: foodData['price'].toString());
    descriptionController =
        TextEditingController(text: foodData['description']);
    prepTimeController = TextEditingController(text: foodData['prepTime']);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FoodImageHeader(
                    imageUrl: foodData['imageUrl'],
                    price: "${foodData['price']} DA",
                    isFavorite: false,
                    onBackPressed: () => Navigator.pop(context),
                    onFavoritePressed: () {},
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isEditing
                            ? TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: "Title",
                                  border: OutlineInputBorder(),
                                ),
                              )
                            : Text(
                                foodData['title'],
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              foodData['rating'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${foodData['reviewCount']} reviews)',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time,
                                color: Colors.grey, size: 18),
                            const SizedBox(width: 4),
                            isEditing
                                ? SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      controller: prepTimeController,
                                      decoration: const InputDecoration(
                                        labelText: "Prep Time",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                : Text(
                                    foodData['prepTime'],
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                  ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextFormField(
                                controller: descriptionController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )
                            : Text(
                                foodData['description'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),

                        const SizedBox(height: 24),

                        const Text(
                          'Ingredients',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (foodData['ingredients'] as List<String>)
                              .map((ingredient) =>
                                  IngredientChip(label: ingredient))
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'About the Seller',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SellerInfoCard(
                          name: foodData['seller']['name'],
                          distance: foodData['seller']['distance'],
                          onViewTap: () {},
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isEditing) {
                              setState(() {
                                foodData['title'] = titleController.text;
                                foodData['price'] =
                                    double.tryParse(priceController.text) ??
                                        foodData['price'];
                                foodData['description'] =
                                    descriptionController.text;
                                foodData['prepTime'] =
                                    prepTimeController.text;
                                isEditing = false;
                              });
                            } else {
                              setState(() {
                                isEditing = true;
                              });
                            }
                          },
                          icon: Icon(isEditing ? Icons.save : Icons.edit),
                          label: Text(isEditing ? "Save" : "Edit Meal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe97844),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}