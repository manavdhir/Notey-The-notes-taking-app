// import 'package:flutter/material.dart';
// import 'package:notey_the_notes_application/screens/HomePage.dart';
// import 'package:notey_the_notes_application/screens/addNotesScreen.dart';
// import 'package:notey_the_notes_application/screens/trashedNotesScreen.dart';

// class Bar extends StatefulWidget {
//   @override
//   _BarState createState() => _BarState();
// }

// class _BarState extends State<Bar> {
//   int index = 0;
//   List<Widget> list = [HomePage(), TrashedNotesScreen()];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: list[index],
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0Xff242B2E),
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => AddNotesScreen()));
//         },
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         elevation: 10,
//         shape: CircularNotchedRectangle(),
//         clipBehavior: Clip.antiAlias,
//         notchMargin: 8,
//         child: BottomNavigationBar(
//             backgroundColor: Color(0Xff242B2E),
//             currentIndex: index,
//             onTap: (val) {
//               setState(() {
//                 index = val;
//               });
//             },
//             items: [
//               BottomNavigationBarItem(
//                   title: Text(
//                     "Notes",
//                     style: TextStyle(
//                       color: index == 0 ? Colors.white : Colors.grey,
//                     ),
//                   ),
//                   icon: Icon(
//                     Icons.note,
//                     size: 35,
//                     color: index == 0 ? Colors.white : Colors.grey,
//                   )),
//               BottomNavigationBarItem(
//                   title: Text(
//                     "Trashed Notes",
//                     style: TextStyle(
//                         color: index == 1 ? Colors.white : Colors.grey),
//                   ),
//                   icon: Icon(
//                     Icons.delete,
//                     size: 35,
//                     color: index == 1 ? Colors.white : Colors.grey,
//                   )),
//             ]),
//       ),
//     );
//   }
// }
