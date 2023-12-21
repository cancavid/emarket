import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class OrderProgressBar extends StatefulWidget {
  final Map data;
  const OrderProgressBar({super.key, required this.data});

  @override
  State<OrderProgressBar> createState() => _OrderProgressBarState();
}

class _OrderProgressBarState extends State<OrderProgressBar> {
  int currentIndex = 0;
  Map status = {
    'pending': ['Gözləyir'.tr, 'assets/ecommerce/pending.svg'],
    'confirmed': ['Təsdiqləndi'.tr, 'assets/ecommerce/confirmed.svg'],
    'cargo': ['Kuryerə təhvil verildi.'.tr, 'assets/ecommerce/cargo.svg'],
    'completed': ['Tamamlandı'.tr, 'assets/ecommerce/completed.svg']
  };
  List statusKeys = [];

  @override
  void initState() {
    super.initState();
    status.keys.toList();
    setState(() {
      statusKeys = status.keys.toList();
      currentIndex = status.keys.toList().indexOf(widget.data['order_status']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 110.0,
                height: 2.0,
                child: CustomPaint(
                  painter: DottedLinePainter(),
                ),
              ),
            )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (var i = 0; i <= 3; i++) ...[
                if (i <= currentIndex) ...[
                  OrderProgressBarCompletedItem(image: status[statusKeys[i]][1])
                ] else ...[
                  OrderProgressBarItem(image: status[statusKeys[i]][1]),
                ]
              ]
            ]),
          ],
        ),
        SizedBox(height: 20.0),
        Text(getOrderStatus(widget.data['order_status']), style: Theme.of(context).textTheme.extraSmallHeading)
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFDDDDDD)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;

    double currentX = 0.0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, 0),
        Offset(currentX + dashWidth, 0),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OrderProgressBarCompletedItem extends StatelessWidget {
  final String image;
  const OrderProgressBarCompletedItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor.withOpacity(.2), borderRadius: BorderRadius.circular(40.0)),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35.0), color: Theme.of(context).colorScheme.primaryColor.withOpacity(.4)),
          ),
        )),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Theme.of(context).colorScheme.primaryColor),
            child: MsSvgIcon(icon: image, color: Theme.of(context).colorScheme.secondaryBg, size: 18.0),
          ),
        ))
      ],
    );
  }
}

class OrderProgressBarItem extends StatelessWidget {
  final String image;
  const OrderProgressBarItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryBg,
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            width: 1.0,
            color: Theme.of(context).colorScheme.grey3,
          )),
      child: MsSvgIcon(icon: image),
    );
  }
}
