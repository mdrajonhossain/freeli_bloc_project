import 'package:flutter/material.dart';
import '../AppColors.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  final List<Map<String, String>> users = const [
    {
      "name": "John Doe",
      "msg": "Hey, how are you?",
      "time": "20/10/2023",
      "count": "2",
    },
    {
      "name": "Sarah Khan",
      "msg": "Let’s meet tomorrow",
      "time": "19/10/2023",
      "count": "5",
    },
    {
      "name": "Alex Smith",
      "msg": "Project update?",
      "time": "18/10/2023",
      "count": "0",
    },
    {
      "name": "Emma Watson",
      "msg": "Call me please",
      "time": "17/10/2023",
      "count": "1",
    },
    {
      "name": "Sarah Khan",
      "msg": "Let’s meet tomorrow",
      "time": "19/10/2023",
      "count": "5",
    },
    {
      "name": "Alex Smith",
      "msg": "Project update?",
      "time": "18/10/2023",
      "count": "0",
    },
    {
      "name": "Sarah Khan",
      "msg": "Let’s meet tomorrow",
      "time": "19/10/2023",
      "count": "5",
    },
    {
      "name": "Alex Smith",
      "msg": "Project update?",
      "time": "18/10/2023",
      "count": "0",
    },
    {
      "name": "Sarah Khan",
      "msg": "Let’s meet tomorrow",
      "time": "19/10/2023",
      "count": "5",
    },
    {
      "name": "Alex Smith",
      "msg": "Project update?",
      "time": "18/10/2023",
      "count": "0",
    },
    {
      "name": "Sarah Khan",
      "msg": "Let’s meet tomorrow",
      "time": "19/10/2023",
      "count": "5",
    },
    {
      "name": "Alex Smith",
      "msg": "Project update?",
      "time": "18/10/2023",
      "count": "2",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 40, left: 16, right: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.green.withOpacity(
            0.1,
          ), // Green background for list items
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor:
                  AppColors.accentColor, // Use accent color for avatar
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              users[index]["name"]!,
              style: const TextStyle(
                color: Colors.white, // White text for visibility
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              users[index]["msg"]!,
              style: const TextStyle(
                color: Colors.white70,
              ), // Lighter text for visibility
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  users[index]["time"]!,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 5),
                if (users[index]["count"] != "0")
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      users[index]["count"]!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
