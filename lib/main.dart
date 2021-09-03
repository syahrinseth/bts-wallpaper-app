/// Flutter code sample for CupertinoPageScaffold

// This example shows a [CupertinoPageScaffold] with a [ListView] as a [child].
// The [CupertinoButton] is connected to a callback that increments a counter.
// The [backgroundColor] can be changed.

import 'dart:io';
import 'dart:typed_data';

import 'package:bts_wallpaper_app/data/wallpaper.dart';
import 'package:bts_wallpaper_app/dummy_wallpaper.dart';
import 'package:bts_wallpaper_app/screens/wallpaper_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart' show SystemChrome, rootBundle;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  runApp(const MyApp());
}

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
  // int _count = 0;
  ScrollController scrollController = ScrollController();

  ///The controller of sliding up panel
  // SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    // scrollController.addListener(() {
    //   if (scrollController.offset >=
    //           scrollController.position.maxScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.expand();
    //   } else if (scrollController.offset <=
    //           scrollController.position.minScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.anchor();
    //   } else {}
    // });
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
            middle:
                GestureDetector(child: Text('BTS Wallpaper HD'), onTap: () {}),
            trailing: Icon(CupertinoIcons.square_split_2x2_fill, size: 20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.count(
              childAspectRatio: 0.65,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: DummyWallpaper.wallpapers,
            ),
          ),
        ),
      ],
    );
  }
}

class WallpaperCard extends StatelessWidget {
  WallpaperCard({required this.wallpaper});
  final Wallpaper wallpaper;
  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.info,
          child: const Text('Detail'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WallpaperDetailScreen(wallpaper: wallpaper)));
          },
        ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.arrow_down,
          child: const Text('Download'),
          onPressed: () {
            downloadWallpaper(context, wallpaper: wallpaper);
            Navigator.pop(context);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WallpaperDetailScreen(wallpaper: wallpaper)));
        },
        child: Container(
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
                        imageUrl: wallpaper.imageUri.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void downloadWallpaper(BuildContext context,
      {required Wallpaper wallpaper}) async {
    // get screen width and height
    // request for image
    var response = await Dio().get(wallpaper.imageUri.toString(),
        options: Options(responseType: ResponseType.bytes));
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      await Permission.storage.request().isGranted;
    }
    final result = await ImageGallerySaver.saveImage(response.data,
        quality: 80, name: "BTSWallpaper" + wallpaper.id.toString());
    if (result['isSuccess'] == true) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Wallpaper Saved.'),
          content: Text(''),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Okey'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
    } else {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Oops! Something went wrong. Please try again later.'),
          content: Text(''),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Okey'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
    }
  }
}
