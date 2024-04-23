import 'package:flutter/material.dart';
import 'package:udemy_005_meals_app/data/dummy_data.dart';
import 'package:udemy_005_meals_app/models/category.dart';
import 'package:udemy_005_meals_app/widgets/category_item.dart';

import '../models/meal.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Meal> availableMeals;
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  void _onSelectCategory(Category category, BuildContext ctx) {
    final filteredList = availableMeals
        .where((element) => element.categories.contains(category.id))
        .toList();

    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) {
          return MealScreen(
            title: category.title,
            meals: filteredList,
          );
        },
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryItem(
              category: category,
              onSelectCategory: () {
                _onSelectCategory(category, context);
              },
            ),
        ],
      ),
    );
  }
}
