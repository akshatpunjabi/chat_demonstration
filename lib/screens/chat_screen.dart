import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final orgName = 'MIT';
final _fireStore = FirebaseFirestore.instance;
User currentUser;
ScrollController _scrollController = ScrollController();

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String subjectName;
  ChatScreen(String subject) {
    subjectName = subject;
  }
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    currentUser = auth.currentUser;
    super.initState();
  }

  final messageTextController = TextEditingController();
  String messageText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subjectName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              orgName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MessagesStream(widget.subjectName),
              Container(
                padding: EdgeInsets.only(bottom: 10, right: 5, left: 15),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black12, width: 2.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            validator: (val) {
                              if (val.trim().length == 0) {
                                return "The message cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Enter your message here",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 200),
                          );
                          messageTextController.clear();
                          _fireStore
                              .collection('messages' + widget.subjectName)
                              .add({
                            'text': messageText,
                            'sender': currentUser == null
                                ? 'hey'
                                : currentUser.phoneNumber,
                            'date': DateTime.now().toIso8601String().toString(),
                          });
                          //messageText + loggedInUser.email
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  String subjectName;
  MessagesStream(String subject) {
    subjectName = subject;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages' + subjectName)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        //this is flutter's async snapshot which is different from the query snapshot we use above.
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser.phoneNumber == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            controller: _scrollController,
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final bool isMe;
  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.black12)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
