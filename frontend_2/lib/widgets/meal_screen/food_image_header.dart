import 'package:flutter/material.dart';

class FoodImageHeader extends StatelessWidget {
  const FoodImageHeader({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.herotag,
    required this.isFavorite,
    required this.onBackPressed,
    required this.onFavoritePressed,
  });

  final String imageUrl;
  final String price;
  final bool isFavorite;
  final String herotag;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Hero(
            tag: herotag,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant, size: 80),
                );
              },
            ),
          ),
        ),
        // Price Badge
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 50,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed,
            ),
          ),
        ),
        // Favorite Button
        Positioned(
          top: 50,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: onFavoritePressed,
            ),
          ),
        ),
      ],
    );
  }
}
