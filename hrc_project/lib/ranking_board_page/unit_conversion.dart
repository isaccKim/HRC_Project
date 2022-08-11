import 'dart:math';

//  second convert
String convertTime(String time) {
  int hr, min, sec;
  String convertedTime;

  min = double.parse(time) ~/ 60;
  hr = min ~/ 60;
  sec = (double.parse(time) % 60).round();
  min = min % 60;

  convertedTime =
      '${hr.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';

  return convertedTime;
}

//  km convert
String convertDist(String distance) {
  // int km, m;
  // String convertedTime;
  // km = double.parse(distance) ~/ 1;
  // m = ((double.parse(distance) - km) * 1000).round();
  // convertedTime = '$km.$m';

  // return convertedTime;

  String convertedDist;

  convertedDist = '${(double.parse(distance) * 1000).round()}';

  if (double.parse(distance) >= 1) {
    convertedDist = roundDouble(double.parse(distance), 2).toString();
    if (double.parse(convertedDist) == double.parse(convertedDist).round()) {
      convertedDist = double.parse(convertedDist).round().toString();
      return convertedDist;
    } else {
      return convertedDist;
    }
  } else {
    return convertedDist;
  }
}

double roundDouble(double val, int place) {
  num mod = pow(10.0, place);
  return ((val * mod).round().toDouble() / mod);
}
