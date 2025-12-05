// lib/screens/cook_dashboard_screen.dart
import 'package:Makelti/widgets/home_screen/cook_food_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CookDashboardScreen extends StatelessWidget {
   CookDashboardScreen({super.key});

  static const Color brand = Color(0xFFFF6B35); 

List<Map<String, dynamic>> get orders => [
  {
    'id': '34621',
    'food': 'Taam (Couscous with Raisins and Butter)',
    'client': 'John Doe',
    'qty': 2,
    'status': 'waiting',
  },
  {
    'id': '34622',
    'food': 'Grilled Meat',
    'client': 'Sara Lee',
    'qty': 1,
    'status': 'cooking',
  },
  {
    'id': '34623',
    'food': 'Avocado Salad',
    'client': 'Ali Hassan',
    'qty': 3,
    'status': 'waiting',
  },
];

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
      
body: SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  context.go("/cook_profile");
                },
                child: const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage("assets/images/pizza_store.jpg"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Maria's Kitchen",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 243, 243),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),
                        child: Text(
                          "Cookstro",
                          style: TextStyle(fontSize: 13, color: Color.fromARGB(176, 0, 0, 0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: const Color.fromARGB(255, 251, 251, 251),
                shape: const CircleBorder(),
                elevation: 3,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.notifications_none, color: Color.fromARGB(255, 73, 70, 70)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _SectionHeader(
              title: 'Orders',
              actionLabel: 'Go to Orders',
              onTapAction: () => context.go('/cook_orders'),
              actionColor: const Color.fromARGB(255, 249, 147, 111),
            ),
          ),

          const SizedBox(height: 2),

          SizedBox(
            height: 145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final o = orders[index];
                return Padding(
                  padding: const EdgeInsets.only(top : 8.0 , right : 8 , bottom: 8 , left : 2 ),
                  child: OrderCard(
                    id: o['id'],
                    food: o['food'],
                    client: o['client'],
                    qty: o['qty'],
                    status: o['status'],
                    brand: brand,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _SectionHeader(
              title: 'Menu',
              actionLabel: 'Go to Menu',
              onTapAction: () => context.go('/cook_menu'),
              actionColor:const Color.fromARGB(255, 249, 147, 111),
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                    context.pushNamed("cook_meal_screen");
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  ),
),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onTapAction;
  final Color actionColor;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTapAction,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: onTapAction,
          child: Text(actionLabel, style: TextStyle(color: actionColor, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final String id;         
  final String food;       
  final String client;     
  final int qty;           
  final String status;     
  final Color brand;

  const OrderCard({
    super.key,
    required this.id,
    required this.food,
    required this.client,
    required this.qty,
    required this.status,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String label;
    Color iconColor;

    if (status == 'cooking') {
      icon = Icons.local_fire_department;
      label = "Cooking";
      iconColor = brand;
    } else {
      icon = Icons.hourglass_top;
      label = "";
      iconColor = Colors.orange.shade700;
    }

    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(31, 48, 48, 48), blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                "№ $id",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
  food,
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  maxLines: 2, 
  overflow: TextOverflow.ellipsis, 
),
          const SizedBox(height: 2),

          Row(
            children: [
              Expanded(
                child: Text(
                  client,
                  style: const TextStyle(fontSize: 13, color: Color.fromARGB(221, 64, 64, 64)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      "x$qty",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}