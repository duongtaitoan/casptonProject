import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> testShowAlertDialog(context,uid) async {
//   assert(context != null);
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) => CupertinoAlertDialog(
//         title: Text("Message"),
//         content: Text("Kiểm tra thông tin"),
//         actions: <Widget>[
//           CupertinoButton(child: Text("Close"), onPressed: () async {
//             await Future.delayed(Duration(seconds: 1));
//             await Navigator.pushReplacementNamed(context, "/home");}),
//         ]),
//   );
// }


 // _showMyDialog(context) async {
  assert(context != null);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('Approve'),
            onPressed: () async {
              await Future.delayed(Duration(seconds: 1));
              await Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
