import 'dart:io';
import 'dart:typed_data';
import 'package:dogs_wallpaper/ad_state.dart';
import 'package:dogs_wallpaper/ui/grid_images.dart';
import 'package:dogs_wallpaper/widgets/custom_dialog.dart';
import 'package:dogs_wallpaper/widgets/show_banner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class HomePage extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color _appColor = Colors.black87
  ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
                child: Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: _appColor,
                    body: buildBody()));
          }

  buildBody() {
    return Column(
      children: [
        Expanded(child: _selectModel()),
        Container(
            height: 50,
            child: ShowBanner(),
          )
      ],
    );
  }

  Widget _selectModel() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.80,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // String indexImg = (index + 1).toString();
              return GridImages(index: (index + 1).toString());
            },
            childCount: 120,
          ),
        ),
      ],
    );
  }
}

