import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../ad_state.dart';

class ShowBanner extends StatefulWidget {
  @override
  _ShowBannerState createState() => _ShowBannerState();
}

class _ShowBannerState extends State<ShowBanner> {

  BannerAd banner;

  @override
  Widget build(BuildContext context) {
    return  (banner == null) ?
      SizedBox(height: 50,) :
      AdWidget(ad: banner);
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
