// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/bottom_sheets/home_song_list_settings.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<MusicSong> findsong = [];
  List<MusicSong> songlist = [];
  final _audioplayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    getsongs();
  }

  void getsongs() async {
    songlist = await music();
    setState(() {
      findsong = songlist;
    });
  }

  void searchFunction() {
    if (searchController.text.isEmpty) {
      setState(() {
        findsong = songlist;
      });
    } else {
      setState(() {
        findsong = songlist
            .where((song) =>
                song.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                song.artist
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    debugPrint('object hellow');
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _audioplayer.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.0533),
                mytext(
                  'SEARCH SONGS ',
                  18 * MediaQuery.of(context).size.width / 375.0,
                  Colors.white70,
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.0525,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 5, 4, 84),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(-1, -1),
                        color: Colors.white10),
                    BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(5, 5),
                        color: Colors.black),
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: color1white,
                      size: 28 * MediaQuery.of(context).size.width / 375.0,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.0267),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          searchFunction();
                        },
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                            hintText: 'Search....',
                            hintStyle: GoogleFonts.aboreto(
                              color: color1white,
                              fontSize: 18 *
                                  MediaQuery.of(context).size.width /
                                  375.0,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.0267),
                    IconButton(
                        onPressed: () {
                          searchController.clear();
                          searchFunction();
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: color1white,
                          size: 28 * MediaQuery.of(context).size.width / 375.0,
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: findsong.isEmpty
                  ? Center(
                      child: Text(
                        'No songs found',
                        style: GoogleFonts.aboreto(
                            color: Colors.white, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: findsong.length,
                      itemBuilder: (context, index) {
                        // final isLiked = likedSongs.contains(index);

                        return Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0267),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: bgTheme(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.04),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  offset: Offset(-1, -1),
                                  color: Colors.white10,
                                ),
                                BoxShadow(
                                  blurRadius: 6.0,
                                  offset: Offset(8, 8),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.0267),
                              ),
                              leading: QueryArtworkWidget(
                                id: findsong[index].Songid,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: Icon(
                                    Icons.music_note,
                                    color: color1white,
                                    size: 40 *
                                        MediaQuery.of(context).size.width /
                                        375.0,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                // ignore: use_build_context_synchronously
                                context
                                    .read<SongModelProvider>()
                                    .setId(findsong[index].Songid);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayScreen(
                                        songModel: findsong,
                                        audioplayer: _audioplayer,
                                        index: index,
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    setState(() {});
                                  });
                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    findsong[index].name,
                                    style: GoogleFonts.aboreto(
                                      color: color1white,
                                      fontSize: 16 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.00625),
                                  Text(
                                    findsong[index].artist,
                                    style: GoogleFonts.aboreto(
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                      color: color1white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        favList();
                                        likeDbFuction(findsong[index]);
                                      });
                                    },
                                    icon: Icon(
                                      findsong[index].islike
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: color1white,
                                      size: 27 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  IconButton(
                                    onPressed: () {
                                      showBottomSheetSongSettings(
                                          context,
                                          findsong,
                                          _audioplayer,
                                          index,
                                          findsong[index].Songid);
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: color1white,
                                      size: 28 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
