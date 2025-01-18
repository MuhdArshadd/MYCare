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
  bool isLoading = false; // Flag to track if response is loading

  // Instance of the OpenAIService
  final OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    _addInitialGreeting();
  }

  void _addInitialGreeting() async {
    setState(() {
      isLoading = true; // Show typing animation for the initial message
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate delay for typing
    setState(() {
      _messages.add({'role': 'system', 'content': 'Hello! How can I assist you today?'});
      isLoading = false; // Stop typing animation
    });

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // Function to send a message and process the response
  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'role': 'user', 'content': message});
        isLoading = true; // Start typing animation
      });

      _controller.clear();

      try {
        String response = await openAIService.runConversation(message);
        setState(() {
          _messages.add({'role': 'system', 'content': response});
          isLoading = false; // Stop typing animation
        });

        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } catch (e) {
        setState(() {
          _messages.add({'role': 'system', 'content': 'Error: Unable to get response from the AI.'});
          isLoading = false; // Stop typing animation
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (isLoading ? 1 : 0), // Include typing animation if loading
              itemBuilder: (context, index) {
                if (index == _messages.length && isLoading) {
                  // Typing animation widget
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/icon_chatbot.png'), // Replace with your chatbot profile image
                    ),
                    title: Row(
                      children: [
                        Text('.', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 5),
                        Text('.', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 5),
                        Text('.', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return ListTile(
                  leading: isUser
                      ? null
                      : CircleAvatar(
                    backgroundImage: AssetImage('assets/icon_chatbot.png'), // Replace with chatbot profile image
                  ),
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
