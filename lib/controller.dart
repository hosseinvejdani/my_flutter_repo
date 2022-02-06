import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPickerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //----------------------------
  final dynamic _isPickerOpen = false.obs;
  late AnimationController _rotationController;
  final _selectedYear = DateTime.now().year.obs;
  final _selectedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  dynamic get isPickerOpen {
    return _isPickerOpen;
  }

  RxInt get selectedYear {
    return _selectedYear;
  }

  Rx<DateTime> get selectedDateTime {
    return _selectedDateTime;
  }

  void changeYear(int year) {
    _selectedYear.value = _selectedYear.value + year;
  }

  void selectMonth(DateTime dateTime) {
    _selectedDateTime.value = dateTime;
  }

  void switchPicker() {
    _isPickerOpen.value
        ? _rotationController.reverse(from: 0.5)
        : _rotationController.forward(from: 0.0);
    _isPickerOpen.value = !_isPickerOpen.value;

    if (!_isPickerOpen.value) {
      Get.back();
    }
  }

  Animation<double> rotationController() {
    return Tween(begin: 0.0, end: 0.5).animate(_rotationController);
  }

  void jumpToThisMonth() {
    _selectedDateTime.value = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );
  }
}
