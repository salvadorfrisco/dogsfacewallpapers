import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dogs_wallpaper/widgets/shadow_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../ad_state.dart';

class CustomDialog extends StatefulWidget {
  final String title,
      content,
      backgroundImage,
      positiveBtnText,
      negativeBtnText;
  final bool sameIndexSelected;
  final GestureTapCallback positiveBtnPressed;
  final GestureTapCallback negativeBtnPressed;

  CustomDialog({
    @required this.title,
    @required this.content,
    @required this.backgroundImage,
    @required this.positiveBtnText,
    @required this.negativeBtnText,
    @required this.sameIndexSelected,
    @required this.positiveBtnPressed,
    @required this.negativeBtnPressed,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _imageLoadComplete = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  final ButtonStyle negativeButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.red[600],
    minimumSize: Size(48, 48),
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  final ButtonStyle positiveButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.green[600],
    minimumSize: Size(80, 80),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
  );

  @override
  void initState() {
    _imageLoadComplete = false;
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    ));
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          // Bottom rectangular box
          margin:
              EdgeInsets.only(top: 30), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 8, vertical: 40), // spacing inside the box
          child: Stack(
            children: [
              !_imageLoadComplete && !widget.sameIndexSelected ?
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ) : Container(),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: (_connectionStatus == 'ConnectivityResult.none') ?
                Text("Internet fora do ar...") : Image.network(
                  widget.backgroundImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    if (loadingProgress.cumulativeBytesLoaded ==
                        loadingProgress.expectedTotalBytes) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {
                          _imageLoadComplete = true;
                        });
                      });
                    }
                    return Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white24,
                            child: Container()),
                        !widget.sameIndexSelected ?
                        Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ) : Container(),
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.content,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    _imageLoadComplete || widget.sameIndexSelected ? _listButtons() : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            margin: EdgeInsets.only(top: 110),
            child: _imageLoadComplete || widget.sameIndexSelected
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            // Top Circle with icon
                            maxRadius: 20.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/icon/phone.png'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            // Top Circle with icon
                            maxRadius: 20.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/icon/safari.png'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            // Top Circle with icon
                            maxRadius: 20.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/icon/chrome.png'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            // Top Circle with icon
                            maxRadius: 20.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/icon/icon.png'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ShadowText(
                        DateFormat('HH:mm').format(DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 40.0,
                            color: Color(0xffdedede)),
                      ),
                      ShadowText(
                        DateFormat('EEEE').format(DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              style: negativeButtonStyle,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 36.0,
              ),
              onPressed: widget.negativeBtnPressed,
            ),
          ),
        ),
      ],
    );
  }

  _listButtons() {
    return ButtonBar(
      buttonMinWidth: 200,
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          autofocus: true,
          style: positiveButtonStyle,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 56.0,
          ),
          onPressed: widget.positiveBtnPressed,
        ),
      ],
    );
  }
}
