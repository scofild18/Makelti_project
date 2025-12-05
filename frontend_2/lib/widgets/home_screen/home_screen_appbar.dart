import 'package:flutter/material.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/pizza_store.jpg"),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        Text("Hello, Bahae 👋", style: TextStyle(fontSize: 12)),
        Text(
          "Welcome Back",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
                  ],
                ),
              ],
            ),
        
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: SizedBox(
            width: 120, 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/location.png",
                  height: 20,
                ),
                const SizedBox(width: 6),
        
                const Expanded(
                  child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Location",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            "Algiers, Sidi Abdellah",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
                  ),
                ),
              ],
            ),
          ),
        )
          ],
        );
  }
}