import 'package:html/parser.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:meqamax/widgets_extra/lightbox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meqamax/widgets/indicator.dart';

class MsHtml extends StatefulWidget {
  final String data;
  final Color? color;
  final bool selectable;
  final double? fontSize;

  const MsHtml({super.key, required this.data, this.color, this.selectable = false, this.fontSize});

  @override
  State<MsHtml> createState() => _MsHtmlState();
}

class _MsHtmlState extends State<MsHtml> {
  @override
  Widget build(BuildContext context) {
    final document = parse(widget.data);
    final imageUrls = document.getElementsByTagName('img').map((element) {
      return element.attributes['src'] ?? '';
    }).toList();

    var htmlWidget = HtmlWidget(
      widget.data,
      textStyle: TextStyle(
        color: (widget.color != null) ? widget.color : Theme.of(context).colorScheme.text,
        fontSize: (widget.fontSize != null) ? widget.fontSize : 14.0,
        height: 1.5,
      ),
      onTapImage: (ImageMetadata image) {
        final index = imageUrls.indexOf(image.sources.first.url);

        showDialog(
            barrierColor: Colors.black.withOpacity(.7),
            context: context,
            builder: (context) {
              return LightboxScreen(imageUrls: imageUrls, initialIndex: index);
            });
      },
      onTapUrl: (url) {
        return launchUrl(Uri.parse(url));
      },
      onLoadingBuilder: (context, element, loadingProgress) {
        return MsIndicator();
      },
      customStylesBuilder: (element) {
        if (element.localName == 'img') {
          return {'width': '100%'};
        } else if (element.localName == 'strong') {
          return {'font-family': 'Calibri', 'font-weight': '700'};
        } else if (element.localName == 'h1') {
          return {'font-family': 'Calibri', 'font-weight': '600'};
        } else if (element.localName == 'h2') {
          return {'font-family': 'Calibri', 'font-weight': '600'};
        } else if (element.localName == 'h3') {
          return {'font-family': 'Calibri', 'font-weight': '600'};
        }
        return null;
      },
    );

    return (widget.selectable)
        ? SelectionArea(
            child: htmlWidget,
          )
        : htmlWidget;
  }
}
