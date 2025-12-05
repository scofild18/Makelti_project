class Post {
  final String title;
  final String store;
  final String price;
  final double rating;
  final String distance;
  final String image;

  Post({
    required this.title,
    required this.store,
    required this.price,
    required this.rating,
    required this.distance,
    required this.image,
  });
}

class PostsState {
  final List<Post> allPosts;
  final List<Post> filteredPosts;
  final String searchQuery;
  final bool isLoading;

  PostsState({
    required this.allPosts,
    List<Post>? filteredPosts,
    this.searchQuery = '',
    this.isLoading = false,
  }) : filteredPosts = filteredPosts ?? allPosts;

  PostsState copyWith({
    List<Post>? allPosts,
    List<Post>? filteredPosts,
    String? searchQuery,
    bool? isLoading,
  }) {
    return PostsState(
      allPosts: allPosts ?? this.allPosts,
      filteredPosts: filteredPosts ?? this.filteredPosts,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

