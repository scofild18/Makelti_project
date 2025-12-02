import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:Makelti/widgets/custom_snackbar.dart';
import 'package:Makelti/logic/cubit/settings/settings_cubit.dart';
import 'package:Makelti/logic/cubit/settings/settings_state.dart';
import 'faq_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          CustomSnackBar.show(
            context,
            message: state.successMessage!,
            type: SnackBarType.success,
          );
          context.read<SettingsCubit>().clearMessages();
          
          // Navigate to register after successful logout
          Future.delayed(const Duration(milliseconds: 800), () {
            if (context.mounted) {
              context.go('/register');
            }
          });
        }
        if (state.errorMessage != null) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage!,
            type: SnackBarType.error,
          );
          context.read<SettingsCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // MAIN SETTINGS CONTAINER
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
                        iconColor: const Color(0xffe97844),
                        iconBgColor: const Color(0xFFFFE8E0),
                        title: 'Personal Information',
                        subtitle: 'Name, email, phone number',
                        onTap: () => context.push("/profile"),
                      ),

                      const Divider(height: 1, indent: 90),

                      _buildSettingItemWithSwitch(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xffe97844),
                        iconBgColor: const Color(0xFFFFE8E0),
                        title: 'Notifications',
                        subtitle: 'Receive notifications',
                        value: state.notificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleNotifications(value);
                          CustomSnackBar.show(
                            context,
                            message: value
                                ? 'Notifications enabled'
                                : 'Notifications disabled',
                            type: SnackBarType.info,
                          );
                        },
                      ),

                      const Divider(height: 1, indent: 90),

                      _buildSettingItem(
                        icon: Icons.help_outline,
                        iconColor: const Color(0xffe97844),
                        iconBgColor: const Color(0xFFFFE8E0),
                        title: 'FAQ',
                        subtitle: 'Frequently asked questions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FAQScreen(),
                            ),
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
      },
    );
  }

  // --------------------------------------------------------
  // NORMAL SETTING ITEM
  // --------------------------------------------------------

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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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

  // --------------------------------------------------------
  // SETTING ITEM WITH SWITCH
  // --------------------------------------------------------

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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xffe97844),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // LOGOUT DIALOG
  // --------------------------------------------------------

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: state.isLoggingOut
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: state.isLoggingOut
                      ? null
                      : () async {
                          Navigator.pop(dialogContext);

                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffe97844),
                              ),
                            ),
                          );

                          // Perform logout through cubit
                          await context.read<SettingsCubit>().logout();

                          if (!context.mounted) return;

                          // Close loading dialog
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
