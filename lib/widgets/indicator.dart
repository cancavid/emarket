import 'package:flutter/material.dart';

class MsIndicator extends StatelessWidget {
  final double strokeWidth;
  const MsIndicator({super.key, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
