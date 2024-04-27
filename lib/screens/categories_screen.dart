import 'package:flutter/material.dart';
import 'package:udemy_005_meals_app/data/dummy_data.dart';
import 'package:udemy_005_meals_app/models/category.dart';
import 'package:udemy_005_meals_app/widgets/category_item.dart';

import '../models/meal.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Meal> availableMeals;
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  void _onSelectCategory(Category category, BuildContext ctx) {
    final filteredList = widget.availableMeals
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
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // ### Explicit Animation basic 1 ###
          // return Padding(
          //   padding: EdgeInsets.only(
          //     top: 100 - _animationController.value * 100,
          //   ),
          //   child: child,
          // );

          // ### Explicit Animation basic 2 ###
          return SlideTransition(
            position: _animationController.drive(
              Tween(
                begin: const Offset(0,
                    0.3), // child takes 30% below of actual position in Y axis
                end: const Offset(0, 0), // child Takes default position
              ),
            ),
            child: child,
          );
        },
        child: GridView(
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
      ),
    );
  }
}
