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

String convertDist(String distance) {
  // int km, m;
  // String convertedTime;
  // km = double.parse(distance) ~/ 1;
  // m = ((double.parse(distance) - km) * 1000).round();
  // convertedTime = '$km.$m';

  // return convertedTime;

  if (double.parse(distance) >= 1) {
    return distance;
  } else {
    return '${(double.parse(distance) * 1000).round()}';
  }
}
