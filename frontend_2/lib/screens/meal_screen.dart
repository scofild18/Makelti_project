import 'package:flutter/material.dart';
import '../widgets/meal_screen/food_image_header.dart';
import '../widgets/meal_screen/ingredient_chip.dart';
import '../widgets/meal_screen/quantity_selector.dart';
import '../widgets/meal_screen/seller_info_card.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({super.key});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int quantity = 1;
  bool isFavorite = false;

  // Dummy data for the food item
  final Map<String, dynamic> foodData = {
    'title': 'Fresh Garden Salad Bowl',
    'price': '250 DA',
    'rating': 4.9,
    'reviewCount': 124,
    'prepTime': '30-45 min',
    'description':
        'A delicious homemade fresh garden salad bowl made with fresh, locally sourced ingredients. Prepared with love and care to bring you an authentic taste of home cooking.',
    'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    'ingredients': ['Fresh', 'Organic', 'Gluten-Free', 'Dairy'],
    'seller': {
      'name': 'Green Eats',
      'distance': '1.2 km',
    },
  };

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Header with Back and Favorite buttons
                  FoodImageHeader(
                    imageUrl: foodData['imageUrl'],
                    price: foodData['price'],
                    isFavorite: isFavorite,
                    onBackPressed: () => Navigator.pop(context),
                    onFavoritePressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),

                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          foodData['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating and Time
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              foodData['rating'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${foodData['reviewCount']} reviews)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.access_time, color: Colors.grey[600], size: 18),
                            const SizedBox(width: 4),
                            Text(
                              foodData['prepTime'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          foodData['description'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Ingredients
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (foodData['ingredients'] as List<String>)
                              .map((ingredient) => IngredientChip(label: ingredient))
                              .toList(),
                        ),
                        const SizedBox(height: 24),

                        // About the Seller
                        const Text(
                          'About the Seller',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SellerInfoCard(
                          name: foodData['seller']['name'],
                          distance: foodData['seller']['distance'],
                          onViewTap: () {
                            // TODO: Navigate to seller profile
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quantity Selector
                        QuantitySelector(
                          quantity: quantity,
                          onIncrement: incrementQuantity,
                          onDecrement: decrementQuantity,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}