import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

// ignore: must_be_immutable
class MsImage extends StatelessWidget {
  dynamic url;
  final double width;
  final double? height;
  final Color color;
  final BoxFit fit;
  final double pSize;
  final Color? pColor;
  final Color? pBackgroundColor;

  MsImage({super.key, required this.url, this.width = double.infinity, this.height, this.color = Colors.black, this.fit = BoxFit.cover, this.pSize = 50.0, this.pColor, this.pBackgroundColor});

  @override
  Widget build(BuildContext context) {
    String extension = '';
    if (url is String && url != '' && url != null && url != 'null') {
      extension = url.substring(url.length - 3);
    } else {
      url = '';
    }
    return (url != '')
        ? (extension == 'svg')
            ? SvgPicture.network(
                url,
                width: width,
                height: height,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                fit: BoxFit.contain,
              )
            : CachedNetworkImage(
                fadeInDuration: Duration(seconds: 0),
                fadeOutDuration: Duration(seconds: 0),
                imageUrl: url,
                placeholder: (context, url) => Container(
                  width: width,
                  height: height,
                  color: Theme.of(context).colorScheme.secondaryBg,
                  child: MsSvgIcon(
                    icon: 'assets/interface/placeholder.svg',
                    size: pSize,
                    color: Theme.of(context).colorScheme.grey3,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: width,
                  height: height,
                  color: Theme.of(context).colorScheme.secondaryBg,
                  child: MsSvgIcon(
                    icon: 'assets/interface/placeholder.svg',
                    size: width / pSize,
                    color: Theme.of(context).colorScheme.grey3,
                  ),
                ),
                width: width,
                height: height,
                fit: fit,
              )
        : Container(
            width: width,
            height: height,
            color: (pBackgroundColor != null) ? pBackgroundColor : Theme.of(context).colorScheme.secondaryBg,
            child: MsSvgIcon(
              icon: 'assets/interface/placeholder.svg',
              size: pSize,
              color: (pColor != null) ? pColor : Theme.of(context).colorScheme.grey3,
            ),
          );
  }
}
