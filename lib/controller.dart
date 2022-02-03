import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPickerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //----------------------------
  final dynamic _pickerOpen = false.obs;
  late AnimationController _controller;
  final _pickerYear = DateTime.now().year.obs;
  final _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  dynamic get pickerOpen {
    return _pickerOpen;
  }

  RxInt get pickerYear {
    return _pickerYear;
  }

  Rx<DateTime> get selectedMonth {
    return _selectedMonth;
  }

  void changeYear(int year) {
    _pickerYear.value = _pickerYear.value + year;
  }

  void selectMonth(DateTime dateTime) {
    _selectedMonth.value = dateTime;
  }

  void switchPicker() {
    _pickerOpen.value
        ? _controller.reverse(from: 0.5)
        : _controller.forward(from: 0.0);
    _pickerOpen.value = !_pickerOpen.value;

    if (!_pickerOpen.value) {
      Get.back();
    }
  }

  Animation<double> rotationController() {
    return Tween(begin: 0.0, end: 0.5).animate(_controller);
  }
}
