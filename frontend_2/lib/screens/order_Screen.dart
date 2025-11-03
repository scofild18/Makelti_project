import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // This list will be populated from your API when user places orders
  List<Order> orders = [
    Order(
      id: '1',
      restaurantName: "Maria's Kitchen",
      date: '23 Oct 2025',
      mealName: 'Fresh Garden Salad',
      mealCategory: 'Green Bowl',
      price: 8.5,
      quantity: 1,
      status: OrderStatus.accepted,
      mealImage: '', // TODO: Add image URL from backend
    ),
    Order(
      id: '2',
      restaurantName: 'Chef Antoine',
      date: '23 Oct 2025',
      mealName: 'Pasta Carbonara',
      mealCategory: 'Italian Cuisine',
      price: 12.0,
      quantity: 2,
      status: OrderStatus.pending,
      mealImage: '',
    ),
    Order(
      id: '3',
      restaurantName: 'Le Bistro',
      date: '22 Oct 2025',
      mealName: 'Homemade Burger',
      mealCategory: 'Fast Food',
      price: 10.0,
      quantity: 1,
      status: OrderStatus.refused,
      mealImage: '',
    ),
    Order(
      id: '4',
      restaurantName: 'Tlitli',
      date: '22 Oct 2025',
      mealName: 'Homemade Burger',
      mealCategory: 'Fast Food',
      price: 10.0,
      quantity: 1,
      status: OrderStatus.refused,
      mealImage: '',
    ),
    Order(
      id: '3',
      restaurantName: 'Chourba',
      date: '22 Oct 2025',
      mealName: 'Homemade Burger',
      mealCategory: 'Fast Food',
      price: 10.0,
      quantity: 1,
      status: OrderStatus.accepted,
      mealImage: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            ),
    );
  }

  // Empty state when no orders
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your orders will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Order card widget
  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Restaurant name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.restaurantName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.date,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(order.status),
            ],
          ),

          const Divider(height: 24),

          // Meal details
          Row(
            children: [
              // Meal image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: order.mealImage.isEmpty
                    ? const Icon(Icons.restaurant, size: 40, color: Color(0xFFFF6B35))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          order.mealImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Color(0xFFFF6B35),
                            );
                          },
                        ),
                      ),
              ),

              const SizedBox(width: 16),

              // Meal info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.mealName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.mealCategory,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ),

              // Quantity
              Text(
                'Qty: ${order.quantity}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Status badge widget
  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.accepted:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        text = 'Accepted';
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.pending:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        text = 'Pending';
        icon = Icons.access_time;
        break;
      case OrderStatus.refused:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        text = 'Refused';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Order model
class Order {
  final String id;
  final String restaurantName;
  final String date;
  final String mealName;
  final String mealCategory;
  final double price;
  final int quantity;
  final OrderStatus status;
  final String mealImage;

  Order({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.mealName,
    required this.mealCategory,
    required this.price,
    required this.quantity,
    required this.status,
    required this.mealImage,
  });
}

// Order status enum
enum OrderStatus {
  accepted, // Seller accepted the order
  pending, // Waiting for seller to accept/refuse
  refused, // Seller refused the order
}
