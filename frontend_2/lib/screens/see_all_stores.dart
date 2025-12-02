import 'package:Makelti/widgets/home_screen/nearby_stores_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_screen/search_bar.dart';
import '../logic/cubit/stores/stores_cubit.dart';
import '../logic/cubit/stores/stores_state.dart';

class SeeAllStores extends StatelessWidget {
  const SeeAllStores({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoresCubit, StoresState>(
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
                          title: "Search for stores",
                          initialValue: state.searchQuery,
                          onChanged: (query) {
                            context.read<StoresCubit>().searchStores(query);
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
                      : state.filteredStores.isEmpty
                          ? const Center(
                              child: Text(
                                'No stores found',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.filteredStores.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 1.15,
                                ),
                                itemBuilder: (context, index) {
                                  final store = state.filteredStores[index];
                                  return NearbyStoresCard(
                                    name: store.name,
                                    distance: store.distance,
                                    rating: store.rating,
                                    image: store.image,
                                    onTap: () {
                                      context.goNamed('cook_profile');
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