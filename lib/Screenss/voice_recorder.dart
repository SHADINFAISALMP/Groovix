// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:groovix/Screenss/home_screen.dart';
// import 'package:groovix/reuseable_widgets.dart';

// class VoiceRecord extends StatefulWidget {
//   const VoiceRecord({Key? key}) : super(key: key);

//   @override
//   State<VoiceRecord> createState() => _VoiceRecordState();
// }

// class _VoiceRecordState extends State<VoiceRecord> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           gradient: bgTheme(),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: ((context) => const HomeScreen())));
//                         },
//                         icon: Icon(
//                           Icons.arrow_back,
//                           color: color1white,
//                         )),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     mytext("VOICE RECORD", 20, color1white),
//                     const SizedBox(
//                       width: 110,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 250,
//                 ),
//                 SizedBox(
//                     height: 100, child: mytext('00:00:00', 50, color1white)),
//                 const SizedBox(height: 220),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.cancel,
//                         color: colorwhite2,
//                         size: 40,
//                       ),
//                       onPressed: () {},
//                     ),
//                     const SizedBox(
//                       width: 19,
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.mic,
//                         color: colorwhite2,
//                         size: 40,
//                       ),
//                       onPressed: () {},
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.check,
//                         color: colorwhite2,
//                         size: 40,
//                       ),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             TextEditingController textFieldController =
//                                 TextEditingController();

//                             return AlertDialog(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               backgroundColor: Colors.transparent,
//                               content: Container(
//                                 height: 200,
//                                 width: 300,
//                                 decoration: BoxDecoration(
//                                   gradient: bgTheme(),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       mytext("SAVE RECORD", 18, color1white),
//                                       const SizedBox(height: 16),
//                                       TextField(
//                                         controller: textFieldController,
//                                         style: GoogleFonts.aboreto(
//                                             color: color1white),
//                                         decoration: InputDecoration(
//                                           hintText: 'RECORD TITLE',
//                                           hintStyle: GoogleFonts.aboreto(
//                                               color: colorwhite2, fontSize: 15),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                             borderSide:
//                                                 BorderSide(color: color1white),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: mytext(
//                                                 "Cancel", 16, color3blueaccent),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               // String playlistName =
//                                               //     textFieldController.text;
//                                             },
//                                             child: mytext(
//                                                 "save", 16, color3blueaccent),
//                                           ),
//                                           const SizedBox(width: 8),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     mytext("CANCEL", 16, colorwhite2),
//                     const SizedBox(
//                       width: 130,
//                     ),
//                     mytext("SAVE", 16, colorwhite2),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
