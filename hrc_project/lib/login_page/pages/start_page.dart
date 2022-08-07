import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../auth/auth_page.dart';
import 'package:video_player/video_player.dart';

class StartPageWidget extends StatefulWidget {
  const StartPageWidget({Key? key}) : super(key: key);

  @override
  State<StartPageWidget> createState() => _StartPageWidgetState();
}

class _StartPageWidgetState extends State<StartPageWidget> {
  final asset = 'assets/video/backgroundvideo.mp4';
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.asset(asset)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => controller.play());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: Stack(
        children: [
          //  Background video
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Opacity(
                opacity: 0.35,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: controller.value.isInitialized
                      ? VideoPlayer(controller)
                      : null,
                ),
              ),
            ),
          ),

          // //  Background image
          // Center(
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage('image/Backgroundimage.png'),
          //         fit: BoxFit.fitHeight,
          //         opacity: 175,
          //       ),
          //     ),
          //   ),
          // ),

          //  HRC Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SvgPicture.asset(
                  'image/Logo.svg',
                  height: 108,
                ),
              ),
            ],
          ),

          //  Start button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                DefaultTextStyle(
                                  style: TextStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      '로그인 정보를 확인중입니다...',
                                      style: TextStyle(
                                        color: Color.fromRGBO(159, 101, 230, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                          },
                        );

                        // pop the loading circle
                        Future.delayed(const Duration(milliseconds: 900), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });

                        Future.delayed(const Duration(milliseconds: 1100), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AuthPage();
                              },
                            ),
                          );
                        });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width * 0.6),
                        height: 45,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 0.1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                                Color.fromRGBO(129, 97, 208, 0.75),
                                Color.fromRGBO(186, 104, 186, 1)
                              ]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'START',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'JostStart',
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
