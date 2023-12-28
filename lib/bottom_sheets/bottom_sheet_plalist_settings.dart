// // ignore_for_file: non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:groovix/db_funtion/functions.dart';
// import 'package:groovix/reuseable_widgets.dart';

// ShowBottomSheetPlayListSetttings(BuildContext context, int? index) async {
//   showBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (builder) {
//         return Container(
//           decoration: BoxDecoration(
//               gradient: bgTheme(),
//               borderRadius: const BorderRadius.all(Radius.circular(40)),
//               boxShadow: const [
//                 BoxShadow(
//                     blurRadius: 5.0,
//                     offset: Offset(-3, -3),
//                     color: Colors.white10),
//                 BoxShadow(
//                     blurRadius: 6.0, offset: Offset(8, 8), color: Colors.black),
//               ]),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Icon(Icons.play_arrow, color: color1white),
//                     const SizedBox(width: 20),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: mytext(
//                         'Play All',
//                         18,
//                         color1white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Row(
//                     children: [
//                       Icon(Icons.edit, color: color1white),
//                       const SizedBox(width: 20),
//                       mytext(
//                         'Rename',
//                         18,
//                         color1white,
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () async {
//                     await deletePlayList(index! - 2);
//                     // ignore: use_build_context_synchronously
//                     Navigator.pop(
//                       context,
//                     );
//                   },
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, color: color1white),
//                       const SizedBox(width: 50),
//                       mytext(
//                         'Delete',
//                         18,
//                         color1white,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }
