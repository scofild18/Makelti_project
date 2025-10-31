import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.image,
    required this.price,
    required this.title,
    required this.store,
    required this.rating,
    required this.distance,
  });

  final String image;
  final String price;
  final String title;
  final String store;
  final double rating;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 12, right: 12,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                  Text(
                    store,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                    ],
                  ),
                  
                  
                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(left  : 2.0 , top: 6 ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.star, color: Colors.amber, size: 16),
                                                          Text(rating.toString()),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            "• $distance away",
                                                            style: const TextStyle(fontSize: 12),
                                                          ),
                                                        ],
                                      ),
                                    ),
                                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}