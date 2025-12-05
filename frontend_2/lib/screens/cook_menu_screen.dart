import 'package:Makelti/widgets/home_screen/cook_food_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CookMenuScreen extends StatefulWidget {
  const CookMenuScreen({super.key});

  @override
  State<CookMenuScreen> createState() => _CookMenuScreenState();
}

class _CookMenuScreenState extends State<CookMenuScreen> {
  final List<Map<String, dynamic>> recentPosts = [
    {
      'title': 'Mhajeb ',
      'store': 'Maria Kitchen',
      'price': '250 da',
      'rating': 4.8,
      "order": 3 , 
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Taam (Couscous with Raisins and Butter)',
      'store': 'Maria Kitchen',
      'price': '340 da',
      'rating': 4.9,
      "order": 3 , 
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Baghrir - Algerian Pancakes',
      'store': 'Maria Kitchen',
      'price': '250 da',
      'rating': 5.0,
      "order": 3 , 
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Chakhchoukha Biskra',
      'store': 'Maria Kitchen',
      'price': '145 da',
      'rating': 4.7,
      "order": 3 , 
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Rechta - Homemade Noodles',
      'store': 'Maria Kitchen',
      'price': '999 da',
      'rating': 4.6,
      "order": 3 , 
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Kesra with Lben',
      'store': 'Maria Kitchen',
      'price': '650 da',
      'rating': 4.5,
      "order": 3 , 
      'image': 'assets/images/pasta.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Menu' ,style: TextStyle(color: Colors.black), ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add , color: Colors.black,),
            onPressed: () {
              context.push('/add_meal');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: recentPosts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = recentPosts[index];
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: 1,
              child: CookFoodCard(
                image: item['image'],
                price: item['price'],
                title: item['title'],
                store: item['store'],
                rating: item['rating'],
                orders: item['order'],
                onTap: () {
                  context.pushNamed("client_meal_screen");
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
