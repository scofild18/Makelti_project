import 'package:flutter_bloc/flutter_bloc.dart';
import 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  StoresCubit() : super(StoresState(allStores: _initialStores));

  static final List<Store> _initialStores = [
    Store(
      name: "Maria's Kitchen",
      distance: "0.5 km",
      rating: 4.8,
      image: 'assets/images/store.jpg',
    ),
    Store(
      name: "Green Eats",
      distance: "1.2 km",
      rating: 4.9,
      image: 'assets/images/pizza_store.jpg',
    ),
    Store(
      name: "Sweet Delights",
      distance: "0.8 km",
      rating: 5.0,
      image: 'assets/images/store.jpg',
    ),
  ];

  void searchStores(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(
        searchQuery: query,
        filteredStores: state.allStores,
      ));
      return;
    }

    final filtered = state.allStores.where((store) {
      final searchLower = query.toLowerCase();
      return store.name.toLowerCase().contains(searchLower);
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredStores: filtered,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredStores: state.allStores,
    ));
  }

  void loadStores() {
    emit(state.copyWith(isLoading: true));
    // Simulate loading - Replace with actual API call
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false));
    });
  }
}

