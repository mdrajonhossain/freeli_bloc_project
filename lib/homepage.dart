import 'package:flutter/material.dart';
import 'package:freeli/controller/api/api_service.dart';
import 'AppColors.dart';
import 'connect/ChatsTab.dart';
import 'connect/CallsTab.dart';
import 'connect/DashboardTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getBackgroundColor(isDark);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: bgColor,
        endDrawer: Drawer(
          backgroundColor: bgColor,
          child: Column(
            children: [
              /// ================= PROFILE HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(color: Color(0xFF1565C0)),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "john.doe@email.com",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ================= MENU ITEMS =================
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              /// ================= LOGOUT BUTTON =================
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      Navigator.pushNamed(context, "/login");
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ================= APP BAR =================
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
            255,
            12,
            31,
            94,
          ), // Darker background for app bar
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 5,
          title: Image.asset('assets/logo.webp', height: 45),

          actions: [
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'Search',
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              onPressed: () {},
              icon: const Icon(Icons.filter_alt_sharp, color: Colors.white),
              tooltip: 'Filter',
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.menu, color: Colors.white),
                  tooltip: 'Toggle menu',
                );
              },
            ),
            const SizedBox(width: 3),
          ],

          /// ================= TAB BAR =================
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            dividerColor: Colors.transparent,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),

            tabs: [
              Tab(icon: Icon(Icons.chat), text: "Chats"),
              Tab(icon: Icon(Icons.call), text: "Calls"),
              Tab(icon: Icon(Icons.dashboard), text: "Dashboard"),
            ],
          ),
        ),

        /// ================= BODY =================
        body: const TabBarView(
          children: [ChatsTab(), CallsTab(), DashboardTab()],
        ),
      ),
    );
  }
}
