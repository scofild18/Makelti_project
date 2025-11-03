import 'package:Makelti/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'faq_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        elevation: 0,
      
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFFFF6B35),
                    iconBgColor: const Color(0xFFFFE8E0),
                    title: 'Personal Information',
                    subtitle: 'Name, email, phone number',
                    onTap: () {
                      context.push("/profile") ; 
                    },
                  ),
                  const Divider(height: 1, indent: 90),
                  _buildSettingItemWithSwitch(
                    icon: Icons.notifications_outlined,
                    iconColor: const Color(0xFFFF6B35),
                    iconBgColor: const Color(0xFFFFE8E0),
                    title: 'Notifications',
                    subtitle: 'Receive notifications',
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'Notifications enabled'
                                : 'Notifications disabled',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 90),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    iconColor: const Color(0xFFFF6B35),
                    iconBgColor: const Color(0xFFFFE8E0),
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FAQScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 90),
                  _buildSettingItem(
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    iconBgColor: const Color(0xFFFFE8E8),
                    title: 'Log Out',
                    subtitle: 'Logout from your account',
                    onTap: () => _showLogoutDialog(context),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItemWithSwitch({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFFF6B35),
          ),
        ],
      ),
    );
  }


void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              
              // ✅ Use GoRouter instead of Navigator
              context.goNamed('login'); 

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
}



// IconButton(
//   icon: Icon(Icons.settings),
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SettingsScreen()),
//     );
//   },
// )


// this is the button to use it