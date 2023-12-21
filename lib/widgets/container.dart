import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/notify.dart';

class MsContainer extends StatefulWidget {
  final bool loading;
  final bool serverError;
  final bool connectError;
  final Widget child;
  final VoidCallback? action;

  final String serverErrorText;
  final String connectErrorText;

  const MsContainer({
    super.key,
    required this.loading,
    required this.serverError,
    required this.connectError,
    required this.action,
    required this.child,
    this.serverErrorText = 'Serverlə əlaqə yaratmaq mümkün olmadı.',
    this.connectErrorText = 'İnternet bağlantısı problemi var.',
  });

  @override
  State<MsContainer> createState() => _MsContainerState();
}

class _MsContainerState extends State<MsContainer> {
  String serverErrorText = '';
  String connectErrorText = '';

  @override
  void initState() {
    super.initState();
    serverErrorText = widget.serverErrorText.tr;
    connectErrorText = widget.connectErrorText.tr;
  }

  @override
  Widget build(BuildContext context) {
    return (widget.loading)
        ? MsIndicator()
        : (widget.connectError)
            ? MsNotify(heading: connectErrorText, action: widget.action)
            : (widget.serverError)
                ? MsNotify(heading: serverErrorText, action: widget.action)
                : widget.child;
  }
}
