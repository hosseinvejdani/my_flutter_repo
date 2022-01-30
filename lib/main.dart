import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimatedMonthPicker(),
    );
  }
}

class AnimatedMonthPicker extends StatefulWidget {
  const AnimatedMonthPicker({Key? key}) : super(key: key);

  @override
  _AnimatedMonthPickerState createState() => _AnimatedMonthPickerState();
}

class _AnimatedMonthPickerState extends State<AnimatedMonthPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen
          ? _controller.reverse(from: 0.5)
          : _controller.forward(from: 0.0);
      _pickerOpen = !_pickerOpen;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.amberAccent[200]?.withOpacity(0.9)
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
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
              setState(() {
                _selectedMonth = dateTime;
              });
              switchPicker();
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: const CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: dateTime.isAtSameMomentAs(_selectedMonth)
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
        ),
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
        title: Text(DateFormat.yMMMM().format(_selectedMonth)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: switchPicker,
              child: Row(
                children: [
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  Text(
                    DateFormat('MMM').format(_selectedMonth),
                    style: const TextStyle(color: Colors.white, fontSize: 17),
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
            child:
                Center(child: Text(DateFormat.yMMMM().format(_selectedMonth))),
          ),
          GestureDetector(
            onTap: switchPicker,
            child: Material(
              color: Colors.black.withOpacity(0.7),
              child: AnimatedSize(
                curve: Curves.easeInOut,
                // vsync: this,
                duration: const Duration(milliseconds: 10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: _pickerOpen ? null : 0.0,
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
              child: SizedBox(
                height: _pickerOpen ? 155 : 0.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear - 1;
                            });
                          },
                          icon: Icon(Icons.navigate_before_rounded,
                              color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _pickerYear.toString(),
                              // style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _pickerYear = _pickerYear + 1;
                            });
                          },
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
        ],
      ),
    );
  }
}
