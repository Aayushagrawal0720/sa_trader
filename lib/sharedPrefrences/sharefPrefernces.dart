import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenc {
  String UID = "uid";
  String FNAME = "fname";
  String LNAME = "lname";
  String EMAIL = "email";
  String PHOTOURL = "photourl";
  String PHONE = "phone";
  String ACCID = "accid";
  String REFEREDBY = "refered_by";
  String INFOPAGE = "infopage";
  String TOTALAMT = "totalamt";
  String OPTION_PAGE = "Option Page";
  String EXPANSESTARTED = "Expanse Started";
  String PACKAGEDONE = "Package Done";
  String SERVERVERIFICATION = "Server Verification";
  String DATETIMEINSTRUMENT = "DateTime";
  String WALLET = "Wallet";

  //BROKER CONNECTION KEYS
  String BROKERNAME = "broker_name";
  String BROKERUSERID = "broker_user_id";
  String BROKERUSERNAME = "broker_user_name";
  String BROKERUSEREMAIL = "broker_user_email";
  setUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(UID, uid);
  }

  setFName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FNAME, name);
  }

  setLName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LNAME, name);
  }

  setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EMAIL, email);
  }

  setPhotoUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHOTOURL, url);
  }

  setPhoneNumber(String ph) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHONE, ph);
  }

  setAccId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ACCID, id);
  }

  setTotalAmount(String amt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOTALAMT, amt);
  }

  setReferedBy(String rb) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(REFEREDBY, rb);
  }

  setInfoPage(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(INFOPAGE, ip);
  }

  setCertificateNumber(String cn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(OPTION_PAGE, cn);
  }

  setPackageDone(bool pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PACKAGEDONE, pp);
  }

  setServerVerification(int pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SERVERVERIFICATION, pp);
  }

  setInstrumentdate(String pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DATETIMEINSTRUMENT, pp);
  }

  setWallet(String pp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(WALLET, pp);
  }

  Future<String> getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(WALLET);
    return val;
  }

  Future<String> getInstrumentDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(DATETIMEINSTRUMENT);
    return val;
  }

  Future<int> getServerVerification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt(SERVERVERIFICATION);
    return val;
  }

  Future<bool> getPackageDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(PACKAGEDONE);
    return val;
  }

  Future<String> getCertificateNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(OPTION_PAGE);
    return val;
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(UID);
    return val;
  }

  Future<String> getFName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FNAME);
  }

  Future<String> getLName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LNAME);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL);
  }

  Future<String> getPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHOTOURL);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHONE);
  }

  Future<String> getACCID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCID);
  }

  Future<String> getTotalAmt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOTALAMT);
  }

  Future<String> getReferedBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REFEREDBY);
  }

  Future<String> getInfoPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(INFOPAGE);
  }

  //BROKER CONNECTION PREFERENCES
  setBrokerName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(BROKERNAME, name);
  }

  Future<String> getBrokerName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(BROKERNAME);
  }
  setBrokerUserId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(BROKERUSERID, id);
  }

  Future<String> getBrokerUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(BROKERUSERID);
  }
  setBrokerUserName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(BROKERUSERNAME, name);
  }

  Future<String> getBrokerUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(BROKERUSERNAME);
  }
  setBrokerUserEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(BROKERUSEREMAIL, email);
  }

  Future<String> getBrokerUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(BROKERUSEREMAIL);
  }

  removePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(UID);
    prefs.remove(FNAME);
    prefs.remove(LNAME);
    prefs.remove(EMAIL);
    prefs.remove(PHOTOURL);
  }
}
