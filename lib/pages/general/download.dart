import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meqamax/classes/downloader.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/button.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  int progress = 0;
  bool showOpenButton = false;
  String taskId = '';

  action(id, status, value) {
    setState(() {
      taskId = id;
      progress = value;
    });
    if (status == DownloadTaskStatus.complete) {
      setState(() {
        showOpenButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Kataloq yüklə'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Ink(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryBg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Son kataloq', style: Theme.of(context).textTheme.mediumHeading),
              SizedBox(height: 20.0),
              MsButton(
                onTap: () {
                  Downloader downloader = Downloader();
                  downloader.init(action: action);
                  downloader.download('https://wp.betasayt.com/uploads/2023/12/well-known-11.zip');
                },
                title: 'Yüklə',
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  if (!showOpenButton) ...[
                    Expanded(
                      child: LinearProgressIndicator(value: progress / 100),
                    ),
                    SizedBox(width: 15.0),
                    Text('${progress.toString()}%'),
                  ] else ...[
                    Text('Kataloq yükləndi.'),
                    SizedBox(width: 15.0),
                    InkWell(
                      onTap: () {
                        Downloader downloader = Downloader();
                        downloader.openDownloadedFile(taskId);
                      },
                      child: Text(
                        'Faylı aç',
                        style: Theme.of(context).textTheme.link,
                      ),
                    )
                  ]
                ],
              ),
              MsButton(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                            initialChildSize: .7,
                            maxChildSize: .9,
                            minChildSize: .2,
                            expand: false,
                            builder: (context, controller) {
                              return ListView(
                                controller: controller,
                                children: const [
                                  Text(
                                      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).")
                                ],
                              );
                            });
                      });
                },
                title: 'Klikle',
              )
            ],
          ),
        ),
      ),
    );
  }
}
