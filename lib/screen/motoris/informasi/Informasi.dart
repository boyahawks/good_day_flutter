// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/motoris/Rayon.dart';
import 'package:good_day/utils/Api.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_day/widget/Alert.dart';
import 'package:intl/intl.dart';

class InformasiMotoris extends StatefulWidget {
  @override
  State<InformasiMotoris> createState() => _InformasiMotorisinState();
}

class _InformasiMotorisinState extends State<InformasiMotoris> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _InformasiMotorisinState createState() => _InformasiMotorisinState();

  TextEditingController tanggalMulai = TextEditingController();
  TextEditingController tanggalAkhir = TextEditingController();

  var hadiahKedai = [];
  int menu = 0;

  @override
  void initState() {
    getAllHadiahKedai();
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
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: logo(),
              ),
              Expanded(
                flex: 65,
                child: viewInformasi(),
              ),
              Expanded(
                flex: 15,
                child: gambarSaset(),
              )
            ],
          ),
        )
      ],
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getAllHadiahKedai() async {
    try {
      var formData = dio.FormData.fromMap({"user_id": AppData.userId});
      var response = await dio.Dio().post(
        Api.allHadiahSesuaiMotoris,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        hadiahKedai = data;
      });
    } catch (e) {
      setState(() {
        print(e);
        // Navigator.of(context).pop(true);
        // var alert = "Terjadi Kesalahan";
        // WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  aksiFilterDataKonfirmasiPembelian() async {
    WidgetAlert.showLoadingIndicator(context);
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
        "tanggal_awal": tanggalMulai.text,
        "tanggal_akhir": tanggalAkhir.text
      });
      var response = await dio.Dio().post(
        Api.allHadiahSesuaiMotorisFilterTanggal,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        Navigator.pop(context, true);
        if (status == true) {
          hadiahKedai.clear();
          var berhasil = "Data pembelian berhasil anda filter";
          WidgetAlert.showToast(context, berhasil);
          hadiahKedai = data;
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } on Exception catch (e) {
      setState(() {
        Navigator.of(context).pop(true);
        print(e);
        // var alert = "Terjadi Kesalahan";
        // WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget viewInformasi() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            flex: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 90,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(235, 253, 253, 253),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Hadiah Kedai",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 10,
                    child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          icon: Icon(
                            Icons.date_range_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              slidingFilterData();
                            });
                          },
                        )))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(flex: 90, child: listHadiahKedai())
        ],
      ),
    );
  }

  Widget listHadiahKedai() {
    return Container(
      margin: EdgeInsets.zero,
      child: hadiahKedai.isEmpty
          ? Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Data tidak ditemukan",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin + 40),
              itemCount: hadiahKedai.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                          child: hadiahKedai[index]['gambar_kedai'] == ''
                              ? Image.network(
                                  Api.controllerAssets + 'nothing.png')
                              : Image.network(Api.controllerGambar +
                                  hadiahKedai[index]['gambar_kedai']),
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
                                      Text(hadiahKedai[index]['nama_kedai'])),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, top: 5, right: 5),
                                  child:
                                      Text(hadiahKedai[index]['alamat_kedai'])),
                              Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child:
                                      Text(hadiahKedai[index]['nama_hadiah'])),
                              Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: Text(
                                      "Tanggal Klaim ${hadiahKedai[index]['tanggal_klaim']}")),
                              Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, top: 5),
                                  child: hadiahKedai[index]['status_hadiah'] ==
                                          "0"
                                      ? Text(
                                          "Belum ACC Admin",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : hadiahKedai[index]['status_hadiah'] ==
                                              "1"
                                          ? Text(
                                              "Hadiah Perlu di kirim",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 42, 204, 2),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : hadiahKedai[index]
                                                      ['status_hadiah'] ==
                                                  "2"
                                              ? Text(
                                                  "Hadiah sudah di terima",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 204, 65, 0),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text("tidak di ketahui")),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ))
                    ],
                  ),
                );
              }),
    );
  }

  slidingFilterData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Filter Data",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                DateTimeField(
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tanggal Mulai',
                  ),
                  controller: tanggalMulai,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DateTimeField(
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tanggal Sampai',
                  ),
                  controller: tanggalAkhir,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
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
                aksiFilterDataKonfirmasiPembelian();
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }

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
}
