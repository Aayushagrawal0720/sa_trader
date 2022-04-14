import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:share/share.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/analysis_title_detail_service.dart';
import 'package:trader/Services/full_analysis_image_service.dart';
import 'package:trader/Services/share_button_service.dart';
import 'package:trader/Services/trimarketwatch_ltp_service.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:http/http.dart';
import 'package:trader/pages/PatternDescriptionPage.dart';
import 'dart:ui' as ui;

class AnalysisDetailPage extends StatefulWidget {
  CallsClass _call;
  int index;

  AnalysisDetailPage(
    this._call,
    this.index,
  );

  @override
  _AnalysisDetailPageState createState() =>
      _AnalysisDetailPageState(_call, index);
}

class _AnalysisDetailPageState extends State<AnalysisDetailPage> {
  CallsClass _call;
  int index;
  static String _url;
  GlobalKey _globalKey = new GlobalKey();

  _AnalysisDetailPageState(this._call, this.index) {}

  Widget reco() {
    Widget premium = Container();

    if (_call.aacuracy != null && _call.aacuracy != "null") {
      double acc = double.parse(_call.aacuracy.replaceAll("%", ""));
      if (acc < 50) {
        premium = Container();
      } else {
        premium = ShapeOfView(
          shape: CutCornerShape(borderRadius: BorderRadius.circular(6)),
          child: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              // child: Text("Premium", style: TextStyle(color: Colors.white),),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 15,
                    offset: Offset(4, 4)),
                BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    offset: Offset(-4, -4)),
              ],
              color: ColorsTheme.mazarineblue),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Text(
              _call.intra_cnc,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        premium
      ],
    );
  }

  Widget status() {
    Color _color;
    switch (_call.status) {
      case Strings.active:
        {
          _color = Colors.orange;
          break;
        }
      case Strings.pending:
        {
          _color = Colors.amber;
          break;
        }
      case Strings.targethit:
        {
          _color = Colors.green;
          break;
        }
      case Strings.lossBooked:
        {
          _color = Colors.red;
          break;
        }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _color,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
            child: Text(
              _call.status,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
        Text(
          DateFormat("dd-MM-yyy hh:mm").format(_call.time),
          maxLines: 2,
          style: TextStyle(fontSize: 12, color: Colors.black),
        )
      ],
    );
  }

  Widget aProfile() {
    Color _color;
    String temp1 = _call.aacuracy.replaceAll("%", "");
    double a = double.parse(temp1);
    if (a <= 30) {
      _color = Colors.red;
    } else if (a > 31 && a <= 70) {
      _color = Colors.orange;
    } else if (a > 70) {
      _color = Colors.green;
    }
    String accuracy =
        "${double.parse(_call.aacuracy.replaceAll("%", "")).toStringAsFixed(2)}%";

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(_call.uUrl),
              ),
              title: Text(
                _call.uname,
                maxLines: 2,
                style: TextStyle(),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(
                    text: "${Strings.accuracy}: ",
                  ),
                  TextSpan(
                    text: accuracy,
                    style: TextStyle(color: _color),
                  )
                ]),
          )
        ],
      ),
    );
  }

  Widget ScriptName() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            child: Text(
              _call.scriptName,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Consumer<TriMarketWatchLtpService>(builder: (context, cps, child) {
            return RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Ltp: ",
                      ),
                      TextSpan(
                        text: cps.getNormalLtp(_call.it) == "null" ||
                                cps.getNormalLtp(_call.it) == null
                            ? "0.0"
                            : cps.getNormalLtp(_call.it),
                      )
                    ]));
          })
        ],
      ),
    );
  }

  Widget maxProLos_rrRatio() {
    double entrry = double.parse(_call.entryPrice);
    double sl = double.parse(_call.sl);
    double target = double.parse(_call.target);
    String rrString;

    if (_call.buySell == Strings.buy) {
      double n = double.parse((entrry - sl).toString());
      double d = double.parse((target - entrry).toString());
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    if (_call.buySell == Strings.sell) {
      double n = double.parse((sl - entrry).toString());
      double d = double.parse((entrry - target).toString());
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    String maxLoss = (double.parse(_call.entryPrice) - double.parse(_call.sl))
        .toStringAsFixed(2)
        .replaceAll("-", "");
    String maxProf =
        (double.parse(_call.entryPrice) - double.parse(_call.target))
            .toStringAsPrecision(3)
            .replaceAll("-", "");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.red),
                          children: [
                            TextSpan(text: "${Strings.maxLoss}: "),
                            TextSpan(text: maxLoss)
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "${Strings.maxProf}: "),
                            TextSpan(text: maxProf)
                          ])),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "${Strings.rrration}: ",
                        ),
                        TextSpan(text: rrString)
                      ])),
            )
          ],
        ),
      ),
    );
  }

  Widget closedWith() {
    String title = "";
    String value = "";
    Color _color = Colors.white;

    if (_call.status == Strings.targethit) {
      title = "Closed with profit: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.target))
          .toStringAsPrecision(3)
          .replaceAll("-", "");
      _color = Colors.green;
    }
    if (_call.status == Strings.lossBooked) {
      title = "Closed with loss: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.sl))
          .toStringAsPrecision(3)
          .replaceAll("-", "");
      _color = Colors.red;
    }

    return Container(
      child: RichText(
          text: TextSpan(style: TextStyle(color: _color), children: [
        TextSpan(text: title),
        TextSpan(text: value),
        TextSpan(text: "/Unit"),
      ])),
    );
  }

  Widget pricingDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: _call.buySell == Strings.sell
                            ? Colors.red
                            : Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
                    child: Text(
                      _call.buySell,
                      style: TextStyle(
                          color: _call.buySell == Strings.sell
                              ? Colors.red
                              : Colors.green),
                    ),
                  ),
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "${Strings.entryPriceo}: "),
                        TextSpan(text: _call.entryPrice),
                      ])),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t1}: \n"),
                            TextSpan(text: _call.target),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t2}: \n"),
                            TextSpan(text: _call.target1),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s1}: \n"),
                            TextSpan(text: _call.sl),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s2}: \n"),
                            TextSpan(text: _call.sl1),
                          ])),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //
          //     ],
          //   ),
          // ),
          // _call.equityDerivative == Strings.equity
          //     ? Container()
          //     : Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: RichText(
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //             text: TextSpan(
          //                 style: TextStyle(color: Colors.black),
          //                 children: [
          //                   TextSpan(
          //                     text: "Expiry Date: ",
          //                   ),
          //                   TextSpan(
          //                     text: _call.expiryDate,
          //                   ),
          //                 ])),
          //       ),
          _call.status == Strings.targethit ||
                  _call.status == Strings.lossBooked
              ? closedWith()
              : Container()
        ],
      ),
    );
  }

  //----------------------------------------------------------
  //--------------------IMAGE WIDGET--------------------------------------
  Widget analysisImage() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<FullAnalysisImageService>(context, listen: false)
                .setFullScreen(!Provider.of<FullAnalysisImageService>(context,
                        listen: false)
                    .getFullScreen());
            if (Provider.of<FullAnalysisImageService>(context, listen: false)
                .getOrientation()) {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeLeft]);
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 15, left: 15, right: 15),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Consumer<FullAnalysisImageService>(
                  builder: (context, snapshot, child) {
                return snapshot.getImgFile() == null
                    ? SpinKitChasingDots(
                        color: ColorsTheme.themeOrange,
                        size: 16,
                      )
                    : Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: ColorsTheme.themeOrange,
                              offset: Offset(0, 0),
                              spreadRadius: 3)
                        ], borderRadius: BorderRadius.circular(6)),
                        child: PinchZoomImage(
                          image: snapshot.getImgFile(),
                          zoomedBackgroundColor: Colors.black,
                          hideStatusBarWhileZooming: true,
                        ),
                      );
              }),
            ),
          ),
        ),
        Positioned(
            top: 0,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorsTheme.themeOrange, width: 5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/logo/quicktrades.png"),
              ),
            ))
      ],
    );
  }

  Widget fullscreenAnalysisImage() {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          Center(child: analysisImage()),
          Positioned(
              right: 10,
              top: 30,
              child: GestureDetector(
                onTap: () {
                  Provider.of<FullAnalysisImageService>(context, listen: false)
                      .setFullScreen(!Provider.of<FullAnalysisImageService>(
                              context,
                              listen: false)
                          .getFullScreen());
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }

  getImage() async {
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<FullAnalysisImageService>(context, listen: false)
        .setImgFile(null);
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    Response response = await get(Uri.parse(
      _call.analysisImageUrl,
    ));
    await file.writeAsBytes(response.bodyBytes);
    Provider.of<FullAnalysisImageService>(context, listen: false)
        .setImgFile(Image.file(file));
    var dImage = await decodeImageFromList(file.readAsBytesSync());
    int height = dImage.height;
    int width = dImage.width;
    Provider.of<FullAnalysisImageService>(context, listen: false)
        .setOrientation(height < width);
  }

  Widget analysisTextTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _call.analysisTitle,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      showAnalysisTextDetails();
                    },
                    child: Container(
                      child: Icon(
                        Icons.info,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  showAnalysisTextDetails() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PatternDescription(_call.analysisTitle),
            )));
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note: ",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  _call.description,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _shareCall() async {
    try {
      Provider.of<ShareButtonService>(context, listen: false)
          .setSharingMode(true, index);
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('${instrument_location}/screenshot.png');
      imgFile.writeAsBytes(pngBytes);

      var urls = ['${instrument_location}/screenshot.png'];

      Share.shareFiles(
        urls,
        subject: 'Share Call',
        text: callSharingText,
        // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Provider.of<FullAnalysisImageService>(context, listen: false)
            .getFullScreen()) {
          Provider.of<FullAnalysisImageService>(context, listen: false)
              .setFullScreen(
                  !Provider.of<FullAnalysisImageService>(context, listen: false)
                      .getFullScreen());
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return;
        }
        Navigator.pop(context);
        return;
      },
      child: Consumer<FullAnalysisImageService>(
          builder: (context, snapshot, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 1,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: ColorsTheme.offWhite,
                title: Text(
                  "Analysis Details",
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: _shareCall, child: Icon(Icons.share)),
                  )
                ],
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: SingleChildScrollView(
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              status(),
                              aProfile(),
                              Divider(
                                color: Colors.grey,
                              ),
                              reco(),
                              ScriptName(),
                              analysisImage(),
                              analysisTextTitle(),
                              maxProLos_rrRatio(),
                              pricingDetails(),
                              description()
                            ],
                          ),
                        )),
                  ),
                ),
              )),
            ),
            snapshot.getFullScreen() ? fullscreenAnalysisImage() : Container()
          ],
        );
      }),
    );
  }
}
