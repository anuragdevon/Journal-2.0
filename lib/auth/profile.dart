import 'package:flutter/material.dart';

class UserData {
  final String? name;
  final String? picture;
  final String? email;

  UserData({this.name, this.picture, this.email});
}

class Profile extends StatelessWidget {
  final logoutAction;
  final String? name;
  final String? picture;
  final String? email;

  Profile(this.logoutAction, this.name, this.picture, this.email);
  @override
  Widget build(BuildContext context) {
    final userInfo = UserData(
      name: '$name',
      //picture: '$picture',
      email: '$email',
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4.0),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Text('Name: $name'),
        Text('Email: $email'),
        SizedBox(height: 48.0),
        TextButton(
          onPressed: () {
            logoutAction();
          },
          child: Text('Logout'),
        ),
        TextButton(
          onPressed: () {
            print(userInfo.name);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => JournalData(userInfo: userInfo)));
          },
          child: Text('Journaldb'),
        ),
      ],
    );
  }
}
