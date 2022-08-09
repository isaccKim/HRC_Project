import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../record/weekly.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:ui' as ui;

String formatTimeStamp(DateTime t) {
  var text = DateFormat('MM/dd');
  return text.format(t);
}

class WeekSelectionInPicker extends StatefulWidget {
  @override
  _WeekSelectionInPickerState createState() => _WeekSelectionInPickerState();
}

class _WeekSelectionInPickerState extends State<WeekSelectionInPicker> {
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.53,
      child: Column(
        children: [
          SfDateRangePicker(
            controller: _controller,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: selectionChanged,
            monthViewSettings:
                DateRangePickerMonthViewSettings(enableSwipeSelection: false),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  '${formatTimeStamp(titleFirstOfWeek)}\nEndOfWeek : ${formatTimeStamp(titleEndOfWeek)}'),
              // Button - select the weeks
              TextButton(
                onPressed: () {
                  setState(() {
                    // result.clear();
                    testWidget(result, context);
                    titleFirstOfWeek = date1;
                    titleEndOfWeek = date2;
                    print('${formatTimeStamp(titleFirstOfWeek)}');
                    Navigator.of(context).pop();
                  });
                },
                child: Text('test'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    int fk = DateTime.sunday % 7;
    int ek = (fk - 1) % 7;
    ek = ek < 0 ? 7 + ek : ek;
    PickerDateRange ranges = args.value;
    setState(() {
      date1 = ranges.startDate!;
      date2 = (ranges.endDate ?? ranges.startDate)!;
    });

    if (date1.isAfter(date2)) {
      setState(() {
        var date = date1;
        date1 = date2;
        date2 = date;
      });
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    DateTime dat1 = date1.add(Duration(days: (fk - day1)));
    DateTime dat2 = date2.add(Duration(days: (ek - day2)));

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

class TestTitle extends StatefulWidget {
  TestTitle({Key? key}) : super(key: key);

  @override
  State<TestTitle> createState() => _TestTitleState();
}

class _TestTitleState extends State<TestTitle> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            Color.fromARGB(0, 213, 107, 237).withOpacity(0)),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: SizedBox(height: 500, child: WeekSelectionInPicker()),
              );
            });
      },
      child: Row(
        children: [
          grad.GradientText(
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            gradient: textGradient,
            '${formatTimeStamp(titleFirstOfWeek)} ~ ${formatTimeStamp(titleEndOfWeek)}',
          ),
          const Icon(Icons.calendar_month_rounded),
        ],
      ),
    );
  }
}
