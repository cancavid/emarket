import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/classes/downloader.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets_extra/pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LightboxScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const LightboxScreen({super.key, required this.imageUrls, required this.initialIndex});

  @override
  State<LightboxScreen> createState() => _LightboxScreenState();
}

class _LightboxScreenState extends State<LightboxScreen> {
  late int _currentIndex;
  bool showDownloadedBar = false;
  bool showProgressBar = false;
  int progress = 0;
  String taskId = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  action(id, status, value) {
    if (status == DownloadTaskStatus.running) {
      setState(() {
        showDownloadedBar = true;
        showProgressBar = true;
        taskId = id;
        progress = value;
      });
    } else if (status == DownloadTaskStatus.complete) {
      setState(() {
        showProgressBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dismissible(
            onUpdate: (data) {
              if (data.progress >= .5) {
                Get.back();
              }
            },
            direction: DismissDirection.vertical,
            key: const Key('key'),
            child: PhotoViewGallery.builder(
              loadingBuilder: (context, event) {
                return MsIndicator();
              },
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              itemCount: widget.imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              pageController: PageController(initialPage: _currentIndex),
            )),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Pagination(
            data: widget.imageUrls,
            activeIndex: _currentIndex,
          ),
        ),
        if (showDownloadedBar && taskId != '') ...[
          (showProgressBar)
              ? Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF222222),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Şəkil yüklənir...', style: GoogleFonts.inter(color: Colors.white)),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(value: progress / 100, minHeight: 2.0),
                            ),
                            SizedBox(width: 15.0),
                            Text('${progress.toString()}%', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500))
                          ],
                        ),
                      ],
                    ),
                  ))
              : Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: Dismissible(
                    key: GlobalKey(),
                    onDismissed: (_) {
                      if (mounted) {
                        setState(() {
                          showDownloadedBar = false;
                          taskId = '';
                        });
                      }
                    },
                    direction: DismissDirection.down,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Şəkil uğurla yükləndi.',
                            style: GoogleFonts.inter(color: Colors.white),
                          )),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Downloader downloader = Downloader();
                                downloader.openDownloadedFile(taskId);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Faylı aç',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
        ],
        Positioned(
          top: 10.0,
          right: 10.0,
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () {
                    Downloader downloader = Downloader();
                    downloader.init(action: action);
                    downloader.download(widget.imageUrls[_currentIndex]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(.5), borderRadius: BorderRadius.circular(50.0)),
                    child: Icon(Icons.arrow_downward, color: Colors.white, size: 26.0),
                  ),
                ),
                SizedBox(width: 3.0),
                InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(.5), borderRadius: BorderRadius.circular(50.0)),
                    child: Icon(Icons.close, color: Colors.white, size: 26.0),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
