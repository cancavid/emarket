import 'dart:io';
import 'package:html/parser.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meqamax/widgets/indicator.dart';

class MsHtml extends StatefulWidget {
  final String data;
  final Color? color;
  final bool selectable;
  final double? fontSize;

  const MsHtml({Key? key, required this.data, this.color, this.selectable = false, this.fontSize}) : super(key: key);

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

    String currentUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

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
              return Stack(
                children: [
                  Dismissible(
                    direction: DismissDirection.vertical,
                    key: const Key('key'),
                    onDismissed: (details) {
                      Get.back();
                    },
                    child: PhotoViewGallery.builder(
                      itemCount: imageUrls.length,
                      builder: (context, index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(imageUrls[index]),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 2,
                        );
                      },
                      loadingBuilder: (context, event) {
                        return MsIndicator(); // Use your custom loading indicator widget
                      },
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      pageController: PageController(initialPage: index),
                      onPageChanged: (index) {
                        currentUrl = imageUrls[index];
                      },
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: Row(
                      children: [
                        (currentUrl.isNotEmpty)
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(50.0),
                                    onTap: () async {
                                      final Directory? downloadsDirectory = await getDownloadsDirectory();
                                      if (downloadsDirectory != null) {
                                        await FlutterDownloader.enqueue(
                                          url: currentUrl,
                                          savedDir: downloadsDirectory.path,
                                          showNotification: true,
                                          openFileFromNotification: true,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.arrow_downward, color: Colors.white, size: 28.0),
                                    )),
                              )
                            : SizedBox(),
                        SizedBox(width: 5.0),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(50.0),
                              onTap: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.close, color: Colors.white, size: 28.0),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              );
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
