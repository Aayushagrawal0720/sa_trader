import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Services/analysis_text_service.dart';
import 'package:trader/Services/analysis_title_detail_service.dart';
import 'package:trader/pages/PatternDescriptionPage.dart';

class AllPatterns extends StatefulWidget {
  const AllPatterns({Key key}) : super(key: key);

  @override
  _AllPatternsState createState() => _AllPatternsState();
}

class _AllPatternsState extends State<AllPatterns> {
  @override
  void initState() {
    super.initState();
    Provider.of<AnalysisTextService>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        backgroundColor: ColorsTheme.offWhite,
        title: Text(
          "Patterns",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(child:
          Consumer<AnalysisTextService>(builder: (context, snapshot, child) {
        List<String> _titles = snapshot.texts();

        return !snapshot.isLoading()
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Search...",
                            suffixIcon: Icon(Icons.search)),
                        onChanged: (val) {
                          Provider.of<AnalysisTextService>(context,
                                  listen: false)
                              .searchTitle(val);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _titles.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  snapshot.setSelected(_titles[index]);
                                  Navigator.push(
                                      context,
                                      fadePageRoute(context,
                                          PatternDescription(_titles[index])));
                                },
                                child: Container(
                                    color: index % 2 == 0
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${_titles[index]}"),
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )
            : Container(child: Text("Loading..."));
      })),
    );
  }
}
