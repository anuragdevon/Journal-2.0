import 'package:flutter/material.dart';
import 'chart.dart';

class Profile extends StatelessWidget {
  static String id = "/profile";
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/profile.jpeg',
        ),
        radius: 64,
      ),
    );

    final details = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Annmarie\nMcQueen",
          style: Theme.of(context).textTheme.overline!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          "annmariemcqueen@email.com",
          style: Theme.of(context).textTheme.overline!.copyWith(
                fontSize: 12,
              ),
        ),
      ],
    );

    final points = Container(
      height: 150.0,
      width: 400.0,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Text(
              "100",
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 80),
            ),
          ),
          Positioned(
            top: -12,
            left: 10,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.redAccent[100],
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(
                "Points",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
              ),
            ),
          )
        ],
      ),
    );

    final graph = LineChartSample2();

    return Scaffold(
      appBar: AppBar(
        title: Text("A few handy buttons here"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              logo,
              details,
              SizedBox(height: 24),
              points,
              SizedBox(height: 24),
              graph,
            ],
          ),
        ),
      ),
    );
  }
}
