import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

// ignore: must_be_immutable
class MsAccordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  final Function()? onTap;
  bool active;
  MsAccordion({super.key, required this.title, required this.content, this.onTap, this.active = false});

  @override
  State<MsAccordion> createState() => _MsAccordionState();
}

class _MsAccordionState extends State<MsAccordion> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: widget.onTap ??
            () {
              setState(() {
                widget.active = !widget.active;
              });
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(child: widget.title),
              SizedBox(width: 15.0),
              AnimatedRotation(
                turns: (widget.active) ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(Icons.keyboard_arrow_down, size: 30.0, color: Theme.of(context).colorScheme.grey1),
              )
            ],
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Visibility(
            visible: (widget.active) ? true : false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: widget.content,
            ),
          ),
        ),
      ),
    ]);
  }
}
