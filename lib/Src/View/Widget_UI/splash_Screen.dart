import 'package:flutter/material.dart';
import 'package:googlemap_list/Utils/Common_Widget/Colors.dart';
import 'package:googlemap_list/Utils/Common_Widget/Style.dart';
import 'dart:async';
import 'home_Page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 300,
              child: Image.asset('assets/images/location.png'),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Google Map Location',
                style: textLarge,
              ),
            ),
          ),
          // White loader at center
          const Center(
            child: CircularProgressIndicator(
              color: whiteColor, // White loader
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}
