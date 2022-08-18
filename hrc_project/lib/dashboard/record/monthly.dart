import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog.dart';

DateTime currnetTime = DateTime.now();

String monthlyFormat(DateTime t) {
  var text = DateFormat('yyyy MMMM');
  return text.format(t);
}

class Monthly extends StatefulWidget {
  Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  DateTime? _selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxdeco,
      height: MediaQuery.of(context).size.height * 0.64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: prefer_const_constructors
                Text(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  'Monthly Running ',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_selected == null)
                      Text(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          monthlyFormat(DateTime.now()))
                    else
                      Text(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        monthlyFormat(_selected!),
                      ),
                    // month selector icon button
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1),
                            initialDate: _selected ?? DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _selected = date;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//   Future _onPressed({
//     required BuildContext context,
//     String? locale,
//   }) async {
//     final localeObj = locale != null ? Locale(locale) : null;
//     DateTime? selectedMonth = await showMonthYearPicker(
//         context: context,
//         locale: localeObj,
//         initialDate: _selected ?? DateTime.now(),
//         firstDate: DateTime(2022),
//         lastDate: DateTime(2030));
//     if (selectedMonth != null) {
//       setState(() {
//         _selected = selectedMonth;
//       });
//     }
//   }
}
