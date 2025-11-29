import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SellerInfoCard extends StatefulWidget {
  const SellerInfoCard({
    super.key,
    required this.name,
    required this.distance,
    this.onViewTap,
  });

  final String name;
  final String distance;
  final VoidCallback? onViewTap;

  @override
  State<SellerInfoCard> createState() => _SellerInfoCardState();
}

class _SellerInfoCardState extends State<SellerInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.distance} away',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: widget.onViewTap ?? () {
              context.pushNamed("cook_profile");
            },
            child: const Text('View' , style: TextStyle(
              color: Colors.orange
            ),),
          ),
        ],
      ),
    );
  }
}
