// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class WidgetAlert {
  // width: MediaQuery.of(context).size.width - 10,
  //       height: MediaQuery.of(context).size.height -  80,
  static showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 150,
                height: 150,
                color: Colors.transparent,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            child: Image.asset("assets/gambar/loading.png",
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                              child: Container(
                                child:
                                    CircularProgressIndicator(strokeWidth: 3),
                                height: 100,
                                width: 100,
                              ),
                              padding: EdgeInsets.only(bottom: 16)),
                        ],
                      ),
                      Padding(
                          child: Text(
                            'Please wait …',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.only(bottom: 4))
                    ])));
      },
    );
  }

  static showAlertUmum(BuildContext context, value) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      actions: [okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showToast(BuildContext context, value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Container(
            height: 50,
            color: Colors.transparent,
            child: Center(
                child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ))),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
