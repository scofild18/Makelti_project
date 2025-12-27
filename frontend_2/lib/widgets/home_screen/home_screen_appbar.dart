import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:Makelti/logic/cubit/profile/profile_cubit.dart';
import 'package:Makelti/logic/cubit/profile/profile_state.dart';
import 'package:Makelti/services/cloudinary_service.dart';

class HomeScreenAppBar extends StatefulWidget {
  const HomeScreenAppBar({super.key});

  @override
  State<HomeScreenAppBar> createState() => _HomeScreenAppBarState();
}

class _HomeScreenAppBarState extends State<HomeScreenAppBar> {
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void initState() {
    super.initState();
    // Load profile when widget initializes
    context.read<ProfileCubit>().loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Extract first name from full name
        final fullName = state.name ?? "User";
        final firstName = fullName.split(' ').first;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Avatar + Greeting
            Expanded(
              child: Row(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: state.profilePicturePublicId != null &&
                              state.profilePicturePublicId!.isNotEmpty
                          ? NetworkImage(
                              _cloudinaryService.getOptimizedUrl(
                                state.profilePicturePublicId!,
                                version: state.profilePictureVersion,
                              ),
                            )
                          : null,
                      child: state.profilePicturePublicId == null ||
                              state.profilePicturePublicId!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Greeting Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $firstName 👋",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right side: Location
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: SizedBox(
                width: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/location.png",
                      height: 20,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Algiers, Sidi Abdellah",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}