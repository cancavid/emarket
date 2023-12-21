import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/single_product/gallery.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:share_plus/share_plus.dart';

class SingleProductAppBar extends StatefulWidget {
  final bool wishlistLoading;
  final Function onTap;
  final Map data;
  final List slide;
  const SingleProductAppBar({super.key, required this.wishlistLoading, required this.onTap, required this.data, required this.slide});

  @override
  State<SingleProductAppBar> createState() => _SingleProductAppBarState();
}

class _SingleProductAppBarState extends State<SingleProductAppBar> {
  final wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        toolbarHeight: 60.0,
        leading: Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22.0,
                backgroundColor: Theme.of(context).colorScheme.secondaryBg.withOpacity(.5), // Set the color of the circle
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).colorScheme.text,
                  iconSize: 19.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
        expandedHeight: 450.0,
        actions: [
          CircleAvatar(
            radius: 22.0,
            backgroundColor: Theme.of(context).colorScheme.secondaryBg.withOpacity(.5), // Set the color of the circle
            child: IconButton(
              icon: (widget.wishlistLoading)
                  ? SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        backgroundColor: Theme.of(context).colorScheme.bg,
                      ),
                    )
                  : Obx(() => (wishlistController.wishlist.contains(int.parse(widget.data['post_id'])))
                      ? MsSvgIcon(
                          icon: 'assets/navigations/bold-favorite.svg',
                          size: 20.0,
                          color: Theme.of(context).colorScheme.primaryColor,
                        )
                      : MsSvgIcon(
                          icon: 'assets/navigations/favorite.svg',
                          size: 20.0,
                          color: Theme.of(context).colorScheme.text,
                        )),
              color: Theme.of(context).colorScheme.text,
              iconSize: 19.0,
              onPressed: () async {
                await widget.onTap();
              },
            ),
          ),
          SizedBox(width: 5.0),
          CircleAvatar(
            radius: 22.0,
            backgroundColor: Theme.of(context).colorScheme.secondaryBg.withOpacity(.5), // Set the color of the circle
            child: IconButton(
              icon: Icon(Icons.share),
              color: Theme.of(context).colorScheme.text,
              iconSize: 19.0,
              onPressed: () {
                Share.share(widget.data['url']);
              },
            ),
          ),
          SizedBox(width: 10.0),
        ],
        flexibleSpace: ProductGallerySlider(data: widget.data, slide: widget.slide));
  }
}
