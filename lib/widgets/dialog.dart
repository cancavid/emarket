import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class MsDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final Widget? actions;
  const MsDialog({super.key, this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(title!, style: Theme.of(context).textTheme.largeHeading),
              SizedBox(height: 10.0),
            ],
            if (content != null) ...[
              Text(content!, style: Theme.of(context).textTheme.smallHeading),
              SizedBox(height: 10.0),
            ],
            if (actions != null) ...[
              Transform(transform: Matrix4.translationValues(10.0, 0.0, 0.0), child: actions!),
            ]
          ],
        ),
      ),
    );
  }
}
