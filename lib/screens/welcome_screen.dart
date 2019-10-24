import 'package:flash_chat/Components/rounded_Button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 100.0
    );
    // animation=CurvedAnimation(parent: controller,curve: Curves.easeIn);
    controller.forward();
    // animation.addStatusListener((status){
    //   if(status==AnimationStatus.completed){
    //     controller.reverse(from:1.0);
    //   }
    //   else if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);
    controller.addListener((){
      setState(() {
    });
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                                  child: Hero(
                    tag: 'logo',
                      child: Container(
                      child: Image.asset('images/logo.png'),
                      height: controller.value,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                      text:['Flash Chat'],
                      textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),                
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(colour: Colors.lightBlueAccent,title: 'Log In',onPressed: (){ Navigator.pushNamed(context, LoginScreen.id);},),
            RoundedButton(colour: Colors.blueAccent,title: 'Register',onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},),
          ],
        ),
      ),
    );
  }
}

