import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid
      ? "ca-app-pub-5668668662931095/3541059455"
      : "ca-app-pub-5668668662931095/1924725454";

  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, LoadAdError error) {
        print('Erro ao carregar o anúncio (Dogs): ${ad.adUnitId}, $error.');
    },
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name, data) =>
        print('Ad event: ${ad.adUnitId}, $name, $data.'),
    onApplicationExit: (ad) => print('Ad exit: ${ad.adUnitId}'),
    onNativeAdClicked: (nativeAd) => print('Native ad clicked: ${nativeAd.adUnitId}'),
    onNativeAdImpression: (nativeAd) =>
        print('Native ad impression: ${nativeAd.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) =>
        print('User rewarded: ${ad.adUnitId} ${reward.amount} ${reward.type}'),
  );
}