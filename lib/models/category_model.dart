import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;
  Border border1 = Border.all(color: Colors.transparent, width: 1);
  Border border2 = Border.all(color: Colors.black, width: 1);
  bool isSelected = false;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Seeds',
        iconPath: 'assets/icons/farmer.svg',
        boxColor: Colors.green,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Model',
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

    categories.add(
      CategoryModel(
        name: 'Crops',
        iconPath: 'assets/icons/plant.svg',
        boxColor: Colors.purple,
      ),
    );
    return categories;
  }
}