import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

mytext(String text, double size, Color color) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: GoogleFonts.aboreto().fontFamily,
        color: color,
        fontSize: size,
        overflow: TextOverflow.ellipsis),
  );
}

bgTheme() {
  return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(7, 1, 63, 1),
        Color.fromRGBO(0, 0, 12, 1),
      ]);
}

Color color1white = Colors.white70;
Color color2red = Colors.red;
Color colorwhite2 = Colors.white54;
Color color3blueaccent = Colors.blueAccent;
Color color4blue2 = Colors.blueAccent.shade200;
mytexttermspolicy(String text, double size, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: GoogleFonts.aboreto().fontFamily,
      color: color,
      fontSize: size,
    ),
  );
}

mediaQueryheight(double value, context) {
  return MediaQuery.of(context).size.height * value;
}
 mediaQuerywidth(double value, context) {
  return MediaQuery.of(context).size.width * value;
}