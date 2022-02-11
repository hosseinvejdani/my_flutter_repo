// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_repo/models.dart';
// import 'package:shamsi_date/shamsi_date.dart';
// import 'package:persian_number_utility/persian_number_utility.dart';

class CategoryPickerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //----------------------------
  final RxList<Category> _categoryList = <Category>[].obs;
  final RxString _selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _categoryList.add(
      const Category(
        categoryId: 'c1',
        title: 'category 1',
        backGroundColor: Colors.cyanAccent,
        icon: Icons.wallet_travel_outlined,
      ),
    );
    _categoryList.add(
      const Category(
        categoryId: 'c2',
        title: 'category 2',
        backGroundColor: Colors.redAccent,
        icon: Icons.cabin_outlined,
      ),
    );
    _categoryList.add(
      const Category(
        categoryId: 'c3',
        title: 'category 3',
        backGroundColor: Colors.greenAccent,
        icon: Icons.outbound_outlined,
      ),
    );
    _categoryList.add(
      const Category(
        categoryId: 'c4',
        title: 'category 4',
        backGroundColor: Colors.limeAccent,
        icon: Icons.air_outlined,
      ),
    );
    _categoryList.add(
      const Category(
        categoryId: 'c5',
        title: 'category 5',
        backGroundColor: Colors.pinkAccent,
        icon: Icons.nat_outlined,
      ),
    );
  }

  RxList<Category> get categoryList => _categoryList;
  RxString get selectedCategoryId => _selectedCategoryId;

  void refreshSelectedCategoryId() => _selectedCategoryId.value = '';
  void setSelectedCategoryId(String? categoryId) =>
      _selectedCategoryId.value = categoryId!;
}
