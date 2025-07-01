import 'package:flutter/material.dart';
import 'package:phamarcy_system/features/auth/login.dart';
import '../../../widgets/util/theme_provider.dart';
import 'package:provider/provider.dart';

// screen
import '/features/splash/splashscreen.dart';
import '/features/home/main_layout.dart';
import '/features/home/settings/profile_screen.dart';
import '/features/home/settings/change_password_screen.dart';
import '/features/home/settings/notification_screen.dart';
import '/features/home/settings/theme_screen.dart';
import '/features/home/settings/language_screen.dart';
import '/features/home/settings/inventory_screen.dart';
import '/features/home/settings/staff_screen.dart';
import '/features/home/settings/transaction_screen.dart';
import '/features/home/settings/help_screen.dart';
import '/features/home/settings/support_screen.dart';
import '/features/home/settings/about_screen.dart';




class Settingscreen extends StatelessWidget {

  const Settingscreen({super.key});



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Account",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: "Profile Information",
            subtitle: "View or update your profile",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
              // );
            },
          ),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: "Change Password",
            subtitle: "Update your login credentials",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ChangePassword()),
              // );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "App Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.notifications_none,
            title: "Notifications",
            subtitle: "Control notification preferences",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const NotificationScreen()),
              // );
            },
          ),
          _buildSettingTile(
            icon: Icons.palette_outlined,
            title: "Theme",
            subtitle: "Light / Dark mode",
            onTap: () {
            },
          ),

      _buildSettingTile(
            icon: Icons.language,
            title: "Language",
            subtitle: "Choose your preferred language",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LanguageScreen()),
              // );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Pharmacy Management",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.inventory_2_outlined,
            title: "Medicine Inventory",
            subtitle: "Manage stock and supplies",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const InventoryScreen()),
              // );
            },
          ),
          _buildSettingTile(
            icon: Icons.supervisor_account_outlined,
            title: "Staff & Roles",
            subtitle: "Manage pharmacists and permissions",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const StaffScreen()),
              // );
            },
          ),
          _buildSettingTile(
            icon: Icons.receipt_long,
            title: "Transaction History",
            subtitle: "View past sales and receipts",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const TransactionScreen()),
              // );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: "Help & FAQ",
            subtitle: "Common questions and guides",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HelpScreen()),
              // );
            },
          ),
          _buildSettingTile(
            icon: Icons.headset_mic,
            title: "Contact Support",
            subtitle: "Get assistance from support",
            onTap: () {
              // Navigate to support chat/contact
            },
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: "About Pharmacy",
            subtitle: "App version and company info",
            onTap: () {
              // Show about dialog
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.logout,color: Colors.white ,),
              label: const Text("Log Out",style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}