// Card(
//                   elevation: 10,
//                   child: Row(children: [
//                     Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Theme.of(context).primaryColor,
//                                 width: 2)),
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.all(15),
//                         child: Text(
//                             '\$ ${transactions[index].amount.toStringAsFixed(2)}',
//                             style: Theme.of(context).textTheme.bodyText1)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(transactions[index].title,
//                             style: Theme.of(context).textTheme.bodyText1),
//                         Text(
//                           DateFormat.yMMMd().format(transactions[index].date),
//                           style: Theme.of(context).textTheme.bodyText1,
//                         )
//                       ],
//                     )
//                   ]),
//                 );