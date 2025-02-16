import 'package:ai_app/screens/image_view.dart';
import 'package:ai_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:ai_app/provider/prompt_provider.dart';
import 'package:ai_app/widgets/app_bar.dart';
import 'package:ai_app/widgets/custom_textfield.dart';
import 'package:ai_app/widgets/drawer.dart';

class CreatePromptScreen extends StatelessWidget {
  const CreatePromptScreen({super.key});

  Future<void> _downloadImage(Uint8List imageBytes) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: 'generated_image',
        );
        if (result['isSuccess'] == true) {
          Utils.showToast('Image saved successfully to gallery');
          debugPrint('Image saved successfully to gallery.');
        } else {
          Utils.showToast('Failed to save image to gallery');
          debugPrint('Failed to save image to gallery.');
        }
      } catch (e) {
        debugPrint('Error saving image: $e');
      }
    } else {
      debugPrint('Storage permission denied.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const DrawerWidget(),
      body: Consumer<PromptProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.chatHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (provider.imageHistory.isNotEmpty)
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImage(
                                              imageBytes:
                                                  provider.imageHistory[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: MemoryImage(
                                                provider.imageHistory[index]),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(Icons.download),
                                      color: Colors.black,
                                      onPressed: () => _downloadImage(
                                          provider.imageHistory[index]),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 250),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  provider.chatHistory[index],
                                  style: const TextStyle(color: Colors.black),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        textStyle: const TextStyle(color: Colors.black),
                        controller: provider.promptController,
                        hintText: 'Enter Prompt here',
                        enableBorder: true,
                        hintTextColor: Colors.black,
                        textAndIconColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        if (provider.promptController.text.isNotEmpty) {
                          provider
                              .generateImage(provider.promptController.text);
                        }
                        provider.promptController.clear();
                      },
                      icon: const Icon(Icons.send, size: 32),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
