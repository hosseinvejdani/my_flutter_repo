import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import './controller.dart';

// this is english version of animated month picker with getx

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: AnimatedMonthPicker(),
    );
  }
}

class AnimatedMonthPicker extends StatelessWidget {
  AnimatedMonthPicker({Key? key}) : super(key: key);

  final controller = Get.put(MonthPickerController());

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() =>
            Text(DateFormat.yMMMM().format(controller.selectedDateTime.value))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => controller.switchPicker(),
              child: Row(
                children: [
                  RotationTransition(
                    turns: controller.rotationController(),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  Obx(
                    () => Text(
                      DateFormat('MMM')
                          .format(controller.selectedDateTime.value),
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Obx(
                () => Text(
                  DateFormat.yMMMM().format(controller.selectedDateTime.value),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.switchPicker(),
            child: Material(
              color: Colors.black.withOpacity(0.7),
              child: AnimatedSize(
                curve: Curves.easeInOut,
                // vsync: this,
                duration: const Duration(milliseconds: 10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Obx(
                    () => Container(
                      height: controller.isPickerOpen.value ? null : 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Theme.of(context).cardColor,
            child: AnimatedSize(
              curve: Curves.easeInOut,
              // vsync: this,
              duration: const Duration(milliseconds: 300),
              child: Obx(
                () => SizedBox(
                  height: controller.isPickerOpen.value ? 0.35 * h : 0.0,
                  child: Column(
                    children: [
                      YearPickerRow(),
                      MonthPickerGrid(),
                      ButtonGroup(),
                    ],
                  ),
                ),
              ),
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
    final h = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 0.185 * h,
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
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
