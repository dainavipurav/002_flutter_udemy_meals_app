import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_005_meals_app/providers/meals_provider.dart';
import 'package:udemy_005_meals_app/screens/categories_screen.dart';
import 'package:udemy_005_meals_app/screens/filters_screen.dart';
import 'package:udemy_005_meals_app/screens/meals_screen.dart';
import 'package:udemy_005_meals_app/widgets/main_drawer.dart';

import '../models/meal.dart';

const kInitialFilters = {
  Filters.gltenFree: false,
  Filters.lactoseFree: false,
  Filters.vegan: false,
  Filters.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  Map<Filters, bool> _selectedFilters = {
    Filters.gltenFree: false,
    Filters.lactoseFree: false,
    Filters.vegan: false,
    Filters.vegetarian: false,
  };

  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      Navigator.pop(context);
      final result = await Navigator.push<Map<Filters, bool>>(
        context,
        MaterialPageRoute(
          builder: (context) {
            return FiltersScreen(
              currentFilters: _selectedFilters,
            );
          },
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _toggleMealFavorite(Meal meal) {
    final isExists = _favoriteMeals.contains(meal);
    if (isExists) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (_selectedFilters[Filters.gltenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavorite,
      availableMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavorite,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      drawer: MainDrawer(
        setScreen: _setScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
