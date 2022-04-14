class AdvisorClass {
  String uid;
  String name;
  String url;
  String certificateNumber;
  String accuracy; //(targethit / closedcall) * 100
  String activeCalls;
  String targethit;
  String lossBooked;
  String closedCall;
  String subscribers;
  String current_subscribers;
  bool subscribed;

  AdvisorClass(
      {this.subscribed,
      this.accuracy,
      this.url,
      this.closedCall,
      this.lossBooked,
      this.targethit,
      this.uid,
      this.name,
      this.activeCalls,
      this.certificateNumber,
      this.subscribers,
      this.current_subscribers});
}
