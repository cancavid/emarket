import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:meqamax/widgets/image.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:meqamax/widgets/pagination.dart';

// ignore: must_be_immutable
class Carousel extends StatefulWidget {
  final List slides;

  const Carousel({super.key, required this.slides});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.slides.isNotEmpty)
        ? Container(
            height: 250.0,
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CarouselSlider.builder(
                    itemCount: widget.slides.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                      onTap: () {
                        redirectUrl(widget.slides[itemIndex]['s_url']);
                      },
                      child: MsImage(
                        url: widget.slides[itemIndex]['s_image']['media_url'],
                        height: 250.0,
                        width: MediaQuery.of(context).size.width,
                        pSize: 100,
                      ),
                    ),
                    options: CarouselOptions(
                      height: double.infinity,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 6),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 10.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Pagination(
                      data: widget.slides,
                      activeIndex: activeIndex,
                    ),
                  ),
                )
              ],
            ),
          )
        : MsIndicator();
  }
}
