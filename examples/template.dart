import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final Widget child;

  const MyApp(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Material(color: Colors.black, child: child),
    );
  }
}