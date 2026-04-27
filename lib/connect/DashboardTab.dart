import 'package:flutter/material.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF152A6E);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= GREETING =================
              const Text(
                "Hi, User,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              const Text(
                "Here is your day in review you have",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 25),

              _sectionTitle("Notifications Since You Last Left"),
              _infoCard("No new notifications"),

              const SizedBox(height: 20),

              _sectionTitle("Recent Uploaded Files"),
              _infoCard("Project_Report.pdf\nDesign_Mockup.png"),

              const SizedBox(height: 20),

              _sectionTitle("Favorite Items"),
              _infoCard("Sarah Khan\nAlex Smith\nEmma Watson"),

              const SizedBox(height: 20),

              _sectionTitle("Flagged Items"),
              _infoCard("2 messages flagged for review"),

              const SizedBox(height: 25),

              _sectionTitle("All Modules"),

              const SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: [
                  _moduleCard(Icons.task_alt, "Tasks"),
                  _moduleCard(Icons.folder, "File Hub"),
                  _moduleCard(Icons.analytics, "Analytics"),
                  _moduleCard(Icons.settings, "Settings"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= STATS CARD =================
  static Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF152A6E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// ================= INFO CARD =================
  static Widget _infoCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF152A6E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, height: 1.4),
      ),
    );
  }

  /// ================= MODULE CARD =================
  static Widget _moduleCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF152A6E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
