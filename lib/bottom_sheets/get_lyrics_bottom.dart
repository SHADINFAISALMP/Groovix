import 'package:flutter/material.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchLyrics(String artistName, String songName) async {
  const apiKey = "bd81b509bdf1578f40e90ded45c7f326";
  // Step 1: Search for the track
  try {
    final response = await http.get(
      Uri.parse(
          'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?q_track=$songName&q_artist=$artistName&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if there are any tracks
      if (data['message']['body']['lyrics'] != null) {
        String lyrics = data['message']['body']['lyrics']['lyrics_body'];
        lyrics = lyrics.replaceAll(
            '******* This Lyrics is NOT for Commercial use *******', '');
        lyrics = lyrics.replaceAll('(1409624076802)', '');
        return lyrics;
      } else {
        return "Lyrics not found";
      }
    } else {
      throw Exception('Failed to search for the track');
    }
  } catch (e) {
    return null;
  }
}

// ignore: non_constant_identifier_names
getLyricsBottomSheet(context, String title, String Artist) async {
  final lyrics = await fetchLyrics(Artist, title);
  if (lyrics != null) {
    Navigator.of(context).pop();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  gradient: bgTheme(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        MediaQuery.of(context).size.width * 0.10),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width * 0.10),
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
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(
                    'Lyrics',
                    style: GoogleFonts.aboreto(
                      color: color1white,
                      fontSize: MediaQuery.of(context).size.width * 0.055,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: color1white,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3375,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          lyrics,
                          style: TextStyle(
                            color: color1white,
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ])));
      },
    );
  } else {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: mytext('No Lyrics Available', 16, color1white),
      backgroundColor: const Color.fromARGB(255, 2, 5, 50),
    ));
  }
}
