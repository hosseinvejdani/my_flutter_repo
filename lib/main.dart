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
              child: Picker(),
            ),
          ],
        ),
        // body: Center(child: Text(DateFormat.yMMMM().format(controller.selectedMonth.value)),),
      ),
    );
  }
}

class Picker extends StatelessWidget {
  Picker({Key? key}) : super(key: key);

  final controller = Get.put(MonthPickerController());

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      months.add(
        Obx(() {
          DateTime dateTime = DateTime(controller.pickerYear.value, i, 1);
          final backgroundColor =
              dateTime.isAtSameMomentAs(controller.selectedMonth.value)
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
                            .isAtSameMomentAs(controller.selectedMonth.value)
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
          );
        }),
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

  Future<Object?> _monthPicker(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                elevation: 0,
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
        _monthPicker(context);
      },
      child: Row(
        children: [
          const Icon(Icons.arrow_drop_down),
          Obx(
            () => Text(
              // DateFormat.yMMMM().format(controller.selectedMonth.value)
              DateFormat('yMMM').format(controller.selectedMonth.value),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
