import 'package:carousel_slider/carousel_slider.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/widgets/pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductGallerySlider extends StatefulWidget {
  const ProductGallerySlider({super.key, required this.data, required this.slide});

  final Map data;
  final List slide;

  @override
  State<ProductGallerySlider> createState() => _ProductGallerySliderState();
}

class _ProductGallerySliderState extends State<ProductGallerySlider> {
  List slide = [];
  final List<String> _imageUrls = [];
  int activeIndex = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    slide = widget.slide;
    if (slide.isEmpty) {
      if (widget.data['gallery'] is List) {
        slide = widget.data['gallery'];
        count = slide.length;
        for (var i = 0; i < count; i++) {
          _imageUrls.add(slide[i]['media_url']);
        }
      } else if (widget.data['variation_gallery'] != null && widget.data['variation_gallery'] != [] && widget.data['variation_gallery'] != 'null' && widget.data.isNotEmpty && widget.data['variation_gallery'] is Map) {
        MapEntry firstEntry = widget.data['variation_gallery'].entries.first;
        slide = firstEntry.value;
        count = slide.length;
        for (var i = 0; i < count; i++) {
          _imageUrls.add(slide[i]['media_url']);
        }
      } else if (widget.data['media_url'] != '' && widget.data['media_url'] != null && widget.data['media_url'] != 'null') {
        slide.add({'media_url': widget.data['media_url']});
        count = 1;
        _imageUrls.add(widget.data['media_url']);
      }
    }
  }

  @override
  void didUpdateWidget(ProductGallerySlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.slide.isNotEmpty) {
      setState(() {
        slide = widget.slide;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (slide.isNotEmpty)
        ? Stack(
            children: [
              CarouselSlider.builder(
                itemCount: slide.length,
                options: CarouselOptions(
                    height: 500.0,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    initialPage: 0,
                    onPageChanged: ((index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    })),
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.black.withOpacity(.8),
                      context: context,
                      builder: (context) {
                        return LightboxScreen(
                          imageUrls: _imageUrls,
                          initialIndex: itemIndex,
                        );
                      },
                    );
                  },
                  child: MsImage(
                    url: slide[itemIndex]['media_url'],
                    height: 500.0,
                    pBackgroundColor: Theme.of(context).colorScheme.bg,
                    pColor: Theme.of(context).colorScheme.grey2,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Pagination(
                    data: slide,
                    activeIndex: activeIndex,
                  ),
                ),
              )
            ],
          )
        : MsImage(
            url: widget.data['media_url'],
            height: 500.0,
            pBackgroundColor: Theme.of(context).colorScheme.bg,
          );
  }
}

class LightboxScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const LightboxScreen({super.key, required this.imageUrls, required this.initialIndex});

  @override
  State<LightboxScreen> createState() => _LightboxScreenState();
}

class _LightboxScreenState extends State<LightboxScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dismissible(
            direction: DismissDirection.vertical,
            key: const Key('key'),
            onDismissed: (_) => Get.back(),
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
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(50.0),
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, color: Colors.white, size: 32.0),
                )),
          ),
        )
      ],
    );
  }
}
