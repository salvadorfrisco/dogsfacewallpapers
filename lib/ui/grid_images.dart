import 'dart:io';

import 'package:dogs_wallpaper/services/storage_service.dart';
import 'package:dogs_wallpaper/widgets/circular_indicator.dart';
import 'package:dogs_wallpaper/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class GridImages extends StatefulWidget {
  final String index;

  GridImages({
    @required this.index,
  });

  @override
  _GridImagesState createState() => _GridImagesState();
}

class _GridImagesState extends State<GridImages> {
  // TODO colocar no theme
  Color _appColor = Colors.blueGrey;
  bool isLoading = false, isLoadingPositive = false;
  String indexSelected = '0', lastIndexSelected = '0', _actualPaper;
  bool positiveClicked = false;
  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getActualPaper(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
                child: Scaffold(
                    backgroundColor: _appColor,
                    body: showImageCard(widget.index)));
          } else
            return CircularIndicator();
        });
  }

  showImageCard(String index) {
    showImage() {
      showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black54, // s
        context: context, // pace around dialog
        transitionDuration: Duration(milliseconds: 800),
        transitionBuilder: (context, a1, a2, child) {
          return Stack(
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                    parent: a1,
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.easeOutCubic),
                child: CustomDialog(
                  // our custom dialog
                  title: "",
                  content: "",
                  // "Here goes the content of dialog. Here goes the content of dialog. Here goes the content of dialog.",
                  backgroundImage:
                      'https://pauliseguros.com.br/dogs_paper/$index.jpg',
                  positiveBtnText: "Done",
                  negativeBtnText: "Cancel",
                  sameIndexSelected: index == lastIndexSelected,
                  positiveBtnPressed: positiveAction,
                  negativeBtnPressed: negativeAction,
                ),
              ),
              isLoadingPositive
                  ? CircularIndicator()
                  : Container(),
            ],
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null;
        },
      );
      Future.delayed(const Duration(seconds: 1), () {
        lastIndexSelected = index;
      });
    }

    return GestureDetector(
      onTap: showImage,
      child: Card(
        color: _appColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/$index.jpg', fit: BoxFit.cover),
            (index == _actualPaper)
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 6.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 31.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0, right: 13.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.star,
                            color: Colors.lightBlue[50],
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  negativeAction() {
    Navigator.pop(context);
  }

  positiveAction() {
    if (!positiveClicked) {
      positiveClicked = true;
      isLoadingPositive = true;
      setPaper();
    }
  }

  setPaper() async {
    await setWallpaper(widget.index);
    closeApp();
  }

  closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  setWallpaper(String indexPaper) async {
    var result;
    var file = await DefaultCacheManager().getSingleFile(
        'https://pauliseguros.com.br/dogs_paper/$indexPaper.jpg');
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.HOME_SCREEN);
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      print(result);
    }
    await storage.setPaper("dog", indexPaper);
  }

  Future<String> getActualPaper() async {
    _actualPaper = await storage.getPaper('dog');
    return _actualPaper;
  }
}
