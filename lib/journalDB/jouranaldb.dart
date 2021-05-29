// import 'package:firebase_database/firebase_database.dart';
// import '../authorization/profile.dart';

// class UserData {
//   final String userName;
//   final String email;
//   double coins = 0;
//   final dbRef = FirebaseDatabase.instance.reference();

//   UserData({required this.userName, required this.email}) {
//     dbRef.child(userName).once().then((DataSnapshot snapshot) {
//       if (snapshot.value == null) {
//         print('Adding user');
//             dbRef
//         .child('username')
//         .set({'id': email, 'wallet': coins});
//       } else {
//           // Fetch coins from database
//           //coins = snapshot.value.child('wallet');
//           print('Fetching coins');
//       }
//   }

//   void updateCoins() =>
//       dbRef.child(userName).update({'wallet': coins});

//   void delete() => dbRef.child(userName).remove();
// }
