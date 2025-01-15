import 'package:flutter/material.dart';
import '../controller/openAIController.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;  // Flag to track if response is loading

  // Instance of the OpenAIService
  final OpenAIService openAIService = OpenAIService();

  // Function to send a message and process the response
  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'role': 'user', 'content': message});
        isLoading = true;  // Start loading animation
      });

      _controller.clear();

      try {
        // Directly call the backend service for querying
        String response = await openAIService.processUserQuery(message);
        setState(() {
          _messages.add({'role': 'system', 'content': response});
          isLoading = false;  // Stop loading animation
        });

        // Auto-scroll to the latest message after receiving a response
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } catch (e) {
        setState(() {
          _messages.add({'role': 'system', 'content': 'Error: Unable to get response from the AI.'});
          isLoading = false;  // Stop loading animation on error
        });
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MYCare AI Chatbot'),
        backgroundColor: Colors.blue,  // Set the AppBar background color to blue
        foregroundColor: Colors.white, // Set the text color to white
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)  // Show loading animation if isLoading is true
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('AI is thinking'),
                  SizedBox(width: 10),
                  CircularProgressIndicator(),  // Show loading spinner
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Ask something...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
