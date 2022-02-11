import 'package:flutter/material.dart';

class Category {
  const Category({
    this.categoryId,
    this.icon,
    this.title,
    this.backGroundColor,
  });

  final String? categoryId;
  final IconData? icon;
  final String? title;
  final Color? backGroundColor;
}
