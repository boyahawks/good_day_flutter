// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:good_day/screen/agen/Informasi_selesai_pembelian.dart';
import 'package:good_day/screen/motoris/Informasi_selesai_kunjungan.dart';
import 'package:good_day/screen/motoris/Kedai.dart';
import 'package:good_day/utils/Api.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_day/widget/Alert.dart';
import 'package:intl/intl.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class KonfirmasiPembelian extends StatefulWidget {
  @override
  State<KonfirmasiPembelian> createState() => _KonfirmasiPembelianinState();
}

class _KonfirmasiPembelianinState extends State<KonfirmasiPembelian> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _KonfirmasiPembelianinState createState() => _KonfirmasiPembelianinState();

  TextEditingController tanggalMulai = TextEditingController();
  TextEditingController tanggalAkhir = TextEditingController();

  var pembelian = [];
  var rowPembelian = [];

  @override
  void initState() {
    getDataKonfirmasi();
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
                  child: viewKonfirmasi(),
                ),
                Expanded(
                  flex: 15,
                  child: gambarSaset(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI

  getDataKonfirmasi() async {
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
      });
      var response = await dio.Dio().post(
        Api.allDataKonfirmasiPembelian,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print("$data");
      setState(() {
        pembelian = data;
      });
    } on Exception catch (e) {
      setState(() {
        // Navigator.of(context).pop(true);
        print(e);
      });
    }
  }

  aksiKonfirmasi() async {
    WidgetAlert.showLoadingIndicator(context);
    try {
      var formData =
          dio.FormData.fromMap({"id_laporan": rowPembelian[0]['id_laporan']});
      var response = await dio.Dio().post(
        Api.gantiStatusPembelian,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        Navigator.pop(context, true);

        if (status == true) {
          var berhasil = "Data pembelian berhasil anda konfirmasi";
          WidgetAlert.showToast(context, berhasil);
          getDataKonfirmasi();
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

  aksiFilterDataKonfirmasiPembelian() async {
    print(tanggalMulai.text);
    print(tanggalAkhir.text);
    print(AppData.userId);
    WidgetAlert.showLoadingIndicator(context);
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
        "tanggal_awal": tanggalMulai.text,
        "tanggal_akhir": tanggalAkhir.text
      });
      var response = await dio.Dio().post(
        Api.gantiStatusPembelianFilterData,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        Navigator.pop(context, true);
        if (status == true) {
          pembelian.clear();
          var berhasil = "Data pembelian berhasil anda filter";
          WidgetAlert.showToast(context, berhasil);
          pembelian = data;
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

  Widget viewKonfirmasi() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Text(
                    "Konfirmasi Pembelian Kedai",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Container(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => slidingFilterData(),
                        child: Icon(
                          Icons.date_range_sharp,
                          size: 25,
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: SizedBox(
              height: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 50,
                    child: Text(
                      "Kedai",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Text(
                      "Point",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "Tanggal",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.white,
          ),
          Expanded(
            flex: 82,
            child: pembelian.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Center(
                        child: Text(
                      "Data Pembelian belum tersedia",
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                : Container(
                    height: 420,
                    margin: EdgeInsets.zero,
                    child: ListView.builder(
                        itemCount: pembelian.length,
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 30),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    rowPembelian.clear();
                                    var id = pembelian[index]['id_laporan'];
                                    pembelian.forEach((element) {
                                      if (element['id_laporan'] == id) {
                                        rowPembelian.add(element);
                                      }
                                    });
                                    showDialogDetailPembelian();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "${pembelian[index]['nama_kedai']}",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "${pembelian[index]['point']}",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                      Expanded(
                                        flex: 30,
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "${pembelian[index]['tanggal_pembelian']}",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(height: 2, color: Colors.white)
                            ],
                          );
                        }),
                  ),
          )
        ],
      ),
    );
  }

  showDialogDetailPembelian() async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.4, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "DETAIL PEMBELIAN KEDAI",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "${rowPembelian[0]['nama_kedai']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 8),
                      child: Center(
                        child: Text("${rowPembelian[0]['alamat_kedai']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Tanggal Daftar",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['tanggal_daftar']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Point",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['point']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Freeze Hazelnut Macchiato",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p1']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Freeze Cookies N Cream",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p2']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Freeze Mocafrio",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p3']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Freeze Cho'Orange",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p4']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Cappucinno",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p5']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Chococinno",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p6']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "GD Mocacinno",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_p7']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Penukaran 120 bungkus",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['jumla_pbk']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Status Laporan",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": BELUM ACC",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Tanggal Pembelian",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Text(
                            ": ${rowPembelian[0]['tanggal_pembelian']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        validasiKonfirmasi();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 4, 4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                            child: Text(
                          "Konfirmasi Data",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    });
  }

  validasiKonfirmasi() {
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
                    "Konfirmasi Data ini ... ?",
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
                aksiKonfirmasi();
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
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
}
