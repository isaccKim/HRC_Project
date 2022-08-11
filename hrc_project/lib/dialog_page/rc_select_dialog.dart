import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class rcSelectDialogWidget extends StatefulWidget {
  BuildContext context;
  double boxHeight;
  double topBarHeight;
  String topBarText;
  double topBarTextSize;
  String mainText;
  double mainTextSize;
  Function executableFuc1;
  Function executableFuc2;
  Function executableFuc3;
  Function executableFuc4;
  Function executableFuc5;

  rcSelectDialogWidget({
    Key? key,
    required this.context,
    required this.boxHeight,
    required this.topBarHeight,
    required this.topBarText,
    required this.topBarTextSize,
    required this.mainText,
    required this.mainTextSize,
    required this.executableFuc1,
    required this.executableFuc2,
    required this.executableFuc3,
    required this.executableFuc4,
    required this.executableFuc5,
  }) : super(key: key);

  @override
  State<rcSelectDialogWidget> createState() => _rcSelectDialogWidgetState();
}

class _rcSelectDialogWidgetState extends State<rcSelectDialogWidget> {
  int activeIndex = 3;

  final images = [
    'image/ranking_board/rc images/Ro.png',
    'image/ranking_board/rc images/Be.png',
    'image/ranking_board/rc images/Vi.png',
    'image/ranking_board/rc images/independent.png',
    'image/ranking_board/rc images/Ja.png',
    'image/ranking_board/rc images/Ca.png',
    'image/ranking_board/rc images/Ky.png'
  ];

  final rcNames = [
    '열송학사 RC',
    '손양원 RC',
    '토레이 RC',
    '소속 없음',
    '장기려 RC',
    '카마이클 RC',
    '카이퍼 RC'
  ];

  @override
  Dialog build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0),
      child: Container(
          height: widget.boxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  '${widget.topBarText}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: widget.topBarTextSize,
                  ),
                ),
              ),
              Column(
                children: [
                  //  RC image slider
                  CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                        initialPage: 3,
                        height: 180,
                        enlargeCenterPage: true,
                        viewportFraction: 0.55,
                        onPageChanged: (index, reason) {
                          setState(() {
                            HapticFeedback.heavyImpact();
                            activeIndex = index;
                          });
                        }),
                    itemBuilder: (context, index, realIndex) {
                      return buildImage(
                          images[index], index, activeIndex, rcNames[index]);
                    },
                  ),

                  const SizedBox(height: 15),

                  //  Page indicator
                  buildIndicatior(images.length, activeIndex),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 50,
                      color: Colors.white.withOpacity(0),
                      child: ElevatedButton(
                        onPressed: () async {
                          //  pop the alert
                          Navigator.of(context).pop();
                          widget.executableFuc1(activeIndex);
                          widget.executableFuc2();
                          widget.executableFuc3();
                          widget.executableFuc4();
                        },
                        style: ElevatedButton.styleFrom(
                            onPrimary: Colors.blueAccent,
                            elevation: 0,
                            primary: Colors.deepPurpleAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                            )),
                        child: const Text(
                          '변경하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 50,
                      color: Colors.white.withOpacity(0),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.executableFuc5();
                          //  pop the alert
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            onPrimary: Colors.redAccent,
                            elevation: 0,
                            primary: Colors.deepPurpleAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                            )),
                        child: const Text(
                          '취소하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

//  Image slot, RC name
Widget buildImage(String imageUrl, int index, int activIndex, String rcName) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
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
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: index == activIndex ? 1.0 : 0,
          child: Text(
            index == activIndex ? rcName : '',
            style: const TextStyle(
              fontFamily: 'JostSemi',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    ),
  );
}

//  Page indicator
Widget buildIndicatior(int imageCount, int selectedIndex) {
  return AnimatedSmoothIndicator(
    activeIndex: selectedIndex,
    count: imageCount,
    effect: const ScrollingDotsEffect(
      fixedCenter: true,
    ),
  );
}
