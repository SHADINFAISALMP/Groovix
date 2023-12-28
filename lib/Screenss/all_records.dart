// import 'package:flutter/material.dart';
// import 'package:groovix/Screenss/home_screen.dart';
// import 'package:groovix/reuseable_widgets.dart';

// class AllRecord extends StatefulWidget {
//   const AllRecord({Key? key}) : super(key: key);

//   @override
//   State<AllRecord> createState() => _AllRecordState();
// }

// class _AllRecordState extends State<AllRecord> {
//   List<String> recordings = [];

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
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       icon:  Icon(
//                         Icons.arrow_back,
//                         color: color1white,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     mytext(
//                       'ALL RECORDINGS',
                    
//                        20,  color1white,
                      
//                     ),
//                     const SizedBox(width: 110),
//                   ],
//                 ),
//                 const SizedBox(height: 300),
//                 if (recordings.isEmpty)
//                    Center(
//                     child: mytext(
//                       'No recordings available',18,colorwhite2
                   
//                     ),
//                   )
//                 else
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: recordings.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(recordings[index]),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
