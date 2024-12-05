import 'package:chatappbuild/auth/authservice.dart';
import 'package:chatappbuild/settingspage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final auth = authservice();
    auth.signout();
    Navigator.pop(context); // Close the drawer after logout
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.message,
                      size: 60,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    SizedBox(height: 10),
                    Text(
                      ' Pagger ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  "H O M E",
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                leading: Icon(Icons.home, color: Theme.of(context).colorScheme.tertiary),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "S E T T I N G",
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.tertiary),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const settingpage(),
                    ),
                  );
                },
              ),
              Divider(color: Theme.of(context).colorScheme.tertiary), // Divider for better separation
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.tertiary),
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
