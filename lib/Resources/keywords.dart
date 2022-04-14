// static const String baseUrl =
//     "https://us-central1-stockadvisory-f4983.cloudfunctions.net/app1";
const String baseUrl = "https://api.quicktrades.in";
const String websocketUrl = "http://3.7.8.146:3001";
const String getbrokertoken =  websocketUrl + '/getbrokertoken';

// static const String baseUrl =
//     "https://192.168.43.228:5001/stockadvisory-f4983/us-central1/app1";

// static const String baseUrl =
//     "http://192.168.1.44:5001/stockadvisory-f4983/us-central1/app1";
const String loginUrl = baseUrl + "/login";
const String registerUrl = baseUrl + "/register";
const String checkUid = baseUrl + "/checkuid";
const String add_package = baseUrl + "/updatepackage";
const String get_package = baseUrl + "/analystpackages";
const String purchasepackage = baseUrl + "/purchasepackage";
const String make_call = baseUrl + "/newcall";
const String advisorcountprofile = baseUrl + "/advisorcountprofile";
const String calls = baseUrl + "/getadvisorcalls";
const String randomCalls = baseUrl + "/randomcalls";
const String analyst = baseUrl + "/analysts";
const String subs = baseUrl + "/admin/get/subscribers";
const String update_certificate = baseUrl + "/admin/certificate";
const String get_certificat_status = baseUrl + "/get/cstatus";
const String walletWithdraw = baseUrl + "/withdraw";
const String sendNotiToken = baseUrl + "/admin/send/token";
const String analysisText = baseUrl + "/getpatterns";
const String gettitledeatils = baseUrl + "/patterndeatils";
const String tradercalls = baseUrl + "/tradercalls";
const String addmoney = baseUrl + '/addmoney';
const String gettxn = baseUrl + '/gettxn';
const String getbalance = baseUrl + '/getbalance';
const String getserverltp = websocketUrl + '/getserverltp';



const String instruments = "http://15.207.48.223:3300/get/instruments";
const String finstruments = websocketUrl+ "/searchinstrument";

// static const String awsLiveLtp = "http://15.207.48.223:3300/get/liveltp";
const String instrument_location =
    "/storage/emulated/0/Android/data/com.createwealth.trader";

const String personImage =
    "https://firebasestorage.googleapis.com/v0/b/stockadvisory-f4983.appspot.com/o/profile_photo%2Fperson.png?alt=media&token=8633f6ac-c739-441e-a425-59311f2f8373";
const String editProfile = "";

class Strings {
  static const String pid= 'pid';
  static const String walletpayment= 'walletpayment';
  static const String status_success= 'Success';
  static const String status_failed= 'Failed';
  static const String Cancelled= 'Cancelled';
  static const String appName = "Admin";
  static const String recordType = "recordtype";
  static const String subRecordType = "subrecordtype";
  static const String intraday = "Intraday";
  static const String positional = "Positional";
  static const String cnc = "Positional";
  static const String equity = "Equity";
  static const String fno = "F&O";
  static const String send = "Send";
  static const String buySell = "buysell";
  static const String instrumenthint = "Search eg: infy bse, nifty fut";
  static const String instrument_token = "instrumenttoken";
  static const String tradetype = "tradetype";

  //---------FORM-------
  static const String stockName = "Script Name";
  static const String scriptname = 'scriptname';
  static const String entryPriceo = "Entry Price";
  static const String entryPrice = "entryprice";
  static const String desc = "Description";

  static const String cmp = "Current Market Price (Optional)";
  static const String target0 = "targetprice";
  static const String target1 = "targetprice2";
  static const String target2 = "target_value_3";
  static const String target0o = "Target Price";
  static const String target1o = "Target Price 2";
  static const String target2o = "Target Price 3";
  static const String sl0 = "slprice";
  static const String all_call = "All";
  static const String ap_call = "Active/Pending";
  static const String closed_call = "Closed calls";
  static const String sl0o = "SL Price";
  static const String sl1 = "slprice2";
  static const String sl2 = "SL Price 3";
  static const String sl1o = "SL Price 2 ";
  static const String quantity = "Quantity (Optional)";
  static const String fcp = "FCP (Optional)";
  static const String sell = "Sell";
  static const String buy = "Buy";
  static const String future = "Future";
  static const String option = "Option";
  static const String type = "Type";
  static const String futureoroption = "FutureorOption";
  static const String call = "CE";
  static const String put = "PE";
  static const String callorput = "CallorPut";
  static const String strikePrice = "Strike Price";
  static const String active = "Active";
  static const String closed = "Closed";

  static const String profit = "Profit";
  static const String loss = "Loss";

  static const String all = "All";
  static const String inactive = "Inactive";
  static const String month = "Month";
  static const String added = "Added";
  static const String withdraw = "Withdraw";

  //------------PACKAGE DURATIONS-----------

