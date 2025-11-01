import 'package:flutter/material.dart';

class UserKitchenProfile extends StatefulWidget {
  const UserKitchenProfile({super.key});

  @override
  State<UserKitchenProfile> createState() => _UserKitchenProfileState();
}

class _UserKitchenProfileState extends State<UserKitchenProfile> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedTab = 0; // 0 for Recent Posts, 1 for History
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController(text: "Maria's Kitchen");
  final TextEditingController _locationController = TextEditingController(text: "Downtown, City Center");
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
    _nameController.dispose();
    _locationController.dispose();
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
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
                    // Edit button
                    const SizedBox(height: 15),
                    // Profile Image
                    Stack(
                      children: [
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
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Image picker would open here'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Color(0xFFFF7043),
                                  ),
                                );
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Color(0xFFFF6B35),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Restaurant Name - Editable
                    if (_isEditing)
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter name",
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      )
                    else
                      Text(
                        _nameController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    
                    const SizedBox(height: 6),
                    
                    // Location - Editable
                    if (_isEditing)
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _locationController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 16,
                            ),
                            hintText: "Enter location",
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _locationController.text,
                            style: const TextStyle(
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
  
  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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