import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_screen/food_card.dart';
import '../widgets/home_screen/search_bar.dart';
import '../logic/cubit/posts/posts_cubit.dart';
import '../logic/cubit/posts/posts_state.dart';
import 'client_meal_screen.dart';

class SeeAllPostsScreen extends StatelessWidget {
  const SeeAllPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(
                          title: "Search for food",
                          initialValue: state.searchQuery,
                          onChanged: (query) {
                            context.read<PostsCubit>().searchPosts(query);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.filteredPosts.isEmpty
                          ? const Center(
                              child: Text(
                                'No posts found',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.filteredPosts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.78,
                                ),
                                itemBuilder: (context, index) {
                                  final post = state.filteredPosts[index];
                                  return FoodCard(
                                    image: post.image,
                                    price: post.price,
                                    title: post.title,
                                    store: post.store,
                                    rating: post.rating,
                                    distance: post.distance,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ClientMealScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}