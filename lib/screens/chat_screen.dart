import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Firestore _firestore=Firestore.instance;
FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id='chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
  final messageTextController=TextEditingController();
  String messageText;
  void getCurrentUser() async {
    try{
    final user=await _auth.currentUser();        
    if(user!=null){
      loggedInUser=user;
      print(loggedInUser.email);
    }
    }
    catch(e){
      print(e);
    }
  }
  // void getMessages() async {
  //   final messages=await _firestore.collection('messages').getDocuments();
  //   for(var msg in messages.documents){
  //     print(msg.data);
  //   }
  // }
  // void messageStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.documents){
  //       print(message.data);
  //     }
  //   }
  // }
  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //getMessages();
                // messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'text':messageText,
                          'sender':loggedInUser.email,
                        }
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
final String text;
final String sender;
final bool isMe;
MessageBubble({this.sender,this.text,this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe?BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ):BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(text,
              style: TextStyle(
                fontSize: 15.0,
                color: isMe?Colors.white:Colors.black,
              ),
          ),
            ),
  ),
        ],
      ),
    );
 }
}
class MessageStream extends StatefulWidget {
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                  final messages=snapshot.data.documents.reversed;
                  List<MessageBubble> messageBubbles=[];
                  for(var message in messages){
                    final messageText=message.data['text'];
                    final messageSender=message.data['sender'];
                    final currentUser=loggedInUser.email;
                    final messageBubble=MessageBubble(
                      sender:messageSender,
                      text:messageText,
                      isMe: currentUser==messageSender?true:false,  
                    );                                        
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: false,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageBubbles,
                    ),
                  );                
              },
            );
  }
}