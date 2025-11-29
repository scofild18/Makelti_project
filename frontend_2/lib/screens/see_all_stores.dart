import 'package:Makelti/widgets/home_screen/nearby_stores_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_screen/food_card.dart';
import '../widgets/home_screen/search_bar.dart';
import 'meal_screen.dart';

class SeeAllStores extends StatelessWidget {
  final List<Map<String, dynamic>> allStores = [
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
   SeeAllStores({super.key});

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
                  itemCount: allStores.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final item = allStores[index];
                    return NearbyStoresCard(
                      name: item['name'],
                    distance: item['distance'],
                    rating: item['rating'].toDouble(),
                    image: item['image'],
                    onTap: () {
                      context.goNamed('cook_profile');
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