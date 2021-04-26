import 'package:dogs_wallpaper/ad_state.dart';
import 'package:dogs_wallpaper/ui/grid_images.dart';
import 'package:dogs_wallpaper/widgets/show_banner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BannerAd banner;

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
          height: banner == null ? 1 : 60,
          child: banner == null
              ? SizedBox(
            height: 1,
          )
              : ShowBanner(),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }
}

