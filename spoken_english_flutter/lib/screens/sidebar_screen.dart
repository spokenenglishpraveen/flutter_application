import 'package:flutter/material.dart';

class SidebarScreen extends StatelessWidget {
  final String name;
  final String? email;
  final String? phone;
  final VoidCallback onLogout;

  const SidebarScreen({
    super.key,
    required this.name,
    this.email,
    this.phone,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email ?? phone ?? 'No contact info'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0] : '',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Optionally navigate to Profile
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
