import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/reuseable_widgets.dart';

List<String> playlistNames = ["Favorites"];

void showbottomsheetaddtoplaylist(
    {required context, List<MusicSong>? sm, int? ind, int? songid}) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext builder) {
      return Container(
        decoration: BoxDecoration(
          gradient: bgTheme(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.08),
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.08),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5.0,
              offset: Offset(-3, -3),
              color: Colors.white10,
            ),
            BoxShadow(
              blurRadius: 6.0,
              offset: Offset(8, 8),
              color: Colors.black,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: scaffoldKey,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                mytext(
                  'Add to Playlist',
                  MediaQuery.of(context).size.width * 0.055,
                  color1white,
                ),
                Divider(
                  thickness: 1,
                  color: color1white,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0370),

                // Create New Playlist Row
                GestureDetector(
                  onTap: () {
                    checkplaylistNames();
                    _showCreatePlaylistDialog(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                          color: color1white,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0400),
                      mytext(
                        'Create New Playlist',
                        MediaQuery.of(context).size.width * 0.05,
                        color1white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.020),

                Expanded(
                  child: FutureBuilder(
                      future: getfromplaylist(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<String> allPlaylists = List.from(playlistNames);
                          if (snapshot.data != null) {
                            allPlaylists.addAll(snapshot.data!
                                .map((playlist) => playlist.name));
                          }
                          return ListView.builder(
                            itemCount: allPlaylists.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (allPlaylists[index] == "Favorites") {
                                      } else {
                                        await addSongsToPlaylist(
                                            songid: songid!,
                                            playlist:
                                                snapshot.data![index - 1]);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: mytext(
                                                'Song added to ${allPlaylists[index]}',
                                                // ignore: use_build_context_synchronously
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                color1white),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 2, 5, 50),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.024),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.024),
                                            color: color1white,
                                          ),
                                          child: Icon(
                                            getIconForPlaylist(
                                                allPlaylists[index]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                        Text(
                                          allPlaylists[index],
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.aboreto()
                                                .fontFamily,
                                            color: color1white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0125),
                                ],
                              );
                            }),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

IconData getIconForPlaylist(String playlist) {
  if (playlist == "Favorites") {
    return Icons.favorite;
  } else {
    return Icons.library_music;
  }
}

void _showCreatePlaylistDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController textFieldController = TextEditingController();
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.transparent,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.2500,
            width: MediaQuery.of(context).size.width * 0.700,
            decoration: BoxDecoration(
                gradient: bgTheme(),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 4.0,
                      offset: Offset(-3, -3),
                      color: Colors.white10),
                  BoxShadow(
                      blurRadius: 6.0,
                      offset: Offset(5, 5),
                      color: Colors.black),
                ]),
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0375),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  mytext(
                    'Add New Playlist',
                    MediaQuery.of(context).size.width * 0.05,
                    color1white,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  TextField(
                    controller: textFieldController,
                    onChanged: (value) {
                      if (value.length <= 10) {
                      } else {
                        textFieldController.text = value.substring(0, 15);
                      }
                    },
                    style: GoogleFonts.aboreto(color: color1white),
                    decoration: InputDecoration(
                      hintText: 'Enter playlist name',
                      hintStyle: GoogleFonts.aboreto(
                        color: colorwhite2,
                        fontSize: MediaQuery.of(context).size.width * 0.0375,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.02),
                        borderSide: BorderSide(color: colorwhite2),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03125),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: mytext(
                            'cancel',
                            MediaQuery.of(context).size.width * 0.045,
                            color3blueaccent),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0655),
                      TextButton(
                        onPressed: () {
                          addtoplaylist(
                              name: textFieldController.text, songid: []);

                          debugPrint('Updated Playlist Names: $playlistNames');
                          Navigator.pop(context);
                        },
                        child: mytext(
                            'Save',
                            MediaQuery.of(context).size.width * 0.045,
                            color3blueaccent),
                      ),
                     SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
