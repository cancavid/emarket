import 'package:flutter/material.dart';
import 'package:meqamax/components/settings/profile_image.dart';
import 'package:meqamax/themes/theme.dart';

class SettingsLoginHeader extends StatelessWidget {
  final Map data;
  const SettingsLoginHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return (data.isNotEmpty)
        ? Column(
            children: [
              SizedBox(height: 30.0),
              ProfilePicture(data: data),
              SizedBox(height: 10.0),
              Text(data['display_name'], style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 5.0),
              Text(data['user_email'], style: Theme.of(context).textTheme.bodySmall),
              SizedBox(height: 30.0),
              Container(
                color: Theme.of(context).colorScheme.grey3,
                width: double.infinity,
                height: 1.0,
                margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              ),
            ],
          )
        : SizedBox();
  }
}
