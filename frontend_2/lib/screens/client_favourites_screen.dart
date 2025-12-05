import 'package:Makelti/widgets/home_screen/fav_food_card.dart';
import 'package:Makelti/widgets/home_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientFavouritesScreen extends StatelessWidget {
final List<Map<String, dynamic>> favouritePosts = const [
    {
      "title": 'Mhajeb',
      "store": "Fatma's Kitchen",
      "price": '250 da',
      "rating": 4.8,
      "distance": '0.5 km',
      "image": 'assets/images/salad.jpg',
    },
    {
      "title": 'Taam (Couscous with Raisins and Butter)',
      "store": "Dar El Taam",
      "price": '340 da',
      "rating": 4.9,
      "distance": '1.2 km',
      "image": 'assets/images/pasta.png',
    },
    {
      "title": 'Baghrir - Algerian Pancakes',
      "store": "Sweet Delights DZ",
      "price": '250 da',
      "rating": 5.0,
      "distance": '0.8 km',
      "image": 'assets/images/pasta.png',
    },
    {
      "title": 'Chakhchoukha Biskra',
      "store": "Chef's Table DZ",
      "price": '145 da',
      "rating": 4.7,
      "distance": '2.1 km',
      "image": 'assets/images/salad.jpg',
    },
    {
      "title": 'Rechta - Homemade Noodles',
      "store": "Dar El Rechta",
      "price": '999 da',
      "rating": 4.6,
      "distance": '1.5 km',
      "image": 'assets/images/pasta.png',
    },
    {
      "title": 'Kesra with Lben',
      "store": "Traditional Stop",
      "price": '650 da',
      "rating": 4.5,
      "distance": '0.3 km',
      "image": 'assets/images/pasta.png',
    },
  ];


  const ClientFavouritesScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 12),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Text(
                    'Favourites',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(
                          title: "Search for food",
                        ),
                      ),
                    ],
                  ),
                ),

            const SizedBox(height: 8),

            Expanded(
              child: favouritePosts.isEmpty
                  ? const Center(
                      child: Text(
                        'No favourites yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: favouritePosts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (context, index) {
                          final post = favouritePosts[index];
                          return FavFoodCard(
                            image: post['image'],
                            price: post['price'],
                            title: post['title'],
                            store: post['store'],
                            rating: post['rating'],
                            distance: post['distance'],
                            onTap: () {
                              context.push('/client_meal_screen');
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