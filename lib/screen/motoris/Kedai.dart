// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations, prefer_is_empty

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/motoris/Detail_kedai.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class Kedai extends StatefulWidget {
  @override
  State<Kedai> createState() => _KedaiinState();

  var cluster, rayon;
  Kedai(this.cluster, this.rayon);
}

class _KedaiinState extends State<Kedai> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _KedaiinState createState() => _KedaiinState();

  var allKedai = [];
  var allKedaiSearch = [];
  bool isSearching = false;
  bool statusText = false;

  @override
  void initState() {
    getAllKedai();
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
          child: allKedai.isEmpty
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
                    // title(),
                    // searchKedai(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // viewKedai(),
                  ],
                ),
        )
      ],
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getAllKedai() async {
    print(widget.cluster);
    print(widget.rayon);
    try {
      var formData = dio.FormData.fromMap({
        'id_cluster': widget.cluster,
        'id_rayon': widget.rayon,
      });
      var response = await dio.Dio().post(
        Api.allKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          allKedai = data;
          allKedaiSearch = data;
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
        Expanded(flex: 10, child: title()),
        Expanded(flex: 10, child: searchKedai()),
        Expanded(
            flex: 80,
            child:
                allKedaiSearch.length != 0 ? listKedaiSearch() : listKedai()),
      ],
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            margin: const EdgeInsets.only(left: 8),
            child: Text(
              "LIST KEDAI - CLUSTER ${widget.cluster} - RAYON ${widget.rayon}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget searchKedai() {
    return Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 90,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari Kedai...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      statusText = true;
                      allKedaiSearch = allKedai.where((kedai) {
                        var namaKedai = kedai['nama_kedai'].toLowerCase();
                        return namaKedai.contains(text);
                      }).toList();
                    });
                  },
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ));
  }

  Widget listKedai() {
    return Container(
      margin: EdgeInsets.zero,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding:
              const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 40),
          itemCount: allKedai.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  var idKedai = allKedai[index]['id_kedai'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailKedai(idKedai)),
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 30,
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(left: 10),
                        child: allKedai[index]['gambar_kedai'] != ''
                            ? Image.network(Api.controllerGambar +
                                allKedai[index]['gambar_kedai'])
                            : Image.network(
                                Api.controllerAssets + 'nothing.png'),
                      ),
                    ),
                    Expanded(
                        flex: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 15, top: 25),
                                child: Text(allKedai[index]['nama_kedai'])),
                            Container(
                                margin: const EdgeInsets.only(left: 15, top: 8),
                                child: Text(allKedai[index]['alamat_kedai']))
                          ],
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget listKedaiSearch() {
    return SizedBox(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: allKedaiSearch.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  var idKedai = allKedaiSearch[index]['id_kedai'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailKedai(idKedai)),
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 30,
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(left: 10),
                        child: allKedai[index]['gambar_kedai'] != ''
                            ? Image.network(Api.controllerGambar +
                                allKedai[index]['gambar_kedai'])
                            : Image.network(
                                Api.controllerAssets + 'nothing.png'),
                      ),
                    ),
                    Expanded(
                        flex: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 15, top: 25),
                                child:
                                    Text(allKedaiSearch[index]['nama_kedai'])),
                            Container(
                                margin: const EdgeInsets.only(left: 15, top: 8),
                                child:
                                    Text(allKedaiSearch[index]['alamat_kedai']))
                          ],
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
