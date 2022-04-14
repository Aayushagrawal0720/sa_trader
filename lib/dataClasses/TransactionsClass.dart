class TransactionClass {
  String txnid;
  String title;
  String subtitle;
  String amount;
  String date;
  String uid;
  String oid;
  String status;
  String dfrom;
  String cto;

  TransactionClass(
      {this.date,
      this.txnid,
      this.uid,
      this.amount,
      this.title,
      this.oid,
      this.subtitle,
      this.status,
      this.cto,
      this.dfrom});
}
