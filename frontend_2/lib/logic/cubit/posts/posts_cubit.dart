import 'package:flutter_bloc/flutter_bloc.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsState(allPosts: _initialPosts));

  static final List<Post> _initialPosts = [
    Post(
      title: 'Mhajeb ',
      store: "Fatma's Kitchen",
      price: '250 da',
      rating: 4.8,
      distance: '0.5 km',
      image: 'assets/images/salad.jpg',
    ),
    Post(
      title: 'Taam (Couscous with Raisins and Butter)',
      store: "Dar El Taam",
      price: '340 da',
      rating: 4.9,
      distance: '1.2 km',
      image: 'assets/images/pasta.png',
    ),
    Post(
      title: 'Baghrir - Algerian Pancakes',
      store: "Sweet Delights DZ",
      price: '250 da',
      rating: 5.0,
      distance: '0.8 km',
      image: 'assets/images/pasta.png',
    ),
    Post(
      title: 'Chakhchoukha Biskra',
      store: "Chef's Table DZ",
      price: '145 da',
      rating: 4.7,
      distance: '2.1 km',
      image: 'assets/images/salad.jpg',
    ),
    Post(
      title: 'Rechta - Homemade Noodles',
      store: "Dar El Rechta",
      price: '999 da',
      rating: 4.6,
      distance: '1.5 km',
      image: 'assets/images/pasta.png',
    ),
    Post(
      title: 'Kesra with Lben',
      store: "Traditional Stop",
      price: '650 da',
      rating: 4.5,
      distance: '0.3 km',
      image: 'assets/images/pasta.png',
    ),
  ];

  void searchPosts(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(
        searchQuery: query,
        filteredPosts: state.allPosts,
      ));
      return;
    }

    final filtered = state.allPosts.where((post) {
      final searchLower = query.toLowerCase();
      return post.title.toLowerCase().contains(searchLower) ||
          post.store.toLowerCase().contains(searchLower);
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredPosts: filtered,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredPosts: state.allPosts,
    ));
  }

  void loadPosts() {
    emit(state.copyWith(isLoading: true));
    // Simulate loading - Replace with actual API call
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false));
    });
  }
}

