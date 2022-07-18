import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'counter.dart';

final username = 'SeowonKim';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

DateTime now = DateTime.now();
final DateTime currentTime = new DateTime(now.year, now.month, now.day);

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.102320253663166, 129.38963644709864),
    zoom: 14.4746,
  );

  static final CameraPosition hgu_univ = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(36.102320253663166, 129.38963644709864),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Positioned(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                    height: 100,
                  ),
                  Image.asset(
                    'image/profile_1.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 20,
                    height: 60,
                  ),
                  Container(
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '#$currentTime',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x50C9EF).withOpacity(0.7),
                        const Color(0X53DFA9).withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.width / 2,
                  width: 200,
                  margin: EdgeInsets.all(35.0),
                  child: Positioned(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Image.asset(
                                'image/run.png',
                                width: 60,
                                height: 200,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Column(
                  children: [
                    Positioned(
                      child: InkWell(
                        child: Image.asset('image/run_btn.png',
                            width: 100, height: 100),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return counter();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      child: InkWell(
                        child: Image.asset('image/start_btn.png',
                            width: 60, height: 60),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return counter();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToHGU,
        label: Text('HGU'),
        icon: Icon(Icons.location_city),
      ),
    );
  }

  Future<void> _goToHGU() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(hgu_univ));
  }
}
