// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_day/screen/motoris/Rayon.dart';
import 'package:dio/dio.dart' as dio;

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';
import 'package:good_day/utils/Data_aplikasi.dart';

class DashboardMotoris extends StatefulWidget {
  @override
  State<DashboardMotoris> createState() => _DashboardMotorisinState();
}

class _DashboardMotorisinState extends State<DashboardMotoris> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _DashboardMotorisinState createState() => _DashboardMotorisinState();

  List menu = [
    {
      "id": "1",
      "namaMenu": "Mulai Berkunjung",
      "icon": "assets/gambar/icon1.png"
    },
    {"id": "2", "namaMenu": "Konfirmasi", "icon": "assets/gambar/icon2.png"},
    {"id": "3", "namaMenu": "Hadiah", "icon": "assets/gambar/icon3.png"},
    {"id": "4", "namaMenu": "Informasi", "icon": "assets/gambar/icon4.png"},
  ];

  var idCluster = '';

  @override
  void initState() {
    getIdCluster();
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

  getIdCluster() async {
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
      });
      var response = await dio.Dio().post(
        Api.detailCluster,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      setState(() {
        print(data['id_cluster']);
        idCluster = data['id_cluster'];
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
        children: [bio(), listMenu()],
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
                      "Motoris",
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

  Widget listMenu() {
    return GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: menu.length,
        scrollDirection: menu.length - 1 > 7 ? Axis.horizontal : Axis.vertical,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: menu.length - 1 > 7 ? 200 : 200,
            childAspectRatio: menu.length - 1 > 7 ? 4 / 2 : 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 50),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (menu[index]['id'] == '1') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Rayon(idCluster)),
                    );
                  } else if (menu[index]['id'] == '2') {
                    Navigator.of(context).pushNamed('/konfirmasiPembelian');
                  } else if (menu[index]['id'] == '3') {
                    Navigator.of(context).pushNamed('/hadiah');
                  } else if (menu[index]['id'] == '4') {
                    Navigator.of(context).pushNamed('/informasiMotoris');
                  } else {
                    print("menu baru belum tersedia");
                  }
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset(menu[index]['icon']),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    menu[index]['namaMenu'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          );
        });
  }
}
