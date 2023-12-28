// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/Screenss/open_playlist.dart';

import 'package:groovix/Screenss/recently_played.dart';
import 'package:groovix/Screenss/favorites.dart';
import 'package:groovix/Screenss/songs_lists_content.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/db_model/db_playlist_model.dart';
import 'package:groovix/reuseable_widgets.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key, Key? k});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String> playlistNames = [
    'Favorite songs',
    'Recently played',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          mytext('PLAYLIST', 18 * MediaQuery.of(context).size.width / 375.0,
              color1white),
          IconButton(
            onPressed: () {
              playlistnames(context: context);
            },
            icon: Icon(
              Icons.add,
              color: color1white,
              size: 33 * MediaQuery.of(context).size.width / 375.0,
            ),
          )
        ],
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.0267),
      Expanded(
        child: FutureBuilder(
          future: getfromplaylist(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              List<String> allPlaylist = List.from(playlistNames);
              allPlaylist.addAll(snapshot.data!.map((e) => e.name));
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.08,
                  mainAxisSpacing: MediaQuery.of(context).size.width * 0.08,
                ),
                itemCount: allPlaylist.length,
                itemBuilder: (context, index) {
                  Listmodel? currentplaylist;
                  if (index < playlistNames.length) {
                    currentplaylist = null;
                  } else {
                    int plid = index - playlistNames.length;
                    if (plid < snapshot.data!.length) {
                      currentplaylist = snapshot.data![plid];
                    } else {
                      currentplaylist = null;
                    }
                  }
                  return buildcontainer(allPlaylist[index],
                      index < playlistNames.length, index, currentplaylist);
                },
              );
            }
          },
        ),
      ),
    ]));
  }

  buildcontainer(
      String title, bool isintialplaylist, int index, Listmodel? playlist) {
    bool showmoreoption = true;
    if (title == "Favorite songs" || title == "Recently played") {
      showmoreoption = false;
    }
    return InkWell(
      onTap: () {
        if (title == "Favorite songs") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LikedScreen(backbutton: true),
          ));
        } else if (title == "Recently played") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecentlyPlayed(),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Openplaylist(
                    listmodel: playlist!,
                    playlistnames: title,
                  )));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2667,
        height: MediaQuery.of(context).size.width * 0.2667,
        decoration: BoxDecoration(
          gradient: bgTheme(),
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
        ),
        child: Column(
          mainAxisAlignment:
              (title == "Favorite songs" || title == "Recently played")
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
          children: [
            if (showmoreoption)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    ShowBottomSheetPlayListSettting(
                        context, index, title, playlist);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: color1white,
                    size: 28 * MediaQuery.of(context).size.width / 375.0,
                  ),
                ),
              ),
            Icon(
              Icons.music_note,
              color: color1white,
              size: 48 * MediaQuery.of(context).size.width / 375.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
            Text(
              title,
              style: GoogleFonts.aboreto(
                color: color1white,
                fontSize: 14 * MediaQuery.of(context).size.width / 375.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController textFieldController = TextEditingController();
  playlistnames(
      {required BuildContext context, String? name, Listmodel? playlists}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPlayListNames = name ?? "";
        textFieldController.text = newPlayListNames;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.0267),
          ),
          backgroundColor: Colors.transparent,
          content: Container(
            height: MediaQuery.of(context).size.height * 0.24,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                gradient: bgTheme(),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.0267),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4.0,
                      offset: Offset(-2, -2),
                      color: Colors.white10),
                  BoxShadow(
                      blurRadius: 6.0,
                      offset: Offset(7, 7),
                      color: Colors.black),
                ]),
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0267),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  mytext(
                      "ADD NEW PLAYLIST",
                      16 * MediaQuery.of(context).size.width / 375.0,
                      color1white),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: textFieldController,
                    onChanged: (value) {
                      if (value.length <= 13) {
                        newPlayListNames = value;
                      } else {
                        textFieldController.text = value.substring(0, 15);
                      }
                    },
                    style: GoogleFonts.aboreto(color: Colors.white70),
                    decoration: InputDecoration(
                      hintText: 'Enter playlist name',
                      hintStyle: GoogleFonts.aboreto(
                        color: colorwhite2,
                        fontSize:
                            13 * MediaQuery.of(context).size.width / 375.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.0213),
                        borderSide: BorderSide(color: colorwhite2),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: mytext(
                            "CANCEL",
                            14 * MediaQuery.of(context).size.width / 375.0,
                            color3blueaccent),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0267),
                      TextButton(
                        onPressed: () async {
                          // Add the new playlist name to the list
                          if (name != null) {
                            renameplaylist(
                                playlist: playlists!,
                                newname: newPlayListNames);
                          } else {
                            await addtoplaylist(
                                name: newPlayListNames, songid: []);
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          textFieldController.clear();
                          setState(() {});
                        },
                        child: mytext(
                            name == null ? 'save' : 'Update',
                            14 * MediaQuery.of(context).size.width / 375.0,
                            color3blueaccent),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0207),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  ShowBottomSheetPlayListSettting(BuildContext context, int? index,
      String? name, Listmodel? playlists) async {
    showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
            decoration: BoxDecoration(
                gradient: bgTheme(),
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.width * 0.1067)),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 5.0,
                      offset: Offset(-3, -3),
                      color: Colors.white10),
                  BoxShadow(
                      blurRadius: 6.0,
                      offset: Offset(8, 8),
                      color: Colors.black),
                ]),
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0533),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      List<MusicSong> result =
                          await playlistSongs(playslist: playlists!);

                      if (result.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text(
                            'No songs in the playlist',
                            style: GoogleFonts.aboreto(
                              // ignore: use_build_context_synchronously
                              color: color1white,
                              fontSize: 14 *
                                  // ignore: use_build_context_synchronously
                                  MediaQuery.of(context).size.width /
                                  375.0,
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(255, 2, 5, 50),
                        );

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPlayScreen(
                              songModel: result,
                              audioplayer: audioplayer,
                              index: 0,
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.032),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.032),
                            color: color1white,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        mytext(
                          'Play All',
                          18 * MediaQuery.of(context).size.width / 375.0,
                          color1white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);

                      await playlistnames(
                          context: context, name: name, playlists: playlists);
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.032),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.032),
                            color: color1white,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        mytext(
                          'Rename',
                          18 * MediaQuery.of(context).size.width / 375.0,
                          color1white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      bool confirmDelete =
                          await showDeleteConfirmationDialog(context);
                      if (confirmDelete) {
                        await deletePlayList(index! - 2);
                        // ignore: use_build_context_synchronously

                        setState(() {});
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.032),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.032),
                            color: color1white,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        mytext(
                          'Delete',
                          18 * MediaQuery.of(context).size.width / 375.0,
                          color1white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.0267),
            ),
            backgroundColor: Colors.transparent,
            content: Container(
              // height: MediaQuery.of(context).size.height * 0.200,
              // width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  gradient: bgTheme(),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.0267),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(-2, -2),
                        color: Colors.white10),
                    BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(7, 7),
                        color: Colors.black),
                  ]),
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0427),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    mytext(
                        'Confirm Delete',
                        18 * MediaQuery.of(context).size.width / 375.0,
                        color1white),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    mytext(
                        "Are You Sure TO Delete?",
                        13 * MediaQuery.of(context).size.width / 375.0,
                        color1white),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: mytext(
                              'Cancel',
                              14 * MediaQuery.of(context).size.width / 375.0,
                              color3blueaccent),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.0533),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: mytext(
                              'Delete',
                              14 * MediaQuery.of(context).size.width / 375.0,
                              color3blueaccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
