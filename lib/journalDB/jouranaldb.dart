import 'package:firebase_database/firebase_database.dart';
// import '../authorization/profile.dart';

class UserData {
  final String userName;
  final String email;
  double coins = 0;
  final dbRef = FirebaseDatabase.instance.reference();

  void create() =>
      dbRef.child(email).set({'username': userName, 'wallet': coins});

  void fetchCoins(DataSnapshot snapshot) =>
      coins = snapshot.value.child('wallet');

  void updateCoins() => dbRef.child(email).update({'wallet': coins});
  UserData({required this.userName, required this.email}) {
    dbRef.child(userName).once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print('New user');
        create();
      } else {
        print('Old user');
        fetchCoins(snapshot);
      }
    });
  }
}
