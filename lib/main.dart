// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import './controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AnimatedMonthPicker(),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedMonthPicker extends StatelessWidget {
  AnimatedMonthPicker({Key? key}) : super(key: key);

  final controller = Get.put(MonthPickerController());

  Future<Object?> _monthPickerGeneralDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.7),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // TODO solve this hard coding
            const SizedBox(height: 80),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    YearPickerRow(),
                    MonthPickerGrid(),
                    ButtonGroup(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.switchPicker();
        _monthPickerGeneralDialog(context);
      },
      child: Row(
        children: [
          RotationTransition(
            turns: controller.rotationController(),
            child: const Icon(Icons.arrow_drop_down),
          ),
          Obx(
            () => Text(
              // DateFormat.yMMMM().format(controller.selectedMonth.value)
              DateFormat('yMMM').format(controller.selectedDateTime.value),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class YearPickerRow extends StatelessWidget {
  YearPickerRow({Key? key}) : super(key: key);

  final controller = Get.find<MonthPickerController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => controller.changeYear(-1),
          icon: Icon(Icons.navigate_before_rounded, color: Colors.grey[600]),
        ),
        Expanded(
          child: Center(
            child: Obx(
              () => Text(
                controller.selectedYear.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => controller.changeYear(1),
          icon: Icon(
            Icons.navigate_next_rounded,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class MonthPickerGrid extends StatelessWidget {
  MonthPickerGrid({Key? key}) : super(key: key);

  final controller = Get.find<MonthPickerController>();

  List<Widget> generateMonths() {
    List<Widget> months = [];
    for (int i = 1; i <= 12; i++) {
      months.add(
        Obx(() {
          DateTime dateTime = DateTime(controller.selectedYear.value, i, 1);
          final backgroundColor =
              dateTime.isAtSameMomentAs(controller.selectedDateTime.value)
                  ? Colors.amberAccent[200]?.withOpacity(0.9)
                  : Colors.transparent;
          return AnimatedSwitcher(
            duration: kThemeChangeDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: TextButton(
              key: ValueKey(backgroundColor),
              onPressed: () {
                controller.selectMonth(dateTime);
                controller.switchPicker();
              },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: const CircleBorder(),
              ),
              child: Text(
                DateFormat('MMM').format(dateTime),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: dateTime
                          .isAtSameMomentAs(controller.selectedDateTime.value)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      );
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // TODO sove this hard coding
      height: 140,
      child: GridView.count(
        padding: const EdgeInsets.all(0),
        crossAxisCount: 6,
        children: generateMonths(),
      ),
    );
  }
}

class ButtonGroup extends StatelessWidget {
  ButtonGroup({Key? key}) : super(key: key);

  final controller = Get.find<MonthPickerController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6.0),
          child: TextButton(
            onPressed: () => controller.switchPicker(),
            child: const Text(
              'CANCLE',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(
            height: 6.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6.0),
          child: TextButton(
            onPressed: () => controller.jumpToThisMonth(),
            child: const Text(
              'THIS MONTH',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
