import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/feature/prompt/provider/prompt_provider.dart';
import 'package:ai_app/widgets/app_bar.dart';
import 'package:ai_app/widgets/custom_textfield.dart';
import 'package:ai_app/widgets/drawer.dart';

class CreatePromptScreen extends StatelessWidget {
  const CreatePromptScreen({super.key});

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
              // Display prompts and generated images as a scrollable list
              Expanded(
                child: ListView.builder(
                  itemCount:
                      provider.chatHistory.length, // Count the prompts only
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Prompt

                          // Space between prompt and image
                          // Generated Image
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // Align to the right
                            children: [
                              // Display generated image if exists
                              if (provider.imageHistory.isNotEmpty)
                                Container(
                                  width: 250,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(
                                          provider.imageHistory[index]),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              // User prompt text
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      250, // Adjust the maximum width as needed
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  provider.chatHistory[index],
                                  style: const TextStyle(color: Colors.black),
                                  overflow: TextOverflow
                                      .visible, // Allow text to wrap
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Text input and generate button always at the bottom
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CustomTextField inside Expanded
                    Expanded(
                      child: CustomTextField(
                        textStyle: TextStyle(color: Colors.black),
                        controller: provider.promptController,
                        hintText: 'Enter Prompt here',
                        enableBorder: true,
                        hintTextColor: Colors.black,
                        textAndIconColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                        width: 12), // Spacing between text field and button
                    // Icon button for generating image
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
