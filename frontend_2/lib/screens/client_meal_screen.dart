import 'package:Makelti/logic/cubit/meals/meal_cubit.dart';
import 'package:Makelti/logic/cubit/meals/meal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/meal_screen/food_image_header.dart';
import '../widgets/meal_screen/ingredient_chip.dart';
import '../widgets/meal_screen/seller_info_card.dart';

class ClientMealScreen extends StatelessWidget {
  const ClientMealScreen({super.key});

  final Map<String, dynamic> foodData = const {
    'title': 'Fresh Garden Salad Bowl',
    'price': 250.0,
    'rating': 4.9,
    'reviewCount': 124,
    'prepTime': '30-45 min',
    'description':
        'A delicious homemade fresh garden salad bowl made with fresh, locally sourced ingredients. Prepared with love and care to bring you an authentic taste of home cooking.',
    'imageUrl':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    'ingredients': ['Fresh', 'Organic', 'Gluten-Free', 'Dairy'],
    'seller': {'name': 'Green Eats', 'distance': '1.2 km'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MealCubit, MealState>(
        builder: (context, state) {
          double totalPrice = foodData['price'] * state.quantity;

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodImageHeader(
                      imageUrl: foodData['imageUrl'],
                      price: "${foodData['price']} DA",
                      isFavorite: state.isFavorite,
                      onBackPressed: () => Navigator.pop(context),
                      onFavoritePressed: () =>
                          context.read<MealCubit>().toggleFavorite(),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodData['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
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
                              Icon(Icons.access_time,
                                  color: Colors.grey[600], size: 18),
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
                                .map((ingredient) =>
                                    IngredientChip(label: ingredient))
                                .toList(),
                          ),

                          const SizedBox(height: 24),

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
                            onViewTap: () {},
                          ),

                          const SizedBox(height: 140),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              /// ✅ Bottom Floating Buttons
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: const Color(0xffe97844)),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove,
                                    color: Color(0xffe97844)),
                                onPressed: () =>
                                    context.read<MealCubit>().decrement(),
                                visualDensity: VisualDensity.compact,
                              ),
                              Text(
                                state.quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add,
                                    color: Color(0xffe97844)),
                                onPressed: () =>
                                    context.read<MealCubit>().increment(),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffe97844),
                              borderRadius: BorderRadius.circular(52),
                            ),
                            child: Center(
                              child: Text(
                                "Make Order  •  ${totalPrice.toStringAsFixed(0)} DA",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
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
          );
        },
      ),
    );
  }
}