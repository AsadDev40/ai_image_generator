import 'package:ai_app/feature/prompt/provider/prompt_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body: Consumer<PromptProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.chatHistory.length,
            itemBuilder: (context, index) {
              // Ensure that the image exists before trying to display it
              final image = index < provider.imageHistory.length
                  ? provider.imageHistory[index]
                  : null;

              return ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the image (if it exists)
                    if (image != null)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    const SizedBox(width: 12), // Space between image and title
                    // Display the chat prompt (title)
                    Expanded(
                      child: Text(
                        provider.chatHistory[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    // Delete icon button
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Call the delete function from provider to remove chat
                        provider.deleteChat(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
