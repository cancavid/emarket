import 'package:flutter/material.dart';
import 'package:meqamax/pages/general/single_campaign.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/image.dart';

class SingleCampaignItem extends StatefulWidget {
  final Map data;

  const SingleCampaignItem({super.key, required this.data});

  @override
  State<SingleCampaignItem> createState() => _SingleCampaignItemState();
}

class _SingleCampaignItemState extends State<SingleCampaignItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SingleCampaign(data: widget.data)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: MsImage(
              url: widget.data['thumbnail_url'],
              width: double.infinity,
              height: 200.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            widget.data['post_title'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.smallHeading,
          ),
          const SizedBox(height: 5.0),
          Text(widget.data['post_date'], style: Theme.of(context).textTheme.extraSmallTitle)
        ],
      ),
    );
  }
}
