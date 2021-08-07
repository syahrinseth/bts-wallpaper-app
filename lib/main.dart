/// Flutter code sample for CupertinoPageScaffold

// This example shows a [CupertinoPageScaffold] with a [ListView] as a [child].
// The [CupertinoButton] is connected to a callback that increments a counter.
// The [backgroundColor] can be changed.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;
  ScrollController scrollController = ScrollController();

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    panelController.hide();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.hide();
      } else {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          // Uncomment to change the background color
          // backgroundColor: CupertinoColors.systemPink,
          navigationBar: CupertinoNavigationBar(
            leading: Icon(CupertinoIcons.bell_fill, size: 20.0),
            middle: GestureDetector(
                child: Text('BTS Wallpaper HD'),
                onTap: () => panelController.expand()),
            trailing: Icon(CupertinoIcons.square_split_2x2_fill, size: 20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.count(
              childAspectRatio: 0.65,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                // CupertinoButton(
                //   onPressed: () => setState(() => _count++),
                //   child: const Icon(CupertinoIcons.add),
                // ),
                // Center(
                //   child: Text('You have pressed the button $_count times.'),
                // ),
                WallpaperCard(
                    src:
                        'https://static.asiachan.com/V.%28Kim.Taehyung%29.full.2690.jpg'),
                WallpaperCard(
                    src:
                        'https://cdn1.i-scmp.com/sites/default/files/images/methode/2019/03/12/7348293c-3e24-11e9-b20a-0cdc8de4a6f4_image_hires_055900.jpg'),
                WallpaperCard(
                    src: 'https://static.asiachan.com/Suga.full.4446.jpg'),
                WallpaperCard(
                    src:
                        'https://static.asiachan.com/V.%28Kim.Taehyung%29.full.2690.jpg'),
                WallpaperCard(
                    src:
                        'https://cdn1.i-scmp.com/sites/default/files/images/methode/2019/03/12/7348293c-3e24-11e9-b20a-0cdc8de4a6f4_image_hires_055900.jpg'),
                WallpaperCard(
                    src: 'https://static.asiachan.com/Suga.full.4446.jpg'),
              ],
            ),
          ),
        ),
        SlidingUpPanelWidget(
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shadows: [
                BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: const Color(0x11000000))
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      // Icon(
                      //   CupertinoIcons.clear,
                      //   size: 30,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     left: 8.0,
                      //   ),
                      // ),
                      CupertinoButton(
                        onPressed: () {
                          panelController.hide();
                        },
                        child: Text(
                          'Close',
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
          controlHeight: 50.0,
          anchor: 0.4,
          panelController: panelController,
          onTap: () {
            ///Customize the processing logic
            if (SlidingUpPanelStatus.expanded == panelController.status) {
              panelController.hide();
            } else {
              panelController.expand();
            }
          }, //Pass a onTap callback to customize the processing logic when user click control bar.
          enableOnTap: true, //Enable the onTap callback for control bar.
          dragDown: (details) {
            print('dragDown');
          },
          dragStart: (details) {
            print('dragStart');
          },
          dragCancel: () {
            print('dragCancel');
          },
          dragUpdate: (details) {
            print(
                'dragUpdate,${panelController.status == SlidingUpPanelStatus.dragging ? 'dragging' : ''}');
          },
          dragEnd: (details) {
            print('dragEnd');
          },
        ),
      ],
    );
  }
}

class WallpaperCard extends StatelessWidget {
  WallpaperCard({required this.src});
  String src;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: IntrinsicWidth(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    imageUrl: src,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
