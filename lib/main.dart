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

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(controller.pickerYear.value, i, 1);
      final backgroundColor =
          dateTime.isAtSameMomentAs(controller.selectedMonth.value)
              ? Colors.amberAccent[200]?.withOpacity(0.9)
              : Colors.transparent;
      months.add(
        Obx(() => AnimatedSwitcher(
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
                              .isAtSameMomentAs(controller.selectedMonth.value)
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            )),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() =>
            Text(DateFormat.yMMMM().format(controller.selectedMonth.value))),
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
                      DateFormat('MMM').format(controller.selectedMonth.value),
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
                  DateFormat.yMMMM().format(controller.selectedMonth.value),
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
                      height: controller.pickerOpen.value ? null : 0.0,
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
                  height: controller.pickerOpen.value ? 155 : 0.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => controller.changeYear(-1),
                            icon: Icon(Icons.navigate_before_rounded,
                                color: Colors.grey[600]),
                          ),
                          Expanded(
                            child: Center(
                              child: Obx(
                                () => Text(
                                  controller.pickerYear.toString(),
                                  // style: TextStyle(fontWeight: FontWeight.bold),
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
                      ),
                      ...generateMonths(),
                      const SizedBox(
                        height: 10.0,
                      ),
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
