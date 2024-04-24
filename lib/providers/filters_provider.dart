import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filters {
  gltenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
      : super(
          {
            Filters.gltenFree: false,
            Filters.lactoseFree: false,
            Filters.vegan: false,
            Filters.vegetarian: false,
          },
        );

  void setFilter(Filters filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filterProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
        (ref) => FiltersNotifier());
