// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, override_on_non_overriding_member, unused_local_variable, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/songs_lists_content.dart';
import 'package:groovix/bottom_sheets/bottom_sheet_menu.dart';
import 'package:groovix/bottom_sheets/home_song_list_settings.dart';
import 'package:groovix/Screenss/audio_query.dart';
import 'package:groovix/Screenss/favorites.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/Screenss/playlist_screen.dart';
import 'package:groovix/Screenss/search_screen.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  List<Widget> screens = [
    HomeContent(),
    const SearchScreen(),
    LikedScreen(backbutton: false),
    const PlaylistScreen(),
  ];
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (current == 0)
                  Row(
                    children: [
                      mytext(
                          'GROOVI',
                          20 * MediaQuery.of(context).size.width / 375.0,
                          color1white),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.048,
                        child: mytext(
                            'X',
                            26 * MediaQuery.of(context).size.width / 375.0,
                            color4blue2),
                      ),
                    ],
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0100),
                if (current == 0)
                  mytext(
                      'ALL SONGS',
                      16 * MediaQuery.of(context).size.width / 375.0,
                      color1white),
                SizedBox(height: MediaQuery.of(context).size.height * 0.00625),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: screens.length,
                    onPageChanged: (index) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        current = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return screens[index];
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.0750,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.0533),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            offset: Offset(-2, -2),
                            color: Colors.white10),
                        BoxShadow(
                            blurRadius: 6.0,
                            offset: Offset(8, 8),
                            color: Colors.black),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04),
                    child: BottomNavigationBar(
                      currentIndex: current,
                      selectedItemColor: Colors.white60,
                      onTap: (index) {
                        if (index == 4) {
                          showBottomSheetMenu(context);
                        } else {
                          setState(() {
                            current = index;

                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                            color: color1white,

                            // size: 25,
                          ),
                          label: 'Home',
                          backgroundColor: Color.fromARGB(255, 3, 2, 39),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.search,
                            color: color1white,
                          ),
                          label: 'Search',
                          backgroundColor: Color.fromARGB(255, 3, 2, 39),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: color1white,
                          ),
                          label: 'Favorites',
                          backgroundColor: Color.fromARGB(255, 3, 2, 39),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.playlist_add,
                            color: color1white,
                          ),
                          label: 'Playlist',
                          backgroundColor: Color.fromARGB(255, 3, 2, 39),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.menu,
                            color: color1white,
                          ),
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          label: 'Menu',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
