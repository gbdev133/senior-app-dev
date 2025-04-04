import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contact.dart';

class Chat extends StatefulWidget {
  Chat({super.key, required this.contacts});
  final List<Widget> contacts;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  
  void _addContact(String name) {
    setState(() {
      widget.contacts.add(
        ListTile(
          key: UniqueKey(),
          leading: const Icon(Icons.person),
          title: Text(name),
          onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => Contact(name: name))
              );
          }
      ));
    });
  }

void _showAddContactDialog() {
  myController.clear();
  if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Contact Name'),
          content: TextField(
            controller: myController,
            decoration: const InputDecoration(hintText: "Contact Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                if (myController.text.isNotEmpty) {
                  _addContact(myController.text);
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Contacts"),
          backgroundColor: Colors.blue,

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddContactDialog,
          child: const Icon(Icons.add),
        ),
        body: RawScrollbar(
          thickness: 6.0,
          thumbColor: Colors.lightBlue,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: widget.contacts,
          ),
        )
      );
  }
}
