// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/motoris/Kunjungan.dart';
import 'package:good_day/screen/motoris/Produk.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class DetailKedaiGrosir extends StatefulWidget {
  @override
  State<DetailKedaiGrosir> createState() => _DetailKedaiGrosirinState();

  // ignore: prefer_typing_uninitialized_variables
  var kedai;
  // ignore: use_key_in_widget_constructors
  DetailKedaiGrosir(this.kedai);
}

class _DetailKedaiGrosirinState extends State<DetailKedaiGrosir> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _DetailKedaiGrosirinState createState() => _DetailKedaiGrosirinState();

  List detailKedai = [];

  @override
  void initState() {
    getDetailKedai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: detailKedai.isEmpty
              ? Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 300),
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      flex: 20,
                      child: logo(),
                    ),
                    Expanded(
                      flex: 65,
                      child: viewKedai(),
                    ),
                    Expanded(
                      flex: 15,
                      child: gambarSaset(),
                    )

                    // bioKedai(),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // mulaiKunjungan(),
                  ],
                ),
        )
      ],
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getDetailKedai() async {
    print(widget.kedai);
    try {
      var formData = dio.FormData.fromMap({'id_kedai': widget.kedai});
      var response = await dio.Dio().post(
        Api.detailKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          detailKedai = data;
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
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

  Widget viewKedai() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 70, child: bioKedai()),
        Expanded(flex: 30, child: mulaiKunjungan()),
      ],
    );
  }

  Widget bioKedai() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  margin: const EdgeInsets.only(left: 10),
                  child: detailKedai[0]['gambar_kedai'] == ''
                      ? Image.network(Api.controllerAssets + 'nothing.png')
                      : Image.network(Api.controllerGambar +
                          detailKedai[0]['gambar_kedai']),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            detailKedai[0]['nama_kedai'],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            detailKedai[0]['alamat_kedai'],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Tanggal bergabung ${DateFormat('dd MMMM y').format(DateFormat('yyyy-MM-dd').parse(detailKedai[0]['tanggal_daftar']))}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget mulaiKunjungan() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
              height: 80,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      print("mulai kunjungan");
                      var idKedai = detailKedai[0]['id_kedai'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Produk(idKedai, 0, 0, 'roleGrosir')),
                      );
                    });
                  },
                  child: Image.asset("assets/gambar/icon5.png"))),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              "Mulai Belanja",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
