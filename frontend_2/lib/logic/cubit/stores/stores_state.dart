class Store {
  final String name;
  final String distance;
  final double rating;
  final String image;

  Store({
    required this.name,
    required this.distance,
    required this.rating,
    required this.image,
  });
}

class StoresState {
  final List<Store> allStores;
  final List<Store> filteredStores;
  final String searchQuery;
  final bool isLoading;

  StoresState({
    required this.allStores,
    List<Store>? filteredStores,
    this.searchQuery = '',
    this.isLoading = false,
  }) : filteredStores = filteredStores ?? allStores;

  StoresState copyWith({
    List<Store>? allStores,
    List<Store>? filteredStores,
    String? searchQuery,
    bool? isLoading,
  }) {
    return StoresState(
      allStores: allStores ?? this.allStores,
      filteredStores: filteredStores ?? this.filteredStores,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

