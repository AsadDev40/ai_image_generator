import 'package:ai_app/provider/prompt_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'AI Image Generator',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 5,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.add_comment,
            color: Colors.white,
          ),
          onPressed: () {
            Provider.of<PromptProvider>(context, listen: false).clearChat();
            // Navigate to settings page
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
