// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_day/screen/agen/Informasi_kedai_wa.dart';
import 'package:good_day/screen/agen/Kedai_grosir.dart';
import 'package:good_day/screen/motoris/Rayon.dart';
import 'package:dio/dio.dart' as dio;

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';
import 'package:good_day/utils/Data_aplikasi.dart';

class DashboardAgen extends StatefulWidget {
  @override
  State<DashboardAgen> createState() => _DashboardAgeninState();
}

class _DashboardAgeninState extends State<DashboardAgen> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _DashboardAgeninState createState() => _DashboardAgeninState();

  var dataGrosir = [];

  @override
  void initState() {
    getDataGrosir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/gambar/background-mobile.png"),
                    fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: logo(),
                ),
                Expanded(
                  flex: 65,
                  child: viewDashboard(),
                ),
                Expanded(
                  flex: 15,
                  child: gambarSaset(),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  getDataGrosir() async {
    try {
      var formData = dio.FormData.fromMap({
        "username": AppData.username,
      });
      var response = await dio.Dio().post(
        Api.detailGrosir,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        dataGrosir = data;
      });
    } on Exception catch (e) {
      setState(() {
        Navigator.of(context).pop(true);
        var alert = "Terjadi kesalahan";
        WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  logout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Center(
                    child: Text(
                      "Keluar aplikasi...",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  setState(() {
                    AppData.setNama = '';
                    AppData.setUserId = '';
                    AppData.setRole = '';
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  });
                },
              ),
            ],
          );
        });
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET
  Widget logo() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
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

  Widget viewDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bio(),
          Menu1(),
          SizedBox(
            height: 20,
          ),
          Menu2()
        ],
      ),
    );
  }

  Widget bio() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 31, 16),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          border: Border.all(color: Colors.white, width: 0.8)),
      child: Row(
        children: [
          Expanded(
            flex: 20,
            child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                padding: const EdgeInsets.all(5),
                child: Image.asset("assets/gambar/user.png")),
          ),
          Expanded(
            flex: 70,
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppData.username,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Grosir",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    logout();
                  });
                },
                icon: Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Menu1() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            var idRayon = dataGrosir[0]['id_rayon'];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KedaiGrosir(idRayon)),
            );
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/gambar/icon5.png'),
            ),
            Text(
              "Pembelian",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget Menu2() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            var idRayon = dataGrosir[0]['id_rayon'];
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InformasiKedaiWa(idRayon)),
            );
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 102,
              width: 102,
              child: Image.asset('assets/gambar/icon4.png'),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Informasi",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
