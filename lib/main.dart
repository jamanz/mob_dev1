import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

void main() {
  CoordinateKK cod = CoordinateKK.def();
  CoordinateKK cod1 = CoordinateKK(Dir.latitudeN, 5, 5, 5);
  CoordinateKK cod2 = CoordinateKK(Dir.latitudeN, 10, 9, 45);
  print(CoordinateKK.getBetween(cod1, cod2).getInFormat1());
  print(cod1.getInFormat1());
}

class CoordinateKK {
  // default contructor

  CoordinateKK.def() {
    this.direction = DEFAULT_DIRECTION;
    this.degrees = DEFAULT_DEGREES;
    this.minutes = DEFAULT_MINUTES;
    this.seconds = DEFAULT_SECONDS;
  }

  Dir direction;
  int degrees;
  int minutes;
  int seconds;

  final int MIN_LATITUDE_VALUE = -90;
  final int MAX_LATITUDE_VALUE = 90;

  final int MIN_LONGITUDE_VALUE = -180;
  final int MAX_LONGITUDE_VALUE = 180;

  final int MIN_MINUTES_VALUE = 0;
  final int MAX_MINUTES_VALUE = 59;

  final int MIN_SECONDS_VALUE = 0;
  final int MAX_SECONDS_VALUE = 59;

  static final Dir DEFAULT_DIRECTION = Dir.latitudeN;
  static final int DEFAULT_DEGREES = 0;
  static final int DEFAULT_MINUTES = 0;
  static final int DEFAULT_SECONDS = 0;

  CoordinateKK(Dir direction, int degrees, int minutes, int seconds) {
    this.direction = direction;
    this.degrees = direction.isLatitude()
        ? getValid(
            degrees, MIN_LATITUDE_VALUE, MAX_LATITUDE_VALUE, DEFAULT_DEGREES)
        : getValid(
            degrees, MIN_LONGITUDE_VALUE, MAX_LONGITUDE_VALUE, DEFAULT_DEGREES);

    this.minutes = getValid(
        minutes, MIN_MINUTES_VALUE, MAX_MINUTES_VALUE, DEFAULT_MINUTES);

    this.seconds = getValid(
        seconds, MIN_SECONDS_VALUE, MAX_SECONDS_VALUE, DEFAULT_SECONDS);
  }

  getInFormat1() {
    return "$degrees°$minutes′$seconds″  ${direction.name}";
  }

  getInFormat2() {
    return "${getDecimal()}°, ${direction.name}";
  }

  double getDecimal() {
    return degrees + minutes.toDouble() / 60 + seconds.toDouble() / 3600;
  }

  int getValid(int value, int min, int max, int defValue) {
    return value >= min && value <= max ? value : defValue;
  }

  static CoordinateKK getBetween(CoordinateKK a, CoordinateKK b) {
    if (a.direction.isLatitude() != b.direction.isLatitude() ||
        !(a.direction.name == b.direction.name)) return null;

    double mid = (a.getDecimal() + b.getDecimal()) / 2;

    int newDegrees = mid.toInt();
    mid = (mid - mid.toInt()) * 60;
    int newMinutes = mid.toInt();
    mid = (mid - mid.toInt()) * 60;
    int newSeconds = mid.toInt();

    return CoordinateKK(a.direction, newDegrees, newMinutes, newSeconds);
  }
}

enum Dir { longitudeW, longitudeE, latitudeN, latitudeS }

extension DirExt on Dir {
  String get name {
    switch (this) {
      case Dir.longitudeW:
        return 'W';
      case Dir.longitudeE:
        return 'E';
      case Dir.latitudeN:
        return 'N';
      case Dir.latitudeS:
        return 'S';
    }
  }

  bool isLatitude() {
    if (name == 'W' || name == 'E') {
      return false;
    }
    return true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Labka1'),
        ),
        body: Center(
          child: Text('Idle'),
        ),
      ),
    );
  }
}
