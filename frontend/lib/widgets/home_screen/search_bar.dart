import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 6,
      offset: const Offset(0, 8),
    ),
            ],
          ),
          child: Row(
            children: [
    const Icon(Icons.search, color: Color.fromARGB(255, 72, 72, 72), size: 24),
    const SizedBox(width: 10),
    const Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search food or store...',
          hintStyle: TextStyle(color: Color.fromARGB(255, 114, 114, 114) , fontWeight: FontWeight.w200 , fontSize:14),
          border: InputBorder.none,
        ),
      ),
    ),
    Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.tune, color: Colors.black87, size: 20),
        onPressed: () {
    
        },
      ),
    ),
            ],
          ),
        );
  }
}