import 'package:chatappbuild/auth/authservice.dart';
import 'package:chatappbuild/chatservices/chatbubble.dart';
import 'package:chatappbuild/chatservices/chatservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatpage extends StatefulWidget {
  final String email;
  final String id;
  chatpage({super.key, required this.email, required this.id});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  final TextEditingController messagecontroller = TextEditingController();

  final chatservices chat = chatservices();

  final authservice auth = authservice();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500),()=>scrolldown());
  }

  @override
  void dispose() {
    focusNode.dispose();
    messagecontroller.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  void scrolldown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750), curve: Curves.fastOutSlowIn);
  }

  void sendmessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await chat.sendmessage(widget.id, messagecontroller.text);
      messagecontroller.clear();
    }
    scrolldown();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email.split('@').first),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildmessagelist(),
          ),
          builduserinput(),
        ],
      ),
    );
  }

  Widget buildmessagelist() {
    String senderid = auth.getcurrentuser()!.uid;
    return StreamBuilder(
      stream: chat.getmessages(widget.id, senderid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          controller: scrollController,
          children:
              snapshot.data!.docs.map((doc) => buildmessageitem(doc)).toList(),
        );
      },
    );
  }

  Widget buildmessageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool iscurrentuser = data['senderid'] == auth.getcurrentuser()!.uid;
    var alignment =
        iscurrentuser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child:
            chatbubble(currentUser: iscurrentuser, message: data["message"]));
  }

  Widget builduserinput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 5),
                child: TextField(
                  controller: messagecontroller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "  Type a Message",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),borderRadius: BorderRadius.circular(25)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),borderRadius: BorderRadius.circular(25)),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
              )
                  ),
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                  onPressed: sendmessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