  static const String singleCall = "One call";
  static const String oneDay = "One day";
  static const String oneWeek = "One week";
  static const String oneMonth = "One month";
  static const String threeMonths = "Three months";
  static const String sixMonths = "Six months";
  static const String oneYear = "One year";

  static const String pending = "Pending";
  static const String pendingCall = "Pending Call";
  static const String targethit = "Target Hit";
  static const String lossBooked = "Loss Booked";
  static const String accuracy = "Accuracy";
  static const String aaccuracy = "accuracy";
  static const String rrration = "RR Ratio";
  static const String maxProf = "Max Profit";
  static const String maxLoss = "Max Loss";
  static const String t1 = "Target 1";
  static const String t2 = "target 2";
  static const String s1 = "SL 1";
  static const String s2 = "SL 2";
  static const String closedCall = "Closed Call";
  static const String activeCall = "Active Call";
  static const String closedProfit = "Closed With Profit";
  static const String closedLoss = "Closed With Loss";
  static const String commodity = "Commodity";
  static const String currency = "Currency";
  static const String generate = "Generate Call";

  static const String name = "name";
  static const String fname = "fname";
  static const String lname = "lname";
  static const String email = "email";
  static const String uid = "uid";
  static const String aid = "aid";
  static const String phone = "mobile";
  static const String url = "url";
  static const String usertype = "usertype";
  static const String certificate_db = "certificate";
  static const String certificate_status = "certificate_status";
  static const String txnHistory = "Transaction History";
  static const String adviser = "My Advisers";
  static const String calls = "My Calls";
  static const String settings = "Settings";
  static const String logout = "Logout";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsOfUse = "Terms Of Use";
  static const String help = "Help";
  static const String profile_photo = "profile_photo";
  static const String amount = "amount";
  static const String duration = "duration";
  static const String status = "status";
  static const String entry_ltp = "entryltp";
  static const String certificate = "Certificate";

  //------SERVER KEYWORDS-------------
  static const String user_not_found = "User not found";
  static const String analysisImageUrl = "analysisimageurl";
  static const String analysisTitle = "analysistitle";
  static const String description = "description";
  static const String exchange = "exchange";
  static const String wallet = "wallet";
  static const String subscribersCount = "subscribers";
  static const String current_subscribers = "current_subscribers";
  static const String callss = "calls";
  static const String closedCallsWithProfit = "hit_calls";
  static const String closedCallsWithloss = "loss_calls";
  static const String activeCalls = "active_calls";
  static const String pendingCalls = "pending_calls";
  static const String cid = "cid";
  static const String date = "date";

  static const String nse = "NSE"; //EQUITY
  static const String bse = "BSE"; //EQUITY

  static const String mcx = "MCX"; //COMMODITY
  static const String bcd = "BCD"; //CURRENCY
  static const String cds = "CDS"; //CURRENCY

  static const String bfo = "BFO"; //FNO
  static const String nfo = "NFO"; //FNO

  static const String saving = "Saving";
  static const String current = "Current";

  //----PAYMENT DETAILS--------
  static const String pydetails = "pydetail";
  static const String google_pay = "google_pay";
  static const String phone_pay = "phone_pay";
  static const String upi_id = "upi_id";
  static const String acc_no = "acc_no";
  static const String IFSC_code = "IFSC_code";
  static const String acc_name = "acc_name";
  static const String acc_type = "acc_type";
  static const String famount = "Amount";
  static const String upiid = "UPI ID";
  static const String gPayNumber = "Google Pay Number";
  static const String phonepenumber = "PhonePe Number";
  static const String accNumber = "Account Number";
  static const String ifscCode = "IFSC Code";
  static const String accHolderName = "Account Holder Name";
  static const String submit = "Submit";

  //---------WITHDRAW WALLET/PAYMENT DETAILS----------
  static const String gpay = "gpay";
  static const String ppay = "ppay";
  static const String upi = "upi";
  static const String ifsc_code = "ifsc_code";
  static const String accname = "accname";
  static const String token = "token";
  static const String packageCount = "packageCount";

  static const String no_subscribed_adviser= 'No subscribed analyst';
  static const String tid = 'tid';
  static const String connect = 'Connect';
}

String callSharingText =
    "Get advice from industry experts on *Quicktrades*, Get 100 Rs welcome bonus on Quicktrades wallet. https://play.google.com/store/apps/details?id=com.createwealth.trader ";

double closingTime = 15.5;
double openingTime = 9.166666666666666;
String ltp = "ltp";

String SOMETHING_WENT_WRONG = 'QT3001';
String INVALID_REQUEST = 'QT3002';

String patterns= 'Patterns';
String Cancelled= 'Cancelled';


String appUrl =
    'https://play.google.com/store/apps/details?id=com.createwealth.trader';

String profile= 'Profile';
String exploreAdvisor= 'Explore analyst';
String tradingOpportunities= 'Analysis';
