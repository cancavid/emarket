import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/notify.dart';

class MsSimpleNtify extends StatefulWidget {
  final MsNotifyTypes type;
  final String heading;

  const MsSimpleNtify({super.key, required this.heading, this.type = MsNotifyTypes.success});

  @override
  State<MsSimpleNtify> createState() => _MsSimpleNtifyState();
}

class _MsSimpleNtifyState extends State<MsSimpleNtify> {
  IconData icon = Icons.check;
  Color color = Colors.green;

  @override
  void initState() {
    super.initState();

    if (widget.type == MsNotifyTypes.error) {
      icon = Icons.close;
      color = Colors.red;
    } else if (widget.type == MsNotifyTypes.info) {
      icon = Icons.info_outline_rounded;
      color = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.secondaryBg,
                size: 44.0,
              )),
          SizedBox(height: 15.0),
          Text(widget.heading, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
