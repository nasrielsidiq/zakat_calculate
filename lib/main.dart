import 'package:flutter/material.dart';
import 'package:zakat_hub/index.dart';
// import 'package:zakat_hub/landingpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyIndex()
    );
  }
}
