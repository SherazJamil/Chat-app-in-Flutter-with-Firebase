import 'package:chat_app/Authentication%20Methods/Autheticate.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute:  Authenticate(),
      duration: 3000,
      imageSize: 150,
      imageSrc: "assets/Chat.png",
      text: "Mi Chat",
      textType: TextType.ScaleAnimatedText,
      textStyle: const TextStyle(
        color: Colors.deepOrange,
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}