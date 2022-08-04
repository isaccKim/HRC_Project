import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GetWeeklyData extends StatelessWidget {
  final String docsId;
  const GetWeeklyData({Key? key, required this.docsId}) : super(key: key);

  String formatTimeStamp(Timestamp timestamp) {
    var text = DateFormat('MM/dd');
    return text.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference data =
        FirebaseFirestore.instance.collection('test_data');
    return FutureBuilder<DocumentSnapshot>(
        future: data.doc(docsId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> runData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Container(
              decoration: boxdeco,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text('Date : ${formatTimeStamp(runData['date'])}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Distance(context),
                            grad.GradientText(
                              '${runData['distance']} km',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: textGradient,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Running_duration(context),
                            grad.GradientText(
                              '${runData['time']} h',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: textGradient,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Running_pace(context),
                            grad.GradientText(
                              '${runData['pace']} m/s',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: textGradient,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}

class WeekSelectionInPicker extends StatefulWidget {
  @override
  _WeekSelectionInPickerState createState() => _WeekSelectionInPickerState();
}

class _WeekSelectionInPickerState extends State<WeekSelectionInPicker> {
  final DateRangePickerController _controller = DateRangePickerController();
  late DateTime date1;
  late DateTime date2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.fromLTRB(50, 150, 50, 100),
            child: SfDateRangePicker(
              controller: _controller,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: selectionChanged,
              monthViewSettings:
                  DateRangePickerMonthViewSettings(enableSwipeSelection: false),
            ),
          ),
          Text(date1.toString()),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    int firstDayOfWeek = DateTime.sunday % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek < 0 ? 7 + endDayOfWeek : endDayOfWeek;
    PickerDateRange ranges = args.value;
    setState(() {
      date1 = ranges.startDate!;
      date2 = (ranges.endDate ?? ranges.startDate)!;
    });

    if (date1.isAfter(date2)) {
      var date = date1;
      date1 = date2;
      date2 = date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    DateTime dat1 = date1.add(Duration(days: (firstDayOfWeek - day1)));
    DateTime dat2 = date2.add(Duration(days: (endDayOfWeek - day2)));

    if (!isSameDate(dat1, ranges.startDate) ||
        !isSameDate(dat2, ranges.endDate)) {
      _controller.selectedRange = PickerDateRange(dat1, dat2);
    }
  }

  bool isSameDate(DateTime? date1, DateTime? date2) {
    if (date2 == date1) {
      return true;
    }
    if (date1 == null || date2 == null) {
      return false;
    }
    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day;
  }
}
