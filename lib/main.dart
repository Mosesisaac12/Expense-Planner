import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import './widgets/chart.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ExpensePlanner());
}

class ExpensePlanner extends StatefulWidget {
  @override
  State<ExpensePlanner> createState() => _ExpensePlannerState();
}

class _ExpensePlannerState extends State<ExpensePlanner> {
  // late String titleInput;
  final List<Transaction> _usertransactions = [
    // Transaction(id: '1', title: 'shirt', amount: 400, date: DateTime.now()),
    // Transaction(id: '2', title: 'jeans', amount: 800, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      date: chosenDate,
      title: title,
      amount: amount,
    );

    setState(() {
      _usertransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        children: [
          Text('Show Chart'),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  Widget _buildBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Planner'),
            trailing: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    child:
                    Icon(CupertinoIcons.add);
                    _startAddNewTransaction(context);
                  },
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expense Planner'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                );
              })
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
            appBarTheme: AppBarTheme(
              titleTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                    headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                  .headline6,
            )),
        home: Builder(builder: (context) {
          final dynamic appBar = _buildBar();

          final mediaQuery = MediaQuery.of(context);

          final _isLandScape = mediaQuery.orientation == Orientation.landscape;

          final txListWidget = Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.65,
              width: mediaQuery.size.width,
              child: TransactionList(_usertransactions, _deleteTransaction));
          final pageBody = SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isLandScape)
                    ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
                  if (!_isLandScape)
                    ..._buildPortraitContent(mediaQuery, appBar, txListWidget)
                ],
              ),
            ),
          );
          return Platform.isIOS
              ? CupertinoPageScaffold(
                  child: pageBody,
                  navigationBar: appBar,
                )
              : Scaffold(
                  appBar: appBar,
                  body: pageBody,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Platform.isIOS
                      ? Container()
                      : Builder(
                          builder: (context) => FloatingActionButton(
                                child: Icon(Icons.add),
                                onPressed: () {
                                  _startAddNewTransaction(context);
                                },
                              )));
        }));
  }
}
