import 'package:flutter/material.dart';
import 'package:flutter_application_9/weather.dart';
import 'constants.dart';
import 'dart:convert';
import 'locator.dart';
import 'city_screen.dart';

// ignore: must_be_immutable
class LocationScreen extends StatefulWidget {
  var data;
  double temp = 0;
  int temp1 = 0;
  var id;
  var emoji;
  var city;
  var mess;

  LocationScreen({required this.data});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    gett(widget.data);
  }

  gett(data) {
    // TODO: implement initState
    var temp = WeatherModel();

    setState(() {
      try {
        widget.city = jsonDecode(data)['name'];
        widget.temp = jsonDecode(data)['main']['temp'];
        widget.temp1 = widget.temp.toInt();
        widget.id = jsonDecode(data)['weather'][0]['id'];
        widget.mess = temp.getMessage(widget.temp1);
        widget.emoji = temp.getWeatherIcon(widget.id);
      } catch (e) {
        widget.city = '';
        widget.temp1 = 0;
        widget.mess = 'error';
        widget.emoji = '_';
      }
    });
  }

  Future position() async {
    handle location = handle();
    await location.getlocation();
    var data = await location.weather();
    gett(data);
  }

  Future position1(String name) async {
    handle location = handle();
    var data = await location.weatherbyname(name);
    var temp = WeatherModel();
    gett(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      position();
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var name = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );

                      if (name != null) {
                        position1(name);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${widget.temp1}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '☀️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  " ${widget.mess}${widget.city}!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
