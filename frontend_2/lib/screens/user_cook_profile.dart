import 'package:flutter/material.dart';

class UserCookProfile extends StatefulWidget {
  const UserCookProfile({super.key});

  @override
  State<UserCookProfile> createState() => _UserCookProfileState();
}

class _UserCookProfileState extends State<UserCookProfile> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedTab = 0; // 0 for Recent Posts, 1 for History
  late AnimationController _tabAnimationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.03, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
    
    _tabAnimationController.forward();
  }

  @override
  void dispose() {
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _switchTab(int newTab) {
    if (_selectedTab != newTab) {
      setState(() {
        _selectedTab = newTab;
      });
      _tabAnimationController.reset();
      _tabAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFF6B35),
                    Color(0xFF880404),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    // Profile Image
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Restaurant Name
                    const Text(
                      "Maria's Kitchen",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Location
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Downtown, City Center",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.8 ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "(124 reviews)",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            

            const SizedBox(height: 20),
            // Tabs with wrapper container
            Padding(
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
                          onTap: () => _switchTab(0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubicEmphasized,
                            child: _buildTab("Recent Posts", _selectedTab == 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _switchTab(1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubicEmphasized,
                            child: _buildTab("History", _selectedTab == 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 15),
            
            // Content based on selected tab with smooth animation
            if (_fadeAnimation != null && _slideAnimation != null)
              FadeTransition(
                opacity: _fadeAnimation!,
                child: SlideTransition(
                  position: _slideAnimation!,
                  child: _selectedTab == 0 ? _buildRecentPosts() : _buildHistory(),
                ),
              )
            else
              _selectedTab == 0 ? _buildRecentPosts() : _buildHistory(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.person_outline, "Profile", 0),
                _buildNavItem(Icons.restaurant_menu_outlined, "Add Meal", 1),
                _buildNavItem(Icons.shopping_bag_outlined, "Orders", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Recent Posts Content
  Widget _buildRecentPosts() {
    return Column(
      key: const ValueKey('recent'),
      children: [
        _buildMealItem(
          "Homemade\nPasta Carbonara",
          "34 sold",
          "\$12.99",
          "available",
          true,
        ),
        _buildMealItem(
          "Fresh Garden\nSalad Bowl",
          "28 sold",
          "\$8.5",
          "available",
          true,
        ),
        _buildMealItem(
          "Chocolate Layer Cake",
          "56 sold",
          "\$15",
          "sold out",
          false,
        ),
      ],
    );
  }

  // History Content
  Widget _buildHistory() {
    return Column(
      key: const ValueKey('history'),
      children: [
        _buildMealItem(
          "Grilled Salmon\nwith Veggies",
          "89 sold",
          "\$18.99",
          "sold out",
          false,
        ),
        _buildMealItem(
          "Caesar Salad\nClassic",
          "67 sold",
          "\$10.50",
          "sold out",
          false,
        ),
        _buildMealItem(
          "Margherita Pizza\nSpecial",
          "124 sold",
          "\$14.99",
          "sold out",
          false,
        ),
        _buildMealItem(
          "Chicken Tikka\nMasala",
          "45 sold",
          "\$16.00",
          "sold out",
          false,
        ),
      ],
    );
  }
  
  
  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
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
  }
  
  Widget _buildMealItem(
    String name,
    String sold,
    String price,
    String status,
    bool isAvailable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Placeholder for image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey[400],
                size: 35,
              ),
            ),
            
            const SizedBox(width: 14),
            
            // Meal Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sold,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7043),
                    ),
                  ),
                ],
              ),
            ),
            
            // Status Badge
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
  
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF7043) : Colors.grey[400],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFFFF7043) : Colors.grey[400],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}