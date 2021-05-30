import 'package:flutter/material.dart';
// import 'auth.dart';
// import 'package:cupertino_icons/cupertino_icons.dart';

class Login extends StatelessWidget {
  static const id = '/login';
  final String? loginError;
  final loginAction;
  const Login(this.loginAction, this.loginError);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Positively",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                //onTap: () => loginAction(),
                width: 120,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white10),
                child: Center(
                    child: TextButton(
                  onPressed: () {
                    print('before login');
                    loginAction();
                    print('after login');
                  },
                  child:
                      Text("Login", style: TextStyle(color: Colors.grey[100])),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// loginAction();
