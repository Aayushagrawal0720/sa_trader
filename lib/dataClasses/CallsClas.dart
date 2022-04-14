class CallsClass {
  String intra_cnc;
  String equityDerivative;
  String cid;
  String status;
  String uid;
  String uname;
  String uUrl;
  String scriptName;
  String
      aacuracy; //advisor's accuracy= (calls closed with profit/total no. of calls)%100.... done by server at the end of the day
  DateTime time;
  String buySell;
  String entryPrice;
  String target;
  String target1;
  String target2;
  String sl;
  String sl1;
  String sl2;
  String expiryDate;
  String closedPercentage;
  bool visible;
  String it;
  String analysisImageUrl;
  String analysisTitle;
  String description;
  String exchange;

  CallsClass(
      {this.intra_cnc,
      this.equityDerivative,
      this.uid,
      this.uname,
      this.status,
      this.sl2,
      this.aacuracy,
      this.buySell,
      this.cid,
      this.closedPercentage,
      this.entryPrice,
      this.expiryDate,
      this.scriptName,
      this.sl1,
      this.target,
      this.sl,
      this.target1,
      this.target2,
      this.time,
      this.uUrl,
      this.visible,
      this.it,
      this.analysisImageUrl,
      this.analysisTitle,
      this.description,
      this.exchange});
}
