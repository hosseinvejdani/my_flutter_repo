// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import './controller.dart';
import 'models.dart';
// import 'package:shamsi_date/shamsi_date.dart';
// import 'package:persian_number_utility/persian_number_utility.dart';

// this is animated persian month picker with getx

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: Colors.purple,
      // fontFamily: 'Quicksand',
    );
    // ignore: prefer_const_constructors
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale("fa", "IR"),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          Get.to(CategoryPickerScreen());
        },
      ),
    );
  }
}

class CategoryPickerScreen extends StatelessWidget {
  CategoryPickerScreen({Key? key}) : super(key: key);

  final categoryPickerController = Get.put(CategoryPickerController());

  List<Widget> categoryList(BuildContext context) {
    return categoryPickerController.categoryList.map((cat) {
      return CategoryItem(
        category: cat,
        size: 28,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    categoryPickerController.refreshSelectedCategoryId();
    final appBar = AppBar(leading: BackButton(color: Colors.grey[800]));
    // final h = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            height: 300,
            child: GridView.count(
              childAspectRatio: 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
              crossAxisCount: 4,
              children: [...categoryList(context)],
            ),
          ),
          const Center(
            child: Text('salam'),
          )
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    this.category,
    this.size,
    Key? key,
  }) : super(key: key);

  final Category? category;
  final double? size;

  final categoryPickerController = Get.find<CategoryPickerController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => IconInCircle(
              icon: category?.icon,
              iconColor: category?.categoryId ==
                      categoryPickerController.selectedCategoryId.value
                  ? Colors.white
                  : Colors.grey[850],
              backGroundColor: category?.categoryId ==
                      categoryPickerController.selectedCategoryId.value
                  ? category?.backGroundColor
                  : Colors.grey[300]?.withOpacity(0.6),
              size: size,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              (category?.title).toString(),
              style: TextStyle(letterSpacing: 0.7, fontSize: 0.5 * size!),
            ),
          ),
        ],
      ),
      onTap: () {
        categoryPickerController.setSelectedCategoryId(category?.categoryId);
      },
    );
  }
}

class IconInCircle extends StatelessWidget {
  const IconInCircle({
    Key? key,
    this.icon,
    this.iconColor,
    this.backGroundColor,
    this.size,
  }) : super(key: key);

  final IconData? icon;
  final Color? backGroundColor;
  final Color? iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backGroundColor,
      radius: 0.85 * size!,
      child: Icon(
        icon,
        color: iconColor,
        size: size,
      ),
    );
  }
}
