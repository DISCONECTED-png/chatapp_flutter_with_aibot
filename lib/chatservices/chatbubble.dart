import 'package:chatappbuild/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chatbubble extends StatelessWidget {
  final String message;
  final bool currentUser;
  const chatbubble(
      {super.key, required this.currentUser, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isdarkmode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
          color: currentUser
              ? (Theme.of(context).colorScheme.tertiary)
              : (Colors.grey.shade800),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Text(
        message,
        style: TextStyle(color: currentUser ? Colors.white : isdarkmode?Colors.white:Colors.white),
      ),
    );
  }
}
