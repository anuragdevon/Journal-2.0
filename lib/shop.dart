import 'package:flutter/material.dart';

import 'auth/auth.dart';

class Shop extends StatelessWidget {
  static const String id = "/shop";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              currentUser.coins.toString(),
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe1.jpeg"),
              item("shoe2.jpeg"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe3.jpeg"),
              item("shoe4.jpeg"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe1.jpeg"),
              item("shoe2.jpeg"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe3.jpeg"),
              item("shoe4.jpeg"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe1.jpeg"),
              item("shoe2.jpeg"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item("shoe3.jpeg"),
              item("shoe4.jpeg"),
            ],
          ),
        ],
      ),
    );
  }

  Widget item(name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.cyan,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage('assets/images/$name'),
            width: 150,
            // fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "JQuery Shoes",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "15000 ç",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyanAccent,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_bag),
            ),
          )
        ],
      ),
    );
  }
}
