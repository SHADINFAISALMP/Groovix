// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groovix/Screenss/audio_query.dart';
import 'package:groovix/Screenss/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {  
  final GetAudio _getAudio = GetAudio();
  @override
  void initState() {
  
    

    debugPrint('heyy');
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      ),
    );
   
    _getAudio.requestPermision();
  

      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Image.asset("assets/images/splashhh.jpg",fit: BoxFit.cover,height: double.infinity,width: double.infinity,));
  }
}
