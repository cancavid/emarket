import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final List data;
  final int activeIndex;
  const Pagination({super.key, required this.data, required this.activeIndex});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  List<Widget> pagination() => List<Widget>.generate(
      widget.data.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 5.0,
            width: widget.activeIndex == index ? 20.0 : 5.0,
            decoration: BoxDecoration(
              color: widget.activeIndex == index ? Colors.white : Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pagination(),
    );
  }
}
