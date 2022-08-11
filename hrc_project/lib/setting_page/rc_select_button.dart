import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dialog_page/rc_select_dialog.dart';

final rcNames = [
  '열송학사 RC',
  '손양원 RC',
  '토레이 RC',
  '소속 없음',
  '장기려 RC',
  '카마이클 RC',
  '카이퍼 RC'
];

final images = [
  'image/ranking_board/rc images/Ro.png',
  'image/ranking_board/rc images/Be.png',
  'image/ranking_board/rc images/Vi.png',
  'image/ranking_board/rc images/independent.png',
  'image/ranking_board/rc images/Ja.png',
  'image/ranking_board/rc images/Ca.png',
  'image/ranking_board/rc images/Ky.png'
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
      HapticFeedback.heavyImpact();
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
        height: 130,
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
          image: DecorationImage(
            image: AssetImage(images[selectedIndex]),
            opacity: selectedIndex != 3 ? 0.2 : 0,
            fit: BoxFit.cover,
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
                fontSize: 25,
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
  //  열송학사
  if (index == 0) {
    return [
      const Color.fromRGBO(41, 92, 0, 1),
      const Color.fromRGBO(47, 141, 0, 1),
      const Color.fromRGBO(110, 166, 3, 1),
      const Color.fromRGBO(180, 205, 94, 1),
    ];
  }
  //  손양원
  else if (index == 1) {
    return [
      const Color.fromRGBO(90, 0, 26, 1),
      const Color.fromRGBO(179, 28, 67, 1),
      const Color.fromRGBO(201, 90, 63, 1),
      const Color.fromRGBO(241, 214, 94, 1),
    ];
  }
  //  비전
  else if (index == 2) {
    return [
      const Color.fromRGBO(160, 110, 0, 1),
      const Color.fromRGBO(200, 131, 0, 1),
      const Color.fromRGBO(255, 232, 82, 1),
      const Color.fromRGBO(255, 234, 238, 1),
    ];
  }
  //  무소속
  else if (index == 3) {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(99, 97, 210, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  }
  //  장기려
  else if (index == 4) {
    return [
      const Color.fromRGBO(123, 31, 31, 1),
      const Color.fromRGBO(207, 48, 27, 1),
      const Color.fromRGBO(236, 89, 39, 1),
      const Color.fromRGBO(252, 228, 131, 1),
    ];
  }
  //  카마이클
  else if (index == 5) {
    return [
      const Color.fromRGBO(155, 68, 17, 1),
      const Color.fromRGBO(196, 126, 78, 1),
      const Color.fromRGBO(239, 207, 113, 1),
      const Color.fromRGBO(255, 255, 178, 1),
    ];
  }
  //  카이퍼
  else if (index == 6) {
    return [
      const Color.fromRGBO(0, 63, 102, 1),
      const Color.fromRGBO(3, 108, 166, 1),
      const Color.fromRGBO(4, 183, 201, 1),
      const Color.fromRGBO(128, 233, 238, 1),
    ];
  }
  //  선택 안됨
  else {
    return [
      const Color.fromRGBO(129, 97, 208, 0.45),
      const Color.fromRGBO(129, 97, 208, 0.75),
    ];
  }
}
