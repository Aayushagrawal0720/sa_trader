class Coupons {
  String id;
  String key;
  String value;
  String operations;
  String status;
  String enddate;
  String application_state;

  Coupons(
      {this.status,
      this.id,
      this.key,
      this.application_state,
      this.enddate,
      this.operations,
      this.value});
}
