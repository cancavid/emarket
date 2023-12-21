import 'package:flutter/material.dart';
import 'package:meqamax/widgets/alphabet.dart';
import 'package:meqamax/widgets/image.dart';

class ProfilePicture extends StatelessWidget {
  final Map data;
  final double size;
  final double fontSize;

  const ProfilePicture({super.key, required this.data, this.size = 80.0, this.fontSize = 24.0});

  @override
  Widget build(BuildContext context) {
    return (data['profile_image'] != '' && data['profile_image'] != null)
        ? ClipRRect(borderRadius: BorderRadius.circular(size), child: MsImage(url: data['profile_image'], width: size, height: size))
        : AlphabetPP(
            data: data,
            size: size,
            fontSize: fontSize,
          );
  }
}
