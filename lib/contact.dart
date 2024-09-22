import 'package:flutter/material.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}


class Contact extends StatefulWidget {
  const Contact({super.key, required this.name});
  final String name;
  

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  final ScrollController ListController = ScrollController();

  void _scrollDown() {
    ListController.animateTo(
      ListController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "g", messageType: "receiver"),
    ChatMessage(messageContent: "g", messageType: "receiver"),
    ChatMessage(messageContent: "ba", messageType: "sender"),
    ChatMessage(messageContent: "ll", messageType: "receiver"),
    ChatMessage(messageContent: "ballge", messageType: "sender"),
  ];
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.black,),
                ),
                const SizedBox(width: 2,),
                const CircleAvatar(
                  maxRadius: 20,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.name,style: const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                const Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: <Widget>[
            ListView.builder(
              controller: ListController,
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10,bottom: 50),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20, ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: myController,
                        decoration: const InputDecoration( 
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: () => setState(() {
                        messages.add(ChatMessage(messageContent: myController.text, messageType: "sender"));
                        myController.clear();
                        _scrollDown();
                      }),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      child: const Icon(Icons.send, color: Colors.white, size: 18,),
                    ),
                    const SizedBox(width: 5),
                  ],
                )
              )
            )
        ],
      )
    );
  }
}