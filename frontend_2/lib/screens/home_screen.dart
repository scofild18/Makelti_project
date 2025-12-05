import 'package:Makelti/widgets/home_screen/home_screen_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home_screen/food_card.dart';
import '../widgets/home_screen/nearby_stores_card.dart';
import '../widgets/home_screen/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Map<String, dynamic>> recentPosts = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 8),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(12)
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    HomeScreenAppBar(),
                    SizedBox(height: 12),
                          SearchBarWidget(title: "Search food or store",),
                  ],
                ),
              ),
            )
          ),

          
         

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Posts",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed("see_all_posts");
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.orange, padding: EdgeInsets.zero),
                  child: const Row(
                    children: [
                      Text("See all"),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recentPosts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.76,
              ),
              itemBuilder: (context, index) {
                final item = recentPosts[index];

                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: 1,
                  child: FoodCard(
                    image: item['image'],
                    price: item['price'],
                    title: item['title'],
                    store: item['store'],
                    rating: item['rating'].toDouble(),
                    distance: item['distance'],
                    onTap: () {
                      context.pushNamed("client_meal_screen");
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nearby Stores",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed("see_all_stores");
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.orange, padding: EdgeInsets.zero),
                  child: const Row(
                    children: [
                      Text("See all"),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyStores.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final store = nearbyStores[index];
                  return NearbyStoresCard(
                    name: store['name'],
                    distance: store['distance'],
                    rating: store['rating'].toDouble(),
                    image: store['image'],
                    onTap: () {
                      context.goNamed('client_cook_profile');
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}