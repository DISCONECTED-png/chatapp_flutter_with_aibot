import 'package:chatappbuild/auth/authgate.dart';
import 'package:chatappbuild/firebase_options.dart';
import 'package:chatappbuild/theme/themeprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  Gemini.init(apiKey: "AIzaSyDULdJaQN-gYVvucBXDlldVbpFt-XIsjgo");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const authgate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
