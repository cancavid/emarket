import 'package:flutter/material.dart';

class MsIndicator extends StatelessWidget {
  const MsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
