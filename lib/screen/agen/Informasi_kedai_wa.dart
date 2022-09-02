// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/agen/Detail_kedai_grosir.dart';
import 'package:good_day/screen/agen/List_pembelian_kedai.dart';
import 'package:good_day/screen/motoris/Kedai.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class InformasiKedaiWa extends StatefulWidget {
  @override
  State<InformasiKedaiWa> createState() => _InformasiKedaiWainState();

  var value;
  InformasiKedaiWa(this.value);
}

class _InformasiKedaiWainState extends State<InformasiKedaiWa> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _InformasiKedaiWainState createState() => _InformasiKedaiWainState();

  List<dynamic> allKedai = [];
  List<dynamic> allKedaiSearch = [];
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
    try {
      var formData = dio.FormData.fromMap({'id_rayon': widget.value});
      var response = await dio.Dio().post(
        Api.allKedaiGrosir,
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

  directWhatsapp(idKedai) async {
    var kedaiTerpilih = [];
    var userTerpilih = [];
    for (var i = 0; i < allKedai.length; i++) {
      if (allKedai[i]['id_kedai'] == idKedai) {
        kedaiTerpilih.add(allKedai[i]);
      }
    }

    try {
      var formData = dio.FormData.fromMap({
        "id_kedai": kedaiTerpilih[0]['id_kedai'],
      });

      var response = await dio.Dio().post(
        Api.detailKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      userTerpilih = data;
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
    }

    if (userTerpilih[0]['no_telpon'] == '') {
      var gagal = "Nomor Wa kosong... harap konfirmasi admin";
      WidgetAlert.showToast(context, gagal);
    } else {
      try {
        var response = await dio.Dio().get(
          Api.getPesanWa,
        );
        var data = response.data['data'];
        var status = response.data['status'];
        var message = response.data['message'];
        print(data);

        var isiPesan = data[0]['isi_pesan'];
        var gabunganPesan =
            "$isiPesan\nPoint Kedai ${kedaiTerpilih[0]['nama_kedai']}\n${userTerpilih[0]['point']}";
        var notujuan = userTerpilih[0]['no_telpon'];
        var filternohp = notujuan.substring(1);
        var kodeNegara = 62;
        var gabungNohp = "$kodeNegara$filternohp";
        print(gabunganPesan);
        print(gabungNohp);
        var whatsappURl_android =
            "whatsapp://send?phone=" + gabungNohp + "&text=" + gabunganPesan;
        var whatappURL_ios =
            "https://wa.me/$gabungNohp?text=${Uri.parse(gabunganPesan)}";

        if (Platform.isIOS) {
          // for iOS phone only
          if (await canLaunch(whatappURL_ios)) {
            await launch(whatappURL_ios, forceSafariVC: false);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
          }
        } else {
          // android , web
          if (await canLaunch(whatsappURl_android)) {
            await launch(whatsappURl_android);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
          }
        }
        ;
      } catch (e) {
        print(e);
        WidgetAlert.showAlertUmum(context, e);
      }
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
        Expanded(flex: 80, child: listKedai()),
      ],
    );
  }

  Widget title() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      margin: const EdgeInsets.only(left: 8),
                      child: Text(
                        "List Kedai",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListPembelianKedai()),
                  );
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Icon(
                  Icons.list_alt_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget searchKedai() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                        allKedai = allKedaiSearch.where((kedai) {
                          var kedaiName = kedai['nama_kedai'].toLowerCase();
                          return kedaiName.contains(text);
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
    });
  }

  Widget listKedai() {
    return SizedBox(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: allKedai.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  var idKedai = allKedai[index]['id_kedai'];
                  directWhatsapp(idKedai);
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
                        child: allKedai[index]['gambar_kedai'] == ''
                            ? Image.network(
                                Api.controllerAssets + 'nothing.png')
                            : Image.network(Api.controllerGambar +
                                allKedai[index]['gambar_kedai']),
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
}
