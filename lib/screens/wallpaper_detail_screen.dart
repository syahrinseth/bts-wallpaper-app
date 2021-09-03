import 'package:bts_wallpaper_app/data/wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class WallpaperDetailScreen extends StatefulWidget {
  WallpaperDetailScreen({required this.wallpaper});
  final Wallpaper wallpaper;
  _WallpaperDetailScreen createState() => _WallpaperDetailScreen();
}

class _WallpaperDetailScreen extends State<WallpaperDetailScreen> {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.back))),
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    imageUrl: widget.wallpaper.imageUri.toString(),
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        downloadWallpaper(context, wallpaper: widget.wallpaper);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            CupertinoIcons.arrow_down,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ))
        ],
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
        quality: 60, name: "hello");
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
