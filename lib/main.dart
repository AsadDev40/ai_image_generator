import 'package:ai_app/service/app_provider.dart';
import 'package:ai_app/screens/create_prompt_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppProvider(
      child: MaterialApp(
        home: CreatePromptScreen(),
      ),
    );
  }
}
