import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_screen/food_card.dart';
import '../widgets/home_screen/search_bar.dart';
import 'meal_screen.dart';

class SeeAllPostsScreen extends StatelessWidget {

final List<Map<String, dynamic>> allPosts = [
    {
      'title': 'Mhajeb ',
      'store': "Fatma's Kitchen",
      'price': '250 da',
      'rating': 4.8,
      'distance': '0.5 km',
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Taam (Couscous with Raisins and Butter)',
      'store': "Dar El Taam",
      'price': '340 da',
      'rating': 4.9,
      'distance': '1.2 km',
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Baghrir - Algerian Pancakes',
      'store': "Sweet Delights DZ",
      'price': '250 da',
      'rating': 5.0,
      'distance': '0.8 km',
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Chakhchoukha Biskra',
      'store': "Chef's Table DZ",
      'price': '145 da',
      'rating': 4.7,
      'distance': '2.1 km',
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Rechta - Homemade Noodles',
      'store': "Dar El Rechta",
      'price': '999 da',
      'rating': 4.6,
      'distance': '1.5 km',
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Kesra with Lben',
      'store': "Traditional Stop",
      'price': '650 da',
      'rating': 4.5,
      'distance': '0.3 km',
      'image': 'assets/images/pasta.png'
    },
  ];

  final List<Map<String, dynamic>> nearbyStores = [
    {
      "name": "Maria's Kitchen",
      "distance": "0.5 km",
      "rating": 4.8,
      "image": 'assets/images/store.jpg'
    },
    {
      "name": "Green Eats",
      "distance": "1.2 km",
      "rating": 4.9,
      "image": 'assets/images/pizza_store.jpg'
    },
    {
      "name": "Sweet Delights",
      "distance": "0.8 km",
      "rating": 5.0,
      "image": 'assets/images/store.jpg'
    },
  ];
   SeeAllPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left  : 22.0, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                            onTap: () {
                  context.pop(); 
                            },
                            child: const Icon(Icons.arrow_back , color: Colors.black,)),
                ],
              ),
            ),
              const Padding(
              padding: EdgeInsets.only(left: 12,right:12 , top: 6 ,bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(title: "Search for food"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final item = allPosts[index];
                    return FoodCard(
                      image: item['image'],
                      price: item['price'],
                      title: item['title'],
                      store: item['store'],
                      rating: item['rating'].toDouble(),
                      distance: item['distance'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FoodDetailPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}