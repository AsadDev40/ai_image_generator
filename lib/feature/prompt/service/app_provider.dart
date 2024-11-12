import 'package:ai_app/feature/prompt/provider/prompt_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PromptProvider()),
        ],
        child: child,
      );
}
