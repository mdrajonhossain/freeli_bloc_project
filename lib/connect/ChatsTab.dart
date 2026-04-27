import 'package:flutter/material.dart';
import '../AppColors.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFab() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: const Offset(-20, -50), // ✅ 10px more up
          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.6),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: AppColors.accentColor,
                onPressed: () {},
                child: const Icon(Icons.add, size: 35, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF152A6E);
    return Scaffold(
      backgroundColor: primaryBlue,

      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 120,
          left: 16,
          right: 16,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.green.withOpacity(0.1),
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.accentColor,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                users[index]["name"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                users[index]["msg"]!,
                style: const TextStyle(color: Colors.white70),
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
      ),

      floatingActionButton: _buildFab(),
    );
  }
}
