import 'dart:typed_data';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImage({required this.imageBytes, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.memory(imageBytes, fit: BoxFit.contain),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
