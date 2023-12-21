import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/button.dart';

enum MsNotifyTypes { success, error, info }

class MsNotify extends StatefulWidget {
  final IconData icon;
  final String? image;
  final String heading;
  final Color color;
  final VoidCallback? action;
  final String actionText;
  final MsNotifyTypes type;
  const MsNotify({super.key, this.icon = Icons.close, this.image, required this.heading, this.color = Colors.red, this.action, this.actionText = 'Səhifəni yenilə', this.type = MsNotifyTypes.error});

  @override
  State<MsNotify> createState() => _MsNotifyState();
}

class _MsNotifyState extends State<MsNotify> {
  double firstSize = 100.0;
  double secondSize = 100.0;
  Color color = Colors.red;
  IconData icon = Icons.close;
  String actionText = '';

  @override
  void initState() {
    super.initState();

    icon = widget.icon;
    color = widget.color;

    if (widget.type == MsNotifyTypes.success) {
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (widget.type == MsNotifyTypes.info) {
      color = Theme.of(context).colorScheme.secondaryColor;
      icon = Icons.info;
    }

    actionText = widget.actionText.tr;

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        firstSize = 200.0;
        secondSize = 250.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Theme.of(context).colorScheme.secondaryBg,
      child: Center(
          child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 75.0),
          children: [
            (widget.image != null)
                ? Image.asset(widget.image!)
                : Stack(
                    children: [
                      SizedBox(
                        width: 250.0,
                        height: 250.0,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 900),
                            width: secondSize,
                            height: secondSize,
                            curve: Curves.fastOutSlowIn,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(150.0), color: color.withOpacity(.1)),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: firstSize,
                            height: firstSize,
                            curve: Curves.fastOutSlowIn,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(150.0), color: color.withOpacity(.3)),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(150.0), color: color),
                            child: Icon(icon, size: 60.0, color: Theme.of(context).colorScheme.bg),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 25.0),
            Text(widget.heading, style: const TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            widget.action != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
                    child: MsButton(onTap: widget.action ?? () {}, title: actionText),
                  )
                : Container()
          ],
        ),
      )),
    );
  }
}
