// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/Api.dart';
import '../widget/Alert.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LogininState();
}

class _LogininState extends State<Login> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _LogininState createState() => _LogininState();

  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Tap back again to leave'),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image:
                            AssetImage("assets/gambar/background-mobile.png"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 25,
                      child: logo(),
                    ),
                    Expanded(
                      flex: 50,
                      child: formLogin(),
                    ),
                    Expanded(
                      flex: 25,
                      child: gambarSaset(),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  login() async {
    WidgetAlert.showLoadingIndicator(context);
    try {
      var formData = dio.FormData.fromMap({
        "user_id": userId.text,
        "password": password.text,
      });
      var response = await dio.Dio().post(
        Api.loginPost,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        Navigator.pop(context, true);
        data.forEach((element) => {
              AppData.setNama = element['username'],
              AppData.setUserId = element['user_id'],
              AppData.setRole = element['role'],
            });
        if (status == true) {
          if (AppData.role == "2") {
            print("masuk dashboard motoris");
            // Get.to(() => DashboardMotoris(), transition: Transition.fadeIn);
            Navigator.of(context).pushNamed('/dashboardMotoris');
          } else if (AppData.role == "3") {
            print("masuk dashboard grosir");
            // Get.to(() => DashboardAgen(), transition: Transition.zoom);
            Navigator.of(context).pushNamed('/dashboardAgen');
          }
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } on Exception catch (e) {
      setState(() {
        Navigator.of(context).pop(true);
        var alert = "User id / password salah";
        WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }
  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget logo() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
      ),
    );
  }

  Widget formLogin() {
    return Container(
      margin: const EdgeInsets.only(right: 30, left: 30, top: 55, bottom: 100),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(176, 253, 253, 253),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "User Id",
                contentPadding: EdgeInsets.all(8),
              ),
              controller: userId,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Password",
                contentPadding: EdgeInsets.all(8),
              ),
              controller: password,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            width: 300,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 235, 54, 9)),
              onPressed: () {
                setState(() {
                  login();
                });
              },
              child: Text(
                "Login",
                style: TextStyle(
                  color: Color(0xffffffff),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gambarSaset() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_saset_web.png"),
      ),
    );
  }
}
