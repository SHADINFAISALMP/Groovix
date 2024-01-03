// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/privacy.dart';
import 'package:groovix/Screenss/songs_lists_content.dart';
import 'package:groovix/Screenss/terms_condition.dart';
import 'package:groovix/reuseable_widgets.dart';


import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

showSpeedDialog(BuildContext context, double num) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.transparent,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
          content: StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2725,
              width: MediaQuery.of(context).size.width * 0.900,
              decoration: BoxDecoration(
                gradient: bgTheme(),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(-3, -3),
                    color: Colors.white10,
                  ),
                  BoxShadow(
                    blurRadius: 6.0,
                    offset: Offset(5, 5),
                    color: Colors.black,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      'Adjust Playback Speed',
                      style: GoogleFonts.aboreto(
                          color: color1white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0100,
                  ),
                  Text(
                    'Current Speed: ${speed.toStringAsFixed(1)}x',
                    style:
                        GoogleFonts.aboreto(color: color1white, fontSize: 16),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01875,
                  ),
                  Slider(
                    min: 0.5,
                    max: 2.5,
                    value: speed,
                    onChanged: (value) {
                      setState(() {
                        speed = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      mytext(
                        '0.5x',
                        MediaQuery.of(context).size.width * 0.04,
                        color1white,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.075,
                      ),
                      mytext(
                        '2.5x',
                        MediaQuery.of(context).size.width * 0.04,
                        color1white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01075,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: mytext(
                          'Cancel',
                          MediaQuery.of(context).size.width * 0.04,
                          color3blueaccent,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          audioplayer.setSpeed(speed);
                          Navigator.of(context).pop();
                        },
                        child: mytext(
                            'Apply',
                            MediaQuery.of(context).size.width * 0.04,
                            color3blueaccent),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      );
    },
  );
}

double speed = 1.0;
void showBottomSheetMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      double sheetWidth = MediaQuery.of(context).size.width;

      return Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 0.450,
        decoration: BoxDecoration(
            gradient: bgTheme(),
            borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(MediaQuery.of(context).size.width * 0.08),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.08),
            ),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5.0,
                  offset: Offset(-3, -3),
                  color: Colors.white10),
              BoxShadow(
                  blurRadius: 6.0, offset: Offset(8, 8), color: Colors.black),
            ]),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'SETTINGS',
              style: GoogleFonts.aboreto(
                  color: color1white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.normal),
            ),
            Divider(
              thickness: 1,
              color: color1white,
            ),
            SizedBox(height: sheetWidth * 0.02),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.024),
                    color: color1white,
                  ),
                  child: const Icon(
                    Icons.speed,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showSpeedDialog(context, speed);
                    // Navigator.pop(context);
                  },
                  child: mytext(
                    'Playback Speed',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ),
              ],
            ),
            SizedBox(height: sheetWidth * 0.02),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.024),
                    color: color1white,
                  ),
                  child: const Icon(
                    Icons.privacy_tip,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Privacy()));
                  },
                  child: mytext(
                    'Privacy Policy',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ),
              ],
            ),
            SizedBox(height: sheetWidth * 0.02),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.024),
                    color: color1white,
                  ),
                  child: const Icon(
                    Icons.note_alt,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Termscondition()));
                  },
                  child: mytext(
                    'Terms & Condition',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ),
              ],
            ),
            SizedBox(height: sheetWidth * 0.02),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.024),
                    color: color1white,
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                TextButton(
                  onPressed: () {
                    Share.share(
                        "https://www.amazon.com/dp/B0CR7DFY5H/ref=apps_sf_sta");
                    Navigator.pop(context);
                  },
                  child: mytext(
                    'Share App',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ),
              ],
            ),
            SizedBox(height: sheetWidth * 0.02),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.024),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.024),
                      color: color1white,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showRateUsDialog(context);
                    },
                    child: mytext(
                      'Rate Us',
                      MediaQuery.of(context).size.width * 0.045,
                      color1white,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: mytext(
                'Version 1.0.0',
                MediaQuery.of(context).size.width * 0.04,
                color1white,
              ),
            ),
            SizedBox(height: sheetWidth * 0.01),
          ],
        ),
      );
    },
  );
}

_showRateUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.0267,
          ),
        ),
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            gradient: bgTheme(),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.0267,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4.0,
                offset: Offset(-2, -2),
                color: Colors.white10,
              ),
              BoxShadow(
                blurRadius: 6.0,
                offset: Offset(7, 7),
                color: Colors.black,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              mytext('Rate Us ', 18, color1white),
              Divider(
                thickness: 1,
                color: color1white,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Would you like to rate our app on the Amazon store?',
                  style: GoogleFonts.aboreto(fontSize: 18, color: color1white),
                ),
              ),
              RatingBar.builder(
                allowHalfRating: true,
                unratedColor: color1white,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                ),
                onRatingUpdate: (rating) {
                  if (rating.toInt() < 0) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    launchURL();
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: mytext(
                    'Cancel',
                    14 * MediaQuery.of(context).size.width / 375.0,
                    color3blueaccent),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> launchURL() async {
  // ignore: deprecated_member_use
  if (await launch('https://www.amazon.com/dp/B0CR7DFY5H/ref=apps_sf_sta')) {
    throw "Try Again";
  }
}
