import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget buildImage(String imageUrl, int index) {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromRGBO(248, 103, 248, 0.95),
          Color.fromRGBO(61, 90, 230, 1)
        ],
      ),
    ),
    child: CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey[200],
      foregroundImage: imageUrl != '' ? AssetImage(imageUrl) : null,
      child: imageUrl == ''
          ? const Icon(
              Icons.account_circle,
              size: 75,
              color: Colors.grey,
            )
          : null,
    ),
  );
  // return Container(
  //   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 100),
  //   decoration: BoxDecoration(
  //     shape: BoxShape.circle,
  //     color: Colors.grey,
  //     image: DecorationImage(
  //       image: AssetImage(imageUrl),
  //       fit: BoxFit.fitHeight,
  //     ),
  //   ),
  // );
}

Widget buildIndicatior(int imageCount, int selectedIndex) {
  return AnimatedSmoothIndicator(
    activeIndex: selectedIndex,
    count: imageCount,
  );
}
