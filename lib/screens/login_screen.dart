import 'package:flutter/material.dart';
import 'package:flash_chat/Components/rounded_Button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static const String id='login_Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  bool spinner=false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall: spinner,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                              child: Hero(
                  tag: 'logo',
                    child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  password=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Log In',colour: Colors.lightBlueAccent,onPressed: () async {
                setState(() {
                  spinner=true;
                });
                try{
                final user=await _auth.signInWithEmailAndPassword(email: email,password: password);
                if(user!=null){
                  Navigator.pushNamed(context, ChatScreen.id);
                }
                setState(() {
                  spinner=false;
                });
                }
                catch(e){
                  print(e);
                }
              },
              )
            ],
          ),
        ),
      ),
    );
  }
}
