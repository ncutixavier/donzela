import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Profile photo from Google when there is one, otherwise the first letter of
/// the name.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.photoUrl, required this.name, required this.radius});

  final String? photoUrl;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final photo = photoUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.terracotta,
      backgroundImage: photo == null ? null : NetworkImage(photo),
      child: photo != null
          ? null
          : Text(
              name.isEmpty ? '?' : name[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: radius * 0.9),
            ),
    );
  }
}
