import 'package:flutter/material.dart';
import 'package:meqamax/pages/ecommerce/single_order.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:meqamax/widgets_extra/navigator.dart';

class NotificationItem extends StatelessWidget {
  final String content;
  final String type;
  final String status;
  final Map data;
  final String date;
  const NotificationItem({
    super.key,
    required this.content,
    required this.type,
    required this.data,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String icon = 'assets/interface/bell.svg';

    if (type == 'order') {
      icon = 'assets/interface/orders.svg';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (type == 'order') {
            navigatePage(context, SingleOrderPage(orderId: data['order_id']));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.grey4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.bg,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: MsSvgIcon(
                            icon: icon,
                            size: 20.0,
                            color: Theme.of(context).colorScheme.secondaryColor,
                          ),
                        ),
                        if (status == '0') ...[
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
                            ),
                          )
                        ]
                      ],
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: Text(content),
                    )
                  ],
                ),
              ),
              SizedBox(width: 15.0),
              MsSvgIcon(icon: 'assets/interface/right.svg', color: Theme.of(context).colorScheme.secondaryColor, size: 14.0)
            ],
          ),
        ),
      ),
    );
  }
}
