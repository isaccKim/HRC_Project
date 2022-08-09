import 'package:flutter/material.dart';
import '../dialog_page/rc_select_dialog.dart';

final rcNames = [
  '열송학사 RC',
  '손양원 RC',
  '비전 RC',
  '무소속',
  '장기려 RC',
  '카마이클 RC',
  '카이퍼 RC'
];

Widget rcSelectButton(
  BuildContext context,
  bool isEdited,
  int selectedIndex,
  Function func1,
  Function func2,
  Function func3,
) {
  return //  edit RC button
      GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (context) {
          return rcSelectDialogWidget(
            context: context,
            boxHeight: 370,
            topBarHeight: 30,
            topBarText: 'RC 선택하기',
            topBarTextSize: 15,
            mainText: '',
            mainTextSize: 17,
            executableFuc1: func1,
            executableFuc2: func2,
            executableFuc3: func3,
            executableFuc4: () {},
            executableFuc5: () {},
          );
        },
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            isEdited
                ? const BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                : const BoxShadow(),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: !isEdited ? rcColors(7) : rcColors(selectedIndex),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.holiday_village_outlined,
              color: isEdited ? Colors.white : Colors.grey[200],
              size: 45,
            ),
            const SizedBox(width: 15),
            Text(
              isEdited ? rcNames[selectedIndex] : 'Select RC',
              style: TextStyle(
                color: isEdited ? Colors.white : Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

//  RC color
List<Color> rcColors(int index) {
  if (index == 0) {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(147, 99, 201, 1),
      const Color.fromRGBO(129, 97, 208, 1),
    ];
  } else if (index == 1) {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(99, 97, 210, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (index == 2) {
    return [
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(95, 93, 215, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (index == 3) {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(99, 97, 210, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (index == 4) {
    return [
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(95, 93, 215, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (index == 5) {
    return [
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(95, 93, 215, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (index == 6) {
    return [
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(95, 93, 215, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else {
    return [
      const Color.fromRGBO(129, 97, 208, 0.45),
      const Color.fromRGBO(129, 97, 208, 0.75),
    ];
  }
}
