import 'package:flutter/material.dart';
import 'package:img_gen_a_i/home_screen.dart';
import 'color_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ai Image Generator',
      theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, elevation: 0.0)),
      home: const HomeScreen(),
    );
  }
}
