import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Services/quicktrades_transaction_service.dart';
import 'package:trader/widgets/TransactionHistoryCard.dart';
import 'package:trader/dataClasses/TransactionsClass.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  _appBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CupertinoNavigationBarBackButton(
              color: ColorsTheme.themeOrange,
            ),
            Text(
              "Transaction History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<QuicktradesTransactionService>(context, listen: false)
        .fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        backgroundColor: ColorsTheme.offWhite,
        title: Text(
          "Transaction History",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<QuicktradesTransactionService>(context, listen: false)
                .fetchTransactions();
            return true;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      Provider.of<QuicktradesTransactionService>(context,
                              listen: false)
                          .fetchTransactions();
                      return true;
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Consumer<QuicktradesTransactionService>(
                          builder: (context, snapshot, child) {
                        List<TransactionClass> _transactions;
                        bool isLoading = snapshot.isLoading();
                        bool ifError = snapshot.ifError();
                        String message = snapshot.getMessage();
                        if(!isLoading){
                          _transactions = snapshot.getTransaction();
                        }
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: isLoading
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: SpinKitChasingDots(
                                      color: ColorsTheme.themeOrange,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : ifError
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Text(
                                          message == null
                                              ? "Please try again"
                                              : message,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : _transactions.length == 0
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                              message == null
                                                  ? "no record found"
                                                  : message,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: _transactions.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return TransactionHistoryCard(
                                                _transactions[index]);
                                          }),
                        );
                      }),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
