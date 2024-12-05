import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class geminipage extends StatefulWidget {
  const geminipage({super.key});

  @override
  State<geminipage> createState() => _geminipageState();
}

class _geminipageState extends State<geminipage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser  currentUser  = ChatUser (id: "0", firstName: "User  ");
  ChatUser  geminiUser  = ChatUser (
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-gemini-icon.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Talk With Gemini"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return DashChat(
      currentUser:currentUser ,
      onSend: sendMessage,
      messages: messages,
      inputOptions: InputOptions(
          inputTextStyle: TextStyle(color: Colors.white),
          inputDecoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.secondary,
            hintText: "Write A Message",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(15)),
          )),
      messageOptions: MessageOptions(
        containerColor: Colors.grey.shade800,
        textColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }

  void sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.insert(0, chatMessage); // Add user message to the top

      // Add a loading message
      messages.insert(0, ChatMessage(
        user: geminiUser ,
        createdAt: DateTime.now(),
        text: "Loading...", // Placeholder text for loading
      ));
    });

    String question = chatMessage.text;
    StringBuffer responseBuffer = StringBuffer(); // Buffer to accumulate responses

    // Start streaming content from Gemini
    gemini.streamGenerateContent(question).listen((event) {
      String responseText =
          event.content?.parts?.map((part) => part.text).join(" ") ?? "";

      // Append the response part to the buffer
      responseBuffer.write(responseText + " ");
    }, onDone: () {
      // Create a new message for Gemini's complete response
      ChatMessage responseMessage = ChatMessage(
        user: geminiUser ,
        createdAt: DateTime.now(),
        text: responseBuffer.toString().trim(), // Use the accumulated response
      );

      // Update the messages list with the new response
      setState(() {
        // Remove the loading message
        messages.removeAt(0); // Remove the loading message
        messages.insert(0, responseMessage); // Add Gemini's response to the top
      });
    }, onError: (error) {
      // Handle any errors that occur during streaming
      print("Error: $error");
      setState(() {
        // Remove the loading message
        messages.removeAt(0); // Remove the loading message
      });
    });
  }
}