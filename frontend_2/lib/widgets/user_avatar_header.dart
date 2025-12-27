import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Makelti/logic/cubit/profile/profile_cubit.dart';
import 'package:Makelti/logic/cubit/profile/profile_state.dart';
import 'package:Makelti/services/cloudinary_service.dart';

class UserAvatarHeader extends StatelessWidget {
  final double avatarRadius;
  final double fontSize;
  final bool showBadge;
  final String? badgeText;
  final VoidCallback? onTap;

  const UserAvatarHeader({
    super.key,
    this.avatarRadius = 22,
    this.fontSize = 17,
    this.showBadge = false,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cloudinaryService = CloudinaryService();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Show loading placeholder while fetching
        if (state.isLoading) {
          return Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.grey[300],
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    if (showBadge) ...[
                      const SizedBox(height: 6),
                      Container(
                        height: 14,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        }

        // Show user data
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.grey[300],
                backgroundImage: state.profilePicturePublicId != null &&
                        state.profilePicturePublicId!.isNotEmpty
                    ? NetworkImage(
                        cloudinaryService.getOptimizedUrl(
                          state.profilePicturePublicId!,
                          version: state.profilePictureVersion,
                        ),
                      )
                    : null,
                child: state.profilePicturePublicId == null ||
                        state.profilePicturePublicId!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: avatarRadius * 0.8,
                        color: Colors.grey[600],
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.name ?? "User Name",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showBadge && badgeText != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 243, 243),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 4,
                        ),
                        child: Text(
                          badgeText!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(176, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}