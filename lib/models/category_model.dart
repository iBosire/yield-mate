import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Price',
        iconPath: 'assets/icons/farmer.svg',
        boxColor: Colors.green,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Parameters',
        iconPath: 'assets/icons/mlServer.svg',
        boxColor: Colors.blue,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Locations',
        iconPath: 'assets/icons/location.svg',
        boxColor: Colors.orange,
      ),
    );
    return categories;
  }
}