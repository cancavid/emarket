import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class MsRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const MsRefreshIndicator({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(color: Theme.of(context).colorScheme.primaryColor, onRefresh: onRefresh, child: child);
  }
}
