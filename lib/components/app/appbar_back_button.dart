import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.grey4),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Theme.of(context).colorScheme.secondaryBg, // Set the color of the circle
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).colorScheme.text,
              iconSize: 19.0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
