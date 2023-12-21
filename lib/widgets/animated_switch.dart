import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimatedSwitch extends StatelessWidget {
  final bool data;
  Duration animationDuration = Duration(milliseconds: 150);

  AnimatedSwitch({super.key, this.data = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 26,
        width: 44,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: data ? Theme.of(context).colorScheme.primary : Color(0xff777777),
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: data ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
