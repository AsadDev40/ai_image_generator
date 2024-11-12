import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_app/service/prompt_service.dart';

class PromptProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  late TextEditingController promptController;

  List<String> _chatHistory = []; // To store chat history (prompts)
  List<Uint8List> _imageHistory = []; // To store generated images

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  List<String> get chatHistory => _chatHistory; // Exposing chat history
  List<Uint8List> get imageHistory => _imageHistory; // Exposing image history

  PromptProvider() {
    promptController = TextEditingController(); // Initialize the controller
    loadChatHistory(); // Load saved chat history on app startup
  }

  // Function to generate image based on the prompt
  Future<void> generateImage(String prompt) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      Uint8List? bytes = await Promptservice.generateImage(prompt);
      if (bytes != null) {
        _chatHistory.add(prompt); // Save the prompt to history
        _imageHistory.add(bytes); // Save the image to history
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      saveChatHistory(); // Save updated history locally
      notifyListeners();
    }
  }

  // Function to load the saved chat history from local storage
  Future<void> loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPrompts = prefs.getStringList('chatHistory') ?? [];
    final storedImages = prefs.getStringList('imageHistory') ?? [];

    _chatHistory = storedPrompts;

    // Convert stored image data (base64 strings) back to Uint8List
    _imageHistory = storedImages.map((imageStr) {
      return Uint8List.fromList(
          imageStr.codeUnits); // Convert string back to Uint8List
    }).toList();

    notifyListeners();
  }

  // Function to save the chat history locally
  Future<void> saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Save the prompts
    prefs.setStringList('chatHistory', _chatHistory);

    // Save the images (convert each image to a base64 string)
    prefs.setStringList(
      'imageHistory',
      _imageHistory.map((image) => String.fromCharCodes(image)).toList(),
    );
  }

  // Function to clear the chat history
  void clearChat() {
    _chatHistory.clear();
    _imageHistory.clear();
    saveChatHistory(); // Save the cleared history locally
    notifyListeners();
  }

  // Function to delete a specific chat entry (prompt and image)
  void deleteChat(int index) {
    _chatHistory.removeAt(index); // Remove the prompt from chat history
    _imageHistory
        .removeAt(index); // Remove the corresponding image from image history
    saveChatHistory(); // Save the updated history locally
    notifyListeners(); // Notify listeners to update the UI
  }

  // Dispose the controller when no longer needed
  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }
}
