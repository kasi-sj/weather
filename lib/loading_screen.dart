import 'package:flutter/material.dart';
import 'locator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_9/location_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var latt = '';
  var long = '';

  Future position() async {
    handle location = handle();
    await location.getlocation();
    var data = await location.weather();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(data: data);
        },
      ),
    );
  }

  @override
  void initState() {
    position();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: SpinKitRotatingCircle(
        color: Colors.white,
        size: 50.0,
      )),
    );
  }
}
