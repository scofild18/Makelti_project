import 'package:Makelti/widgets/home_screen/food_card.dart';
import 'package:Makelti/widgets/home_screen/nearby_stores_card.dart';
import 'package:Makelti/widgets/home_screen/search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> recentPosts = [
    {
      'title': 'Homemade Pasta Carbonara',
      'store': "Maria's Kitchen",
      'price': '\$12.99',
      'rating': 4.8,
      'distance': '0.5 km',
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Fresh Garden Salad Bowl',
      'store': "Green Eats",
      'price': '\$8.5',
      'rating': 4.9,
      'distance': '1.2 km',
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Chocolate Layer Cake',
      'store': "Sweet Delights",
      'price': '\$15',
      'rating': 5.0,
      'distance': '0.8 km',
      'image': 'assets/images/pasta.png'
    },
    {
      'title': 'Grilled Chicken Dinner',
      'store': "Chef's Table",
      'price': '\$14.5',
      'rating': 4.7,
      'distance': '2.1 km',
      'image': 'assets/images/salad.jpg'
    },
    {
      'title': 'Fluffy Breakfast',
      'store': "Morning Bliss",
      'price': '\$9.99',
      'rating': 4.6,
      'distance': '1.5 km',
      'image': 'assets/images/pasta.png'
    },
    { 
      'title': 'Classic Club Sandwich',
      'store': "Sandwich Stop",
      'price': '\$7.99',
      'rating': 4.5,
      'distance': '0.3 km',
      'image': 'assets/images/pasta.png'
    },
  ];

  final List<Map<String, dynamic>> nearbyStores = [
    {"name": "Maria's Kitchen", "distance": "0.5 km", "rating": 4.8 , "image" :'assets/images/pasta.png' } ,
    {"name": "Green Eats", "distance": "1.2 km", "rating": 4.9 ,  "image" :'assets/images/pasta.png'},
    {"name": "Sweet Delights", "distance": "0.8 km", "rating": 5.0 ,  "image" :'assets/images/pasta.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchBarWidget(),
              const Padding(
                padding: EdgeInsets.only(top : 2 , bottom: 2 , left  :  12  , right : 12   ),
                child: Divider(color: Color.fromARGB(255, 66, 65, 65), thickness: 0.09,),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Posts",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: Colors.orange),
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
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final item = recentPosts[index];
                    return FoodCard(
                            image: item['image'],
                            price: item['price'],
                            title: item['title'],
                            store: item['store'],
                            rating: item['rating'].toDouble(),
                            distance: item['distance'],
                          );
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Stores",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: nearbyStores.length,
                    itemBuilder: (context, index) {
                      final store = nearbyStores[index];
                      return NearbyStoresCard(
                          name: store['name'],
                          distance: store['distance'],
                          rating: store['rating'].toDouble(),
                          image: store['image'],
                        );
                    },
                  ),
                ),
              ),
        const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}



