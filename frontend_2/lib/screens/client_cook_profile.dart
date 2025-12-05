import 'package:flutter/material.dart';

class ClientCookProfile extends StatefulWidget {
  const ClientCookProfile({super.key});

  @override
  State<ClientCookProfile> createState() => _ClientCookProfileState();
}

class _ClientCookProfileState extends State<ClientCookProfile> {
  int _selectedTab = 0; // 0 for Recent Posts, 1 for History
  final TextEditingController _nameController =
      TextEditingController(text: "Maria's Kitchen");
  final TextEditingController _locationController =
      TextEditingController(text: "Downtown, City Center");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFF6B35), Color(0xFF880404)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // No edit button for client view
                    const SizedBox(height: 16),

                    // Profile Image
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      _nameController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _locationController.text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "4.8 (124 reviews)",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 65),
                  ],
                ),
              ),
            ),

            // Tabs + Posts
            Transform.translate(
              offset: const Offset(0, -40),
              child: _buildTabs(),
            ),
            const SizedBox(height: 15),
            _selectedTab == 0 ? _buildRecentPosts() : _buildHistory(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTab = 0);
                  },
                  child: _buildTab("Recent Posts", _selectedTab == 0),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTab = 1);
                  },
                  child: _buildTab("History", _selectedTab == 1),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTab(String text, bool isSelected) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ),
      );

  Widget _buildRecentPosts() => Column(
        children: [
          _buildMealItem("Homemade Pasta Carbonara", "34 sold", "\$12.99",
              "available", true),
          _buildMealItem(
              "Fresh Garden Salad Bowl", "28 sold", "\$8.5", "available", true),
          _buildMealItem("Chocolate Layer Cake", "56 sold", "\$15", "sold out",
              false),
        ],
      );

  Widget _buildHistory() => Column(
        children: [
          _buildMealItem("Grilled Salmon with Veggies", "89 sold", "\$18.99",
              "sold out", false),
          _buildMealItem("Caesar Salad Classic", "67 sold", "\$10.50",
              "sold out", false),
          _buildMealItem(
              "Margherita Pizza Special", "124 sold", "\$14.99", "sold out", false),
        ],
      );

  Widget _buildMealItem(
          String name, String sold, String price, String status, bool isAvailable) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.image_outlined,
                    color: Colors.grey[400], size: 35),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.25)),
                    const SizedBox(height: 6),
                    Text(sold, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(price,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF7043))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isAvailable ? const Color(0xFFFF7043) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}