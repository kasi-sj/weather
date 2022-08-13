import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class handle {
  var longitude;
  var lattitude;
  var data;

  Future getlocation() async {
    Position location = await determinePosition();
    longitude = location.longitude;
    lattitude = location.latitude;
  }

  Future weatherbyname(String name) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$name&appid=4369b33e3c184ac1c8370d246c8d2cc1&units=metric'));

    if (response.statusCode != 404) {
      data = response.body;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(data);
    return data;
  }

  Future weather() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lattitude&lon=$longitude&appid=4369b33e3c184ac1c8370d246c8d2cc1&units=metric'));
    if (response.statusCode == 200) {
      data = response.body;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return data;
  }
}
// https://api.openweathermap.org/data/2.5/weather?q=London,uk&callback=test&appid=4369b33e3c184ac1c8370d246c8d2cc1
