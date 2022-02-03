import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPickerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //----------------------------
  late AnimationController _controller;
  final dynamic _pickerOpen = false.obs;
  final _pickerYear = DateTime.now().year.obs;
  // ignore: prefer_final_fields
  var _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  dynamic get pickerOpen {
    return _pickerOpen;
  }

  RxInt get pickerYear {
    return _pickerYear;
  }

  Rx<DateTime> get selectedMonth {
    return _selectedMonth;
  }

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  void switchPicker() {
    _pickerOpen.value
        ? _controller.reverse(from: 0.5)
        : _controller.forward(from: 0.0);
    _pickerOpen.value = !_pickerOpen.value;
  }

  Animation<double> rotationController() {
    return Tween(begin: 0.0, end: 0.5).animate(_controller);
  }

  void changeYear(int year) {
    _pickerYear.value = _pickerYear.value + year;
  }

  void selectMonth(DateTime dateTime) {
    _selectedMonth.value = dateTime;
  }
}



// late AnimationController _controller;

// @override
// void initState() {
//   _controller = AnimationController(
//     duration: const Duration(milliseconds: 100),
//     vsync: this,
//   );
//   super.initState();
// }

// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }

// void switchPicker() {
//   setState(() {
//     _pickerOpen ? _controller.reverse(from: 0.5) : _controller.forward(from: 0.0);
//     _pickerOpen = !_pickerOpen;
//   });
// }

// RotationTransition(
//  turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
//        child: const Icon(Icons.arrow_drop_down),
//     ),

// ====================================================================================
// https://stackoverflow.com/questions/67628795/how-to-use-animationcontroller-in-getx-instead-of-using-statefulwidget-and-singl

// class CartController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   late AnimationController _badgeShopCartAnimationController;

//   @override
//   void onInit() {
//     super.onInit();

//     _badgeShopCartAnimationSetup();
//   }

//   void addCartItem(Product product) {
//     cartService.addCartItem(product);
//     _badgeShopCartAnimationPlay();
//   }

//   void _badgeShopCartAnimationSetup() {
//     _badgeShopCartAnimationController = AnimationController(
//         duration: const Duration(milliseconds: 225), vsync: this);

//     badgeShopCartAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.0),
//       end: const Offset(.2, 0.0),
//     ).animate(
//       CurvedAnimation(
//         parent: _badgeShopCartAnimationController,
//         curve: Curves.elasticIn,
//       ),
//     );
//   }

//   void _badgeShopCartAnimationPlay() async {
//     await _badgeShopCartAnimationController.forward();
//     await _badgeShopCartAnimationController.reverse();
//   }
// }
