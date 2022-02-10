import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import './controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

// this is english version of animated month picker with getx

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedMonthPicker(),
    );
  }
}

class AnimatedMonthPicker extends StatelessWidget {
  AnimatedMonthPicker({Key? key}) : super(key: key);

  final controller = Get.put(MonthPickerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => controller.switchPicker(),
              child: Row(
                children: [
                  RotationTransition(
                    turns: controller.rotationController(),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[700],
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.formatToYearNumberMonthName(
                          controller.selectedDateTime.value),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'yekan',
                      ),
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
            color: Colors.grey[50],
            child: Center(
              child: Obx(
                () => Text(
                  controller.formatToYearNumberMonthName(
                      controller.selectedDateTime.value),
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.closePicker(),
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
                  height: controller.isPickerOpen.value ? 0.92 * w : 0.0,
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
    final w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            onPressed: () => controller.changeYear(-1),
            icon: Icon(
              Icons.navigate_before_rounded,
              color: Colors.grey[600],
              size: 35,
            ),
          ),
        ),
        SizedBox(
          width: 0.4 * w,
          child: Center(
            child: Obx(
              () => Text(
                controller.selectedYear.toString().toPersianDigit(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  // fontFamily: 'yekan',
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            onPressed: () => controller.changeYear(1),
            icon: Icon(
              Icons.navigate_next_rounded,
              color: Colors.grey[600],
              size: 35,
            ),
          ),
        ),
      ],
    );
  }
}

class MonthPickerGrid extends StatelessWidget {
  MonthPickerGrid({Key? key}) : super(key: key);

  final controller = Get.find<MonthPickerController>();

  List<Widget> jalaliGenerateMonths(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    List<Widget> months = [];
    for (int i = 1; i <= 12; i++) {
      months.add(
        Obx(() {
          // DateTime dateTime = DateTime(controller.selectedYear.value, i, 1);
          Jalali jalaiDateTime = Jalali(controller.selectedYear.value, i, 1);
          final backgroundColor = jalaiDateTime.toDateTime().isAtSameMomentAs(
                  controller.selectedDateTime.value.toDateTime())
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              child: ElevatedButton(
                key: ValueKey(backgroundColor),
                onPressed: () {
                  controller.selectMonth(jalaiDateTime);
                  // controller.switchPicker();
                },
                style: ElevatedButton.styleFrom(
                  primary: backgroundColor,
                  elevation: 0.0,
                  fixedSize: Size(w / 4, w / 20),
                  // shape: const StadiumBorder(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: Text(
                  controller.formatToMonthName(jalaiDateTime),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'yekan',
                    fontWeight: jalaiDateTime.toDateTime().isAtSameMomentAs(
                            controller.selectedDateTime.value.toDateTime())
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
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
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 0.52 * w,
      child: GridView.count(
        childAspectRatio: 2.7,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        crossAxisCount: 3,
        children: jalaliGenerateMonths(context),
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
            height: 2.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, right: 35, bottom: 6.0),
          child: TextButton(
            onPressed: () => controller.jumpToThisMonth(),
            child: const Text(
              'همین ماه',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'yekan',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, right: 30, bottom: 6.0),
          child: TextButton(
            onPressed: () => controller.closePicker(),
            child: const Text(
              'خوبه',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'yekan',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
