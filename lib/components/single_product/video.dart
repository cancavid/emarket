import 'package:flutter/material.dart';
import 'package:meqamax/widgets_extra/dialog.dart';
import 'package:meqamax/widgets_extra/youtube_player.dart';

class SingleProductVideo extends StatelessWidget {
  final Map data;
  const SingleProductVideo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return (data['video'] != null && data['video'] != '')
        ? Column(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MsDialogContainer(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: MsYouTubePlayer(videoId: '0mXfEI6qpZc'),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.play_arrow, color: Colors.white, size: 17.0),
                      SizedBox(width: 5.0),
                      Text(
                        'Video',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
