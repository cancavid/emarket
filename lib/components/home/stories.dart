import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/controllers/story_controller.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';

class Stories extends StatefulWidget {
  final List stories;
  const Stories({super.key, required this.stories});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  int _currentIndex = 0;
  bool animate = false;
  final CarouselController _carouselController = CarouselController();
  final storyController = Get.put(StoryController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.stories.isEmpty)
        ? SizedBox()
        : Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              height: 120.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.stories.length,
                itemBuilder: (context, index) {
                  return Row(children: [
                    (index == 0) ? SizedBox(width: 15.0) : SizedBox(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          storyController.update();
                        });
                        showDialog(
                          barrierColor: Colors.black,
                          context: context,
                          builder: (context) {
                            return showStoryDetails(context);
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: MsImage(
                                url: widget.stories[index]['story_image']['media_url'],
                                width: 80.0,
                                height: 80.0,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: Colors.grey.withOpacity(.3)),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    (index == widget.stories.length - 1) ? SizedBox(width: 15.0) : SizedBox(),
                  ]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 7.0);
                },
              ),
            )
          ]);
  }

  GestureDetector showStoryDetails(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 5.0) {
          storyController.update();
          Get.back();
        }
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2.0,
                    color: Color(0xFF555555),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Obx(() => AnimatedContainer(
                          duration: Duration(milliseconds: storyController.duration.value),
                          width: storyController.width.value,
                          height: 2.0,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: widget.stories.length,
                  itemBuilder: (context, itemIndex, pageIndex) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _carouselController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
                          },
                          child: MsImage(
                            url: widget.stories[itemIndex]['story_image']['media_url'],
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              redirectUrl(widget.stories[itemIndex]['story_url']);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15.0),
                              color: Theme.of(context).colorScheme.bg.withOpacity(.7),
                              child: Text(
                                'Daha ətraflı',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  options: CarouselOptions(
                    height: double.infinity,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: _currentIndex,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    enlargeCenterPage: true,
                    enlargeFactor: 0,
                    onPageChanged: (index, reason) {
                      storyController.update();
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 7.0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                color: Theme.of(context).colorScheme.bg,
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.close,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
