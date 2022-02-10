import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class MonthPickerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //----------------------------
  final dynamic _isPickerOpen = false.obs;
  late AnimationController _rotationController;
  final _selectedYear = Jalali.now().year.obs;
  final _selectedDateTime = Jalali(
    Jalali.now().year,
    Jalali.now().month,
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

  Rx<Jalali> get selectedDateTime {
    return _selectedDateTime;
  }

  void changeYear(int year) {
    _selectedYear.value = _selectedYear.value + year;
  }

  void selectMonth(Jalali dateTime) {
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

  void closePicker() {
    _isPickerOpen.value = false;
    _rotationController.reverse(from: 0.5);
    Get.back();
  }

  Animation<double> rotationController() {
    return Tween(begin: 0.0, end: 0.5).animate(_rotationController);
  }

  void jumpToThisMonth() {
    _selectedYear.value = Jalali.now().year;
    _selectedDateTime.value = Jalali(
      Jalali.now().year,
      Jalali.now().month,
      1,
    );
    // switchPicker();
  }

  String formatToYearNumberMonthName(Jalali jalaiDateTime) {
    return '${jalaiDateTime.year.toString().toPersianDigit()} ${jalaiDateTime.formatter.mN}';
  }

  String formatToYearNumberMonthNumber(Jalali jalaiDateTime) {
    return '${jalaiDateTime.year.toString().toPersianDigit()} ${jalaiDateTime.month}';
  }

  String formatToMonthName(Jalali jalaiDateTime) {
    return jalaiDateTime.formatter.mN;
  }
}
